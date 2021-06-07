#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBBRUTE" = true ]; then
    printf "${bblue}Running : Bruteforce Subdomain Enumeration"
    if [ "$DEEP" = true ]; then
        puredns bruteforce $subs_wordlist_big $domain -w $HOME/$domain/.tmp/subs_brute.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
    else
        puredns bruteforce $subs_wordlist $domain -w $HOME/$domain/.tmp/subs_brute.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
    fi
    [ -s "$HOME/$domain/.tmp/subs_brute.txt" ] && puredns resolve $HOME/$domain/.tmp/subs_brute.txt -w $HOME/$domain/.tmp/subs_brute_valid.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
    NUMOFLINES=$(cat $HOME/$domain/.tmp/subs_brute_valid.txt | sed "s/*.//" | grep ".$domain$" | anew $HOME/$domain/subdomains/subdomains.txt | wc -l)
    printf "\n${bgreen}${NUMOFLINES} new subs (bruteforce).Results are saved in $HOME/$domain/subdomains/subdomains.txt" ${FUNCNAME[0]}
else
    if [ "$SUBBRUTE" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi

