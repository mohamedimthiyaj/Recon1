#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBTAKEOVER" = true ]; then
	printf "${bblue}Looking for possible subdomain takeover"
	touch $HOME/$domain/.tmp/tko.txt
	[ -s "$HOME/$domain/webs/webs.txt" ] && cat $HOME/$domain/webs/webs.txt | nuclei -silent -t $HOME/nuclei-templates/takeovers/ -r $resolvers_trusted -o $HOME/$domain/.tmp/tko.txt
	NUMOFLINES=$(cat $HOME/$domain/.tmp/tko.txt 2>>"$LOGFILE" | anew $HOME/$domain/webs/takeover.txt | wc -l)
	if [ "$NUMOFLINES" -gt 0 ]; then
		notification "${NUMOFLINES} new possible takeovers found" info
	fi
	printf "\n${bgreen}Results are saved in $domain/webs/takeover.txt" ${FUNCNAME[0]}
else
	if [ "$SUBTAKEOVER" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi
