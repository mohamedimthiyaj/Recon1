#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$JSCHECKS" = true ]; then
    printf "${bblue}Javascript Scan"
    if [ "$HOME/$domain/js/url_extract_js.txt" ]; then
        printf "\n${yellow} Running : Fetching Urls 1/5${reset}\n"
        cat $HOME/$domain/js/url_extract_js.txt | cut -d '?' -f 1 | grep -iE "\.js$" | anew -q $HOME/$domain/js/jsfile_links.txt
        cat $HOME/$domain/js/url_extract_js.txt | subjs | anew -q $HOME/$domain/js/jsfile_links.txt
        printf "${yellow} Running : Resolving JS Urls 2/5${reset}\n"
        [ "$HOME/$domain/js/jsfile_links.txt" ] && cat $HOME/$domain/js/jsfile_links.txt | httpx -follow-redirects -random-agent -silent -timeout $HTTPX_TIMEOUT -threads $HTTPX_THREADS -status-code -retries 2 -no-color | grep "[200]" | cut -d ' ' -f1 | anew -q $HOME/$domain/js/js_livelinks.txt
        printf "${yellow} Running : Gathering endpoints 3/5${reset}\n"
        if [ "$HOME/$domain/js/js_livelinks.txt" ]; then
            interlace -tL $HOME/$domain/js/js_livelinks.txt -threads 10 -c "python3 $tools/LinkFinder/linkfinder.py -d -i _target_ -o cli >> $HOME/$domain/.tmp/js_endpoints.txt" &>/dev/null
        fi
        if [ "$HOME/$domain/.tmp/js_endpoints.txt" ]; then
            sed -i '/^\//!d' $HOME/$domain/.tmp/js_endpoints.txt
            cat $HOME/$domain/.tmp/js_endpoints.txt | anew -q $HOME/$domain/js/js_endpoints.txt
        fi
        printf "${yellow} Running : Gathering secrets 4/5${reset}\n"
        [ -"$HOME/$domain/js/js_livelinks.txt" ] && cat $HOME/$domain/js/js_livelinks.txt | nuclei -silent -t $HOME/nuclei-templates/exposures/tokens/ -r $resolvers_trusted -o $HOME/$domain/js/js_secrets.txt 2>>"$LOGFILE" &>/dev/null
        printf "${yellow} Running : Building wordlist 5/5${reset}\n"
        [ "$HOME/$domain/js/js_livelinks.txt" ] &&	cat $HOME/$domain/js/js_livelinks.txt | python3 $tools/getjswords.py 2>>"$LOGFILE" | anew -q $HOME/$domain/webs/dict_words.txt
        printf "\n${bgreen}Results are saved in $domain/js folder" ${FUNCNAME[0]}
    else
        printf "\n${bgreen}No JS urls found for $domain, function skipped" ${FUNCNAME[0]}
    fi
else
    if [ "$JSCHECKS" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi