#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$S3BUCKETS" = true ]; then
	printf "${bblue}AWS S3 buckets search"
	[ -s "$HOME/$domain/subdomains/subdomains.txt" ] && s3scanner scan -f $HOME/$domain/subdomains/subdomains.txt 2>>"$LOGFILE" | grep -iv "not_exist" | grep -iv "Warning:" | anew -q $HOME/$domain/.tmp/s3buckets.txt
	NUMOFLINES=$(cat $HOME/$domain/.tmp/s3buckets.txt 2>>"$LOGFILE" | anew $HOME/$domain/subdomains/s3buckets.txt | wc -l)
	if [ "$NUMOFLINES" -gt 0 ]; then
		notification "${NUMOFLINES} new S3 buckets found" info
	fi
	printf "\n${bgreen}Results are saved in $HOME/$domain/subdomains/s3buckets.txt" ${FUNCNAME[0]}
else
	if [ "$S3BUCKETS" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi
 
