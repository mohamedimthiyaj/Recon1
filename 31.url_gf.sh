#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$URL_GF" = true ]; then
    printf "${bblue}Vulnerable Pattern Search"
    mkdir -p $HOME/$domain/gf
    if [ "$HOME/$domain/webs/url_extract.txt" ]; then
        gf xss $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/xss.txt
        gf ssti $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/ssti.txt
        gf ssrf $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/ssrf.txt
        gf sqli $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/sqli.txt
        gf redirect $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/redirect.txt
        [ -f "$HOME/$domain/gf/ssrf.txt" ] && cat $HOME/$domain/gf/ssrf.txt | anew -q $HOME/$domain/gf/redirect.txt
        gf rce $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/rce.txt
        gf potential $HOME/$domain/webs/url_extract.txt | cut -d ':' -f3-5 |anew -q $HOME/$domain/gf/potential.txt
        [ -s "$HOME/$domain/.tmp/url_extract_tmp.txt" ] && cat $HOME/$domain/.tmp/url_extract_tmp.txt | grep -Eiv "\.(eot|jpg|jpeg|gif|css|tif|tiff|png|ttf|otf|woff|woff2|ico|pdf|svg|txt|js)$" | unfurl -u format %s://%d%p 2>>"$LOGFILE" | anew -q $HOME/$domain/gf/endpoints.txt
        gf lfi $HOME/$domain/webs/url_extract.txt | anew -q $HOME/$domain/gf/lfi.txt
    fi
    printf "\n${bgreen}Results are saved in $domain/gf folder" ${FUNCNAME[0]}
else
    if [ "$URL_GF" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi

