#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$METADATA" = true ] && [ "$OSINT" = true ]; then
    printf "${bblue}Scanning metadata in public files"
    metafinder -d "$domain" -l $METAFINDER_LIMIT -o $HOME/$domain/osint -go -bi -ba  
    printf "\n${bgreen}Results are saved in $domain/osint/[software/authors/metadata_results].txt" ${FUNCNAME[0]}
else
    if [ "$METADATA" = false ] || [ "$OSINT" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi
