#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$CLOUD_IP" = true ]; then
	printf "${bblue}Cloud provider check"
	cd "$tools/ip2provider" || { echo "Failed to cd directory in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
	[ -s "$HOME/$domain/hosts/ips.txt" ] && cat $HOME/$domain/hosts/ips.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | ./ip2provider.py 2>>"$LOGFILE" | anew -q $HOME/$domain/hosts/cloud_providers.txt
	cd "$dir" || { echo "Failed to cd directory in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
	printf "\n${bgreen}Results are saved in $HOME/$domain/hosts/cloud_providers.txt" ${FUNCNAME[0]}
else
	if [ "$CLOUD_IP" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi


