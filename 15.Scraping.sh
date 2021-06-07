#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBSCRAPING" = true ]; then
    printf "${bblue}Running : Source code scraping subdomain search"
    touch $HOME/$domain/.tmp/scrap_subs.txt
    if [ -s "$HOME/$domain/subdomains/subdomains.txt" ]; then
        cat $HOME/$domain/subdomains/subdomains.txt | httpx -follow-host-redirects -random-agent -status-code -threads $HTTPX_THREADS -timeout $HTTPX_TIMEOUT -silent -retries 2 -no-color | cut -d ' ' -f1 | grep ".$domain$" | anew -q $HOME/$domain/.tmp/probed_tmp_scrap.txt
        [ -s "$HOME/$domain/.tmp/probed_tmp_scrap.txt" ] && cat $HOME/$domain/.tmp/probed_tmp_scrap.txt | httpx -csp-probe -random-agent -status-code -threads $HTTPX_THREADS -timeout $HTTPX_TIMEOUT -silent -retries 2 -no-color | cut -d ' ' -f1 | grep ".$domain$" | anew $HOME/$domain/.tmp/probed_tmp_scrap.txt | unfurl -u domains  | anew -q $HOME/$domain/.tmp/scrap_subs.txt
        [ -s "$HOME/$domain/.tmp/probed_tmp_scrap.txt" ] && cat $HOME/$domain/.tmp/probed_tmp_scrap.txt | httpx -tls-probe -random-agent -status-code -threads $HTTPX_THREADS -timeout $HTTPX_TIMEOUT -silent -retries 2 -no-color | cut -d ' ' -f1 | grep ".$domain$" | anew $HOME/$domain/.tmp/probed_tmp_scrap.txt | unfurl -u domains  | anew -q $HOME/$domain/.tmp/scrap_subs.txt
        if [ "$DEEP" = true ]; then
            [ -s "$HOME/$domain/.tmp/probed_tmp_scrap.txt" ] && gospider -S $HOME/$domain/.tmp/probed_tmp_scrap.txt --js -t $GOSPIDER_THREADS -d 3 --sitemap --robots -w -r > $HOME/$domain/.tmp/gospider.txt
        else
            [ -s "$HOME/$domain/.tmp/probed_tmp_scrap.txt" ] && gospider -S $HOME/$domain/.tmp/probed_tmp_scrap.txt --js -t $GOSPIDER_THREADS -d 2 --sitemap --robots -w -r > $HOME/$domain/.tmp/gospider.txt
        fi
        sed -i '/^.\{2048\}./d' $HOME/$domain/.tmp/gospider.txt
        [ -s "$HOME/$domain/.tmp/gospider.txt" ] && cat $HOME/$domain/.tmp/gospider.txt | grep -Eo 'https?://[^ ]+' | sed 's/]$//' | unfurl -u domains | grep ".$domain$" | anew -q $HOME/$domain/.tmp/scrap_subs.txt
        [ -s "$HOME/$domain/.tmp/scrap_subs.txt" ] && puredns resolve $HOME/$domain/.tmp/scrap_subs.txt -w $HOME/$domain/.tmp/scrap_subs_resolved.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
        NUMOFLINES=$(cat $HOME/$domain/.tmp/scrap_subs_resolved.txt | grep "\.$domain$\|^$domain$" | anew $HOME/$domain/subdomains/subdomains.txt | tee $HOME/$domain/.tmp/diff_scrap.txt | wc -l)
        [ -s "$HOME/$domain/.tmp/diff_scrap.txt" ] && cat $HOME/$domain/.tmp/diff_scrap.txt | httpx -follow-host-redirects -random-agent -status-code -threads $HTTPX_THREADS -timeout $HTTPX_TIMEOUT -silent -retries 2 -no-color | cut -d ' ' -f1 | grep ".$domain$" | anew -q $HOME/$domain/.tmp/probed_tmp_scrap.txt
        printf "\n${bgreen}${NUMOFLINES} new subs (code scraping)" ${FUNCNAME[0]}
    else
        printf "\n${bgreen}No subdomains to search (code scraping)" ${FUNCNAME[0]}
    fi
else
    if [ "$SUBSCRAPING" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi


