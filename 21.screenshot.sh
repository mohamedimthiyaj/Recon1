#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$WEBSCREENSHOT" = true ]; then
	printf "${bblue}Web Screenshots"
	cat $HOME/$domain/webs/webs.txt $HOME/$domain/webs/webs_uncommon_ports.txt 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/webs_screenshots.txt
	[ -s "$HOME/$domain/.tmp/webs_screenshots.txt" ] && webscreenshot -r chromium -i $HOME/$domain/.tmp/webs_screenshots.txt -w $WEBSCREENSHOT_THREADS -o $HOME/$domain/screenshots 2>>"$LOGFILE" &>/dev/null
	#gowitness file -f $HOME/$domain/.tmp/webs_screenshots.txt --disable-logging 2>>"$LOGFILE"
	printf "\n${bgreen}Results are saved in $HOME/$domain/screenshots folder" ${FUNCNAME[0]}
else
	if [ "$WEBSCREENSHOT" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi

