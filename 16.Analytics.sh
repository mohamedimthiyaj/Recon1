#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$SUBANALYTICS" = true ]; then
	printf "${bblue}Running : Analytics Subdomain Enumeration"
	if [ -s "$HOME/$domain/.tmp/probed_tmp_scrap.txt" ]; then
		for sub in $(cat $HOME/$domain/.tmp/probed_tmp_scrap.txt); do
			python3 $tools/AnalyticsRelationships/Python/analyticsrelationships.py -u $sub 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/analytics_subs_tmp.txt
		done
		[ -s "$HOME/$domain/.tmp/analytics_subs_tmp.txt" ] && cat $HOME/$domain/.tmp/analytics_subs_tmp.txt 2>>"$LOGFILE" | grep "\.$domain$\|^$domain$" | sed "s/|__ //" | anew -q $HOME/$domain/.tmp/analytics_subs_clean.txt
		[ -s "$HOME/$domain/.tmp/analytics_subs_clean.txt" ] && puredns resolve $HOME/$domain/.tmp/analytics_subs_clean.txt -w $HOME/$domain/.tmp/analytics_subs_resolved.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 2>>"$LOGFILE" &>/dev/null
	fi
	NUMOFLINES=$(cat $HOME/$domain/.tmp/analytics_subs_resolved.txt 2>>"$LOGFILE" | anew $HOME/$domain/subdomains/subdomains.txt |  wc -l)
	printf "\n${bgreen}${NUMOFLINES} new subs (analytics relationship)" ${FUNCNAME[0]}
else
	if [ "$SUBANALYTICS" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi 
