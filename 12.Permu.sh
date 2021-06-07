#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBPERMUTE" = true ]; then
    printf "${bblue}Running : Permutations Subdomain Enumeration"

    [ "$DEEP" = true ] && [ -s "$HOME/$domain/subdomains/subdomains.txt" ] && DNScewl --tL $HOME/$domain/subdomains/subdomains.txt -p $tools/permutations_list.txt --level=0 --subs --no-color | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl1.txt
    [ "$DEEP" = false ] && [ "$(cat $HOME/$domain/.tmp/subs_no_resolved.txt | wc -l)" -le 100 ] && DNScewl --tL $HOME/$domain/.tmp/subs_no_resolved.txt -p $tools/permutations_list.txt --level=0 --subs --no-color  | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl1.txt
    [ "$DEEP" = false ] && [ "$(cat $HOME/$domain/.tmp/subs_no_resolved.txt | wc -l)" -gt 100 ] && [ "$(cat $HOME/$domain/.tmp/subs_no_resolved.txt | wc -l)" -le 200 ] && DNScewl --tL $HOME/$domain/.tmp/subs_no_resolved.txt -p $tools/permutations_list.txt --level=0 --subs --no-color  | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl1.txt
    [ "$DEEP" = false ] && [ "$(cat $HOME/$domain/.tmp/subs_no_resolved.txt | wc -l)" -gt 200 ] && [ "$(cat $HOME/$domain/subdomains/subdomains.txt | wc -l)" -le 100 ] && DNScewl --tL subdomains/subdomains.txt -p $tools/permutations_list.txt --level=0 --subs --no-color  | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl1.txt
    [ -s "$HOME/$domain/.tmp/DNScewl1.txt" ] && puredns resolve $HOME/$domain/.tmp/DNScewl1.txt -w $HOME/$domain/.tmp/permute1_tmp.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT
    [ -s "$HOME/$domain/.tmp/permute1_tmp.txt" ] && cat $HOME/$domain/.tmp/permute1_tmp.txt | anew -q $HOME/$domain/.tmp/permute1.txt
    [ -s "$HOME/$domain/.tmp/permute1.txt" ] && DNScewl --tL $HOME/$domain/.tmp/permute1.txt -p $tools/permutations_list.txt --level=0 --subs --no-color | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl2.txt
    [ -s "$HOME/$domain/.tmp/DNScewl2.txt" ] && puredns resolve $HOME/$domain/.tmp/DNScewl2.txt -w $HOME/$domain/.tmp/permute2_tmp.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
    [ -s "$HOME/$domain/.tmp/permute2_tmp.txt" ] && cat $HOME/$domain/.tmp/permute2_tmp.txt | anew -q $HOME/$domain/.tmp/permute2.txt

    cat $HOME/$domain/.tmp/permute1.txt $HOME/$domain/.tmp/permute2.txt | anew -q $HOME/$domain/.tmp/permute_subs.txt

    if [ -f "$HOME/$domain/.tmp/permute_subs.txt" ]; then
        NUMOFLINES=$(cat $HOME/$domain/.tmp/permute_subs.txt  | grep ".$domain$" | anew $HOME/$domain/subdomains/subdomains.txt | wc -l)
    else
        NUMOFLINES=0
    fi
    printf "\n${bgreen}${NUMOFLINES} new subs (permutations)" ${FUNCNAME[0]}
else
    if [ "$SUBPERMUTE" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi 
