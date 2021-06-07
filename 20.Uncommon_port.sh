#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$WEBPROBEFULL" = true ]; then
	printf "${bblue}Http probing non standard ports"

	cat $HOME/$domain/subdomains/subdomains.txt | httpx -ports $UNCOMMON_PORTS_WEB -follow-host-redirects -random-agent -status-code -threads $HTTPX_UNCOMMONPORTS_THREADS -timeout $HTTPX_UNCOMMONPORTS_TIMEOUT -silent -retries 2 -no-color 2>>"$LOGFILE" | cut -d ' ' -f1 | grep ".$domain" | anew -q $HOME/$domain/.tmp/probed_uncommon_ports_tmp.txt

	NUMOFLINES=$(cat $HOME/$domain/.tmp/probed_uncommon_ports_tmp.txt 2>>"$LOGFILE" | anew $HOME/$domain/webs/webs_uncommon_ports.txt | wc -l)
	[ -s "$HOME/$domain/webs/webs_uncommon_ports.txt" ] && cat $HOME/$domain/webs/webs_uncommon_ports.txt
	printf "\n${bgreen}Results are saved in $domain/webs/webs_uncommon_ports.txt" ${FUNCNAME[0]}
	if [ "$PROXY" = true ] && [ -n "$proxy_url" ] && [[ $(cat $HOME/$domain/webs/webs_uncommon_ports.txt| wc -l) -le 1500 ]]; then
		notification "Sending websites uncommon ports to proxy" info
		ffuf -mc all -w $HOME/$domain/webs/webs_uncommon_ports.txt -u FUZZ -replay-proxy $proxy_url 2>>"$LOGFILE" &>/dev/null
	fi
else
	if [ "$WEBPROBEFULL" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi
