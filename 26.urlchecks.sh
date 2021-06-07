#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$URL_CHECK" = true ]; then
    printf "${bblue}URL Extraction"
    mkdir -p $HOME/$domain/js
    if [ "$HOME/$domain/webs/webs.txt" ]; then
        cat $HOME/$domain/webs/webs.txt | waybackurls | anew -q $HOME/$domain/.tmp/url_extract_tmp.txt
        cat $HOME/$domain/webs/webs.txt | gauplus -t $GAUPLUS_THREADS -subs | anew -q $HOME/$domain/.tmp/url_extract_tmp.txt
        diff_webs=$(diff <(sort -u $HOME/$domain/.tmp/probed_tmp.txt) <(sort -u $HOME/$domain/webs/webs.txt) | wc -l)
        if [ $diff_webs != "0" ] || [ ! -s "$HOME/$domain/.tmp/gospider.txt" ]; then
            if [ "$DEEP" = true ]; then
                gospider -S $HOME/$domain/webs/webs.txt --js -t $GOSPIDER_THREADS -d 3 --sitemap --robots -w -r > $HOME/$domain/.tmp/gospider.txt
            else
                gospider -S $HOME/$domain/webs/webs.txt --js -t $GOSPIDER_THREADS -d 2 --sitemap --robots -w -r > $HOME/$domain/.tmp/gospider.txt
            fi
        fi
        interlace -tL $HOME/$domain/webs/webs.txt -threads 10 -c "python3 $tools/ParamSpider/paramspider.py -d _target_ -l high -q -o _output_/_cleantarget_" -o output &>/dev/null
        find output/ -type f -exec cat {} \; | sed '/^FUZZ/d' | anew -q $HOME/$domain/.tmp/param_tmp.txt
        rm -rf output/ 2>>"$LOGFILE"
        [ -s "$HOME/$domain/.tmp/param_tmp.txt" ] && cat $HOME/$domain/.tmp/param_tmp.txt | anew -q $HOME/$domain/.tmp/gospider.txt
        sed -i '/^.\{2048\}./d' $HOME/$domain/.tmp/gospider.txt
        [ -s "$HOME/$domain/.tmp/gospider.txt" ] && cat $HOME/$domain/.tmp/gospider.txt | grep -Eo 'https?://[^ ]+' | sed 's/]$//' | grep ".$domain" | anew -q $HOME/$domain/.tmp/url_extract_tmp.txt
        if [ -s "${GITHUB_TOKENS}" ]; then
            github-endpoints -q -k -d $domain -t ${GITHUB_TOKENS} -o $HOME/$domain/.tmp/github-endpoints.txt 2>>"$LOGFILE" &>/dev/null
            [ -s "$HOME/$domain/.tmp/github-endpoints.txt" ] && cat $HOME/$domain/.tmp/github-endpoints.txt | anew -q $HOME/$domain/.tmp/url_extract_tmp.txt
        fi
        [ -s "$HOME/$domain/.tmp/url_extract_tmp.txt" ] && cat $HOME/$domain/.tmp/url_extract_tmp.txt | grep "${domain}" | grep -Ei "\.(js)" | anew -q $HOME/$domain/js/url_extract_js.txt
        if [ "$DEEP" = true ]; then
            [ "$HOME/$domain/js/url_extract_js.txt" ] && cat $HOME/$domain/js/url_extract_js.txt | python3 $tools/JSA/jsa.py | anew -q $HOME/$domain/.tmp/url_extract_tmp.txt
        fi
        [ -s "$HOME/$domain/.tmp/url_extract_tmp.txt" ] &&  cat $HOME/$domain/.tmp/url_extract_tmp.txt | grep "${domain}" | grep "=" | qsreplace -a 2>>"$LOGFILE" | grep -Eiv "\.(eot|jpg|jpeg|gif|css|tif|tiff|png|ttf|otf|woff|woff2|ico|pdf|svg|txt|js)$" | anew -q $HOME/$domain/.tmp/url_extract_tmp2.txt
        [ -s "$HOME/$domain/.tmp/url_extract_tmp2.txt" ] && cat $HOME/$domain/.tmp/url_extract_tmp2.txt | urldedupe -s -qs | anew -q $HOME/$domain/.tmp/url_extract_uddup.txt 2>>"$LOGFILE" &>/dev/null
        NUMOFLINES=$(cat $HOME/$domain/.tmp/url_extract_uddup.txt 2>>"$LOGFILE" | anew $HOME/$domain/webs/url_extract.txt | wc -l)
        printf "\n${bgreen}${NUMOFLINES} new urls with params" 
        printf "\n${bgreen}Results are saved in $domain/webs/url_extract.txt" ${FUNCNAME[0]}
        if [ "$PROXY" = true ] && [ -n "$proxy_url" ] && [[ $(cat $HOME/$domain/webs/url_extract.txt | wc -l) -le 1500 ]]; then
            printf "${bgreen}Sending urls to proxy" 
            ffuf -mc all -w $HOME/$domain/webs/url_extract.txt -u FUZZ -replay-proxy $proxy_url 2>>"$LOGFILE" &>/dev/null
        fi
    fi
else
    printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
fi

