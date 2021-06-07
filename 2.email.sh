#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$EMAILS" = true ] && [ "$OSINT" = true ]; then
    printf "${bblue}Searching emails/users/passwords leaks"
    emailfinder -d $domain | anew -q $HOME/$domain/emailfinder.txt
    [ -s "$HOME/$domain/emailfinder.txt" ] && cat $HOME/$domain/emailfinder.txt | awk 'matched; /^-----------------$/ { matched = 1 }' | anew -q $HOME/$domain/osint/emails.txt
    cd "$tools/theHarvester" || { echo "Failed to cd directory in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
    python3 theHarvester.py -d $domain -b all  > $dir/$HOME/$domain/harvester.txt
    cd "$dir" || { echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
    if [ -s "$HOME/$domain/harvester.txt" ]; then
        cat $HOME/$domain/harvester.txt | awk '/Emails/,/Hosts/' | sed -e '1,2d' | head -n -2 | sed -e '/Searching /d' -e '/exception has occurred/d' -e '/found:/Q' | anew -q $HOME/$domain/osint/emails.txt
        cat $HOME/$domain/harvester.txt | awk '/Users/,/IPs/' | sed -e '1,2d' | head -n -2 | sed -e '/Searching /d' -e '/exception has occurred/d' -e '/found:/Q' | anew -q $HOME/$domain/osint/users.txt
        cat $HOME/$domain/harvester.txt | awk '/Links/,/Users/' | sed -e '1,2d' | head -n -2 | sed -e '/Searching /d' -e '/exception has occurred/d' -e '/found:/Q' | anew -q $HOME/$domain/osint/linkedin.txt
    fi
    h8mail -t $domain -q domain --loose -c $tools/h8mail_config.ini -j $HOME/$domain/h8_results.json 
    [ -s "$HOME/$domain/h8_results.json" ] && cat $HOME/$domain/h8_results.json | jq -r '.targets[0] | .data[] | .[]' | cut -d '-' -f2 | anew -q $HOME/$domain/osint/h8mail.txt

    PWNDB_STATUS=$(timeout 15s curl -Is --socks5-hostname localhost:9050 http://pwndb2am4tzkvold.onion | grep HTTP | cut -d ' ' -f2)

    if [ "$PWNDB_STATUS" = 200 ]; then
        cd "$tools/pwndb" || { echo "Failed to cd directory in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
        python3 pwndb.py --target "@${domain}" | sed '/^[-]/d'|sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | sed '1,2d' | anew -q $HOME/$domain/osint/passwords.txt
        cd "$dir" || { echo "Failed to cd directory in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
    else
        text="${yellow}\n pwndb is currently down :(\n\n Check xjypo5vzgmo7jca6b322dnqbsdnp3amd24ybx26x5nxbusccjkm4pwid.onion${reset}\n"
        printf "${text}" && printf "${text}" | $NOTIFY
    fi
    printf "\n${bgreen}Results are saved in $domain/osint/[emails/users/h8mail/passwords].txt" ${FUNCNAME[0]}
else
    if [ "$EMAILS" = false ] || [ "$OSINT" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi

fi
