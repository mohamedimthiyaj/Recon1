#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$GITHUB_DORKS" = true ] && [ "$OSINT" = true ]; then
	 printf "${bblue}Github Dorks in process"
	if [ -s "${GITHUB_TOKENS}" ]; then
		if [ "$DEEP" = true ]; then
			python3 "$tools/GitDorker/GitDorker.py" -tf "${GITHUB_TOKENS}" -e "$GITDORKER_THREADS" -q "$domain" -p -ri -d "$tools/GitDorker/Dorks/alldorksv3" 2>>"$LOGFILE" | grep "\[+\]" | grep "git" | anew -q $HOME/$domain/osint/gitdorks.txt
		else
			python3 "$tools/GitDorker/GitDorker.py" -tf "${GITHUB_TOKENS}" -e "$GITDORKER_THREADS" -q "$domain" -p -ri -d "$tools/GitDorker/Dorks/medium_dorks.txt" 2>>"$LOGFILE" | grep "\[+\]" | grep "git" | anew -q $HOME/$domain/osint/gitdorks.txt
		fi
		sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" $HOME/$domain/osint/gitdorks.txt
	else
		printf "\n${bred} Required file ${GITHUB_TOKENS} not exists or empty${reset}\n"
	fi
	 printf "\n${bgreen}Results are saved in $domain/osint/gitdorks.txt" ${FUNCNAME[0]}
else
	if [ "$GITHUB_DORKS" = false ] || [ "$OSINT" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi