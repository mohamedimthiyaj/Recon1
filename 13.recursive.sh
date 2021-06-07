#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBRECURSIVE" = true ] ; then

    printf "${bblue}Running : Subdomains recursive search"
    # Passive recursive
    if [ "$SUB_RECURSIVE_PASSIVE" = true ]; then
        for sub in $(cat ~/$domain/subdomains/subdomains.txt | rev | cut -d '.' -f 3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2); do
            subfinder -d $sub -all -silent 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/passive_recursive.txt
            assetfinder --subs-only $sub 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/passive_recursive.txt
            amass enum -passive -d $sub -config $AMASS_CONFIG 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/passive_recursive.txt
            findomain --quiet -t $sub 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/passive_recursive.txt
        done
        [ -s "$HOME/$domain/.tmp/passive_recursive.txt" ] && puredns resolve $HOME/$domain/.tmp/passive_recursive.txt -w $HOME/$domain/.tmp/passive_recurs_tmp.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 2>>"$LOGFILE" &>/dev/null
        [ -s "$HOME/$domain/.tmp/passive_recurs_tmp.txt" ] && cat $HOME/$domain/.tmp/passive_recurs_tmp.txt | anew -q ~/$domain/subdomains/subdomains.txt
    fi
    # Bruteforce recursive
    if [[ $(cat ~/$domain/subdomains/subdomains.txt | wc -l) -le 1000 ]]; then
        echo "" > $HOME/$domain/.tmp/brute_recursive_wordlist.txt
        for sub in $(cat ~/$domain/subdomains/subdomains.txt); do
            sed "s/$/.$sub/" $subs_wordlist >> $HOME/$domain/.tmp/brute_recursive_wordlist.txt
        done
        [ -s "$HOME/$domain/.tmp/brute_recursive_wordlist.txt" ] && puredns resolve $HOME/$domain/.tmp/brute_recursive_wordlist.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT -w $HOME/$domain/.tmp/brute_recursive_result.txt 2>>"$LOGFILE" &>/dev/null
        [ -s "$HOME/$domain/.tmp/brute_recursive_result.txt" ] && cat $HOME/$domain/.tmp/brute_recursive_result.txt | anew -q $HOME/$domain/.tmp/brute_recursive.txt
        [ -s "$HOME/$domain/.tmp/brute_recursive.txt" ] && DNScewl --tL $HOME/$domain/.tmp/brute_recursive.txt -p $tools/permutations_list.txt --level=0 --subs --no-color 2>>"$LOGFILE" | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl1_recursive.txt
        [ -s "$HOME/$domain/.tmp/DNScewl1_recursive.txt" ] && puredns resolve $HOME/$domain/.tmp/DNScewl1_recursive.txt -w $HOME/$domain/.tmp/permute1_recursive_tmp.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 2>>"$LOGFILE" &>/dev/null
        [ -s "$HOME/$domain/.tmp/permute1_recursive_tmp.txt" ] && cat $HOME/$domain/.tmp/permute1_recursive_tmp.txt 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/permute1_recursive.txt
        [ -s "$HOME/$domain/.tmp/permute1_recursive.txt" ] && DNScewl --tL $HOME/$domain/.tmp/permute1_recursive.txt -p $tools/permutations_list.txt --level=0 --subs --no-color 2>>"$LOGFILE" | tail -n +14 | grep ".$domain$" > $HOME/$domain/.tmp/DNScewl2_recursive.txt
        [ -s "$HOME/$domain/.tmp/DNScewl2_recursive.txt" ] && puredns resolve $HOME/$domain/.tmp/DNScewl2_recursive.txt -w $HOME/$domain/.tmp/permute2_recursive_tmp.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 2>>"$LOGFILE" &>/dev/null
        cat $HOME/$domain/.tmp/permute1_recursive.txt $HOME/$domain/.tmp/permute2_recursive_tmp.txt 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/permute_recursive.txt
        NUMOFLINES=$(cat $HOME/$domain/.tmp/permute_recursive.txt $HOME/$domain/.tmp/brute_recursive.txt 2>>"$LOGFILE" | grep "\.$domain$\|^$domain$" | anew ~/$domain/subdomains/subdomains.txt | wc -l)
        printf "\n${bgreen}${NUMOFLINES} new subs (recursive)" ${FUNCNAME[0]}
    else
        notification "Skipping Recursive BF: Too Many Subdomains" warn
    fi
else
    if [ "$SUBRECURSIVE" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi



