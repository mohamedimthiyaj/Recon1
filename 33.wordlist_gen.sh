#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$WORDLIST" = true ];	then
    printf "${bblue}Wordlist generation"
    if [ -s "$HOME/$domain/.tmp/url_extract_tmp.txt" ]; then
        cat $HOME/$domain/.tmp/url_extract_tmp.txt | unfurl -u keys 2>>"$LOGFILE" | sed 's/[][]//g' | sed 's/[#]//g' | sed 's/[}{]//g' | anew -q $HOME/$domain/webs/dict_words.txt
        cat $HOME/$domain/.tmp/url_extract_tmp.txt | unfurl -u values 2>>"$LOGFILE" | sed 's/[][]//g' | sed 's/[#]//g' | sed 's/[}{]//g' | anew -q $HOME/$domain/webs/dict_words.txt
        cat $HOME/$domain/.tmp/url_extract_tmp.txt | tr "[:punct:]" "\n" | anew -q $HOME/$domain/webs/dict_words.txt
    fi
    [ -s "$HOME/$domain/.tmp/js_endpoints.txt" ] && cat $HOME/$domain/.tmp/js_endpoints.txt | unfurl -u path 2>>"$LOGFILE" | anew -q $HOME/$domain/webs/dict_paths.txt
    [ -s "$HOME/$domain/.tmp/url_extract_tmp.txt" ] && cat $HOME/$domain/.tmp/url_extract_tmp.txt | unfurl -u path 2>>"$LOGFILE" | anew -q $HOME/$domain/webs/dict_paths.txt
    printf "\n${bgreen}Results are saved in $domain/webs/dict_[words|paths].txt" ${FUNCNAME[0]}
else
    if [ "$WORDLIST" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi

