#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$WAF_DETECTION" = true ]; then
	printf "${bblue}Website's WAF detection"
	if [ "$HOME/$domain/webs/webs.txt" ]; then
		wafw00f -i $HOME/$domain/webs/webs.txt -o $HOME/$domain/.tmp/wafs.txt 2>>"$LOGFILE" &>/dev/null
		if [ "$HOME/$domain/.tmp/wafs.txt" ]; then
			cat $HOME/$domain/.tmp/wafs.txt | sed -e 's/^[ \t]*//' -e 's/ \+ /\t/g' -e '/(None)/d' | tr -s "\t" ";" > $HOME/$domain/webs/webs_wafs.txt
			NUMOFLINES=$(cat $HOME/$domain/webs/webs_wafs.txt 2>>"$LOGFILE" | wc -l)
			printf "\n${bgreen}${NUMOFLINES} websites protected by waf"
			printf "\n${bgreen}Results are saved in $domain/webs/webs_wafs.txt" ${FUNCNAME[0]}
		else
			printf "\n${bgreen}No results found" ${FUNCNAME[0]}
		fi
	else
		printf "\n${bgreen}No websites to scan" ${FUNCNAME[0]}
	fi
else
	if [ "$WAF" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi


