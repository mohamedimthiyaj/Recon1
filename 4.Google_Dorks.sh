#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] && [ "$GOOGLE_DORKS" = true ] && [ "$OSINT" = true ]; then
    printf  "${bblue}Google Dorks in process"
    $tools/degoogle_hunter/degoogle_hunter.sh $domain | tee $HOME/$domain/osint/dorks.txt
    sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" $HOME/$domain/osint/dorks.txt
    printf "${bgreen}Results are saved in $domain/osint/dorks.txt" ${FUNCNAME[0]}
else
    if [ "$GOOGLE_DORKS" = false ] || [ "$OSINT" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} are already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi
