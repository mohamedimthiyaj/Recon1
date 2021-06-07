#!/usr/bin/env bash
source $HOME/Recon/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$WEBPROBESIMPLE" = true ]; then
	printf "${bblue}Running : Http probing $domain"
	if [ -s "$HOME/$domain/.tmp/probed_tmp_scrap.txt" ]; then
		mv $HOME/$domain/.tmp/probed_tmp_scrap.txt $HOME/$domain/.tmp/probed_tmp.txt
	else
		cat $HOME/$domain/subdomains/subdomains.txt | httpx -follow-host-redirects -random-agent -status-code -threads $HTTPX_THREADS -timeout $HTTPX_TIMEOUT -silent -retries 2 -no-color | cut -d ' ' -f1 | grep ".$domain$" | anew -q $HOME/$domain/.tmp/probed_tmp.txt
	fi
	if [ -s "$HOME/$domain/.tmp/probed_tmp.txt" ]; then
		NUMOFLINES=$(cat $HOME/$domain/.tmp/probed_tmp.txt 2>>"$LOGFILE" | anew $HOME/$domain/webs/webs.txt | wc -l)
		printf "\n${bgreen}${NUMOFLINES} new websites resolved" ${FUNCNAME[0]}
		if [ "$PROXY" = true ] && [ -n "$proxy_url" ] && [[ $(cat $HOME/$domain/webs/webs.txt| wc -l) -le 1500 ]]; then
			notification "Sending websites to proxy" info
			ffuf -mc all -w $HOME/$domain/webs/webs.txt -u FUZZ -replay-proxy $proxy_url 2>>"$LOGFILE" &>/dev/null
		fi
	else
		end_subfunc "No new websites to probe" ${FUNCNAME[0]}
	fi
else
	if [ "$WEBPROBESIMPLE" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi


