#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBCRT" = true ]; then
    printf "${bblue}Running : Crtsh Subdomain Enumeration"
    python3 $tools/ctfr/ctfr.py -d $domain -o $HOME/$domain/.tmp/crtsh_subs_tmp.txt 
    curl "https://tls.bufferover.run/dns?q=.${domain}" | jq -r .Results[]  | cut -d ',' -f3 | grep -F ".$domain" | anew -q $HOME/$domain/.tmp/crtsh_subs_tmp.txt
    curl "https://dns.bufferover.run/dns?q=.${domain}"  | jq -r '.FDNS_A'[],'.RDNS'[] | cut -d ',' -f2 | grep -F ".$domain" | anew -q $HOME/$domain/.tmp/crtsh_subs_tmp.txt
    NUMOFLINES=$(cat $HOME/$domain/.tmp/crtsh_subs_tmp.txt  | anew $HOME/$domain/.tmp/crtsh_subs.txt | wc -l)
    printf "\n${bgreen}${NUMOFLINES} new subs (cert transparency)" ${FUNCNAME[0]}
else
    if [ "$SUBCRT" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi
 
