#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$PARAMS" = true ]; then
    printf "${bblue}Parameter Discovery"
    if [ -s "$HOME/$domain/.tmp/url_extract_uddup.txt" ]; then
        if [ "$DEEP" = true ]; then
            arjun -i $HOME/$domain/.tmp/url_extract_uddup.txt -t $ARJUN_THREADS -oT $HOME/$domain/webs/param.txt 2>>"$LOGFILE" &>/dev/null
        elif [[ $(cat $HOME/$domain/.tmp/url_extract_uddup.txt | wc -l) -le 50 ]]; then
                arjun -i $HOME/$domain/.tmp/url_extract_uddup.txt -t $ARJUN_THREADS -oT $HOME/$domain/webs/param.txt 2>>"$LOGFILE" &>/dev/null
        else
            printf "\n${bgreen}Skipping Param discovery: Too many URLs to test, try with --deep flag" ${FUNCNAME[0]}
        fi
        [ "$HOME/$domain/webs/param.txt" ] && cat $HOME/$domain/webs/param.txt | anew -q $HOME/$domain/webs/url_extract.txt
    fi
    printf "\n${bgreen}Results are saved in $domain/webs/param.txt" ${FUNCNAME[0]}
else
    if [ "$PARAMS" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi
