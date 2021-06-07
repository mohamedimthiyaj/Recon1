#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$ZONETRANSFER" = true ]; then
	printf "${bblue}Zone transfer check"
	python3 $tools/dnsrecon/dnsrecon.py -d $domain -a -j $HOME/$domain/subdomains/zonetransfer.json 2>>"$LOGFILE" &>/dev/null
	if [ -s "$HOME/$domain/subdomains/zonetransfer.json" ]; then
		if grep -q "\"zone_transfer\"\: \"success\"" $HOME/$domain/subdomains/zonetransfer.json ; then printf "\n${bgreen}Zone transfer found on ${domain}!" ; fi
	fi
	printf "\n${bgreen}Results are saved in $domain/subdomains/zonetransfer.txt" ${FUNCNAME[0]}
else
	if [ "$ZONETRANSFER" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi

