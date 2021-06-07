#!/usr/bin/env bash
source ~/Recon/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$CMS_SCANNER" = true ]; then
	printf "${bblue}CMS Scanner"
	mkdir -p ~/$domain/cms && rm -rf ~/$domain/cms/*
	if [ "~/$domain/webs/webs.txt" ]; then
		tr '\n' ',' < ~/$domain/webs/webs.txt > .tmp/cms.txt
		timeout -k 30 $CMSSCAN_TIMEOUT python3 $tools/CMSeeK/cmseek.py -l .tmp/cms.txt --batch 2>>"$LOGFILE" &>/dev/null
		exit_status=$?
		if [[ $exit_status -eq 125 ]]; then
			echo "TIMEOUT cmseek.py - investigate manually for $dir" &>>"$LOGFILE"
			printf "\n${bgreen}TIMEOUT cmseek.py - investigate manually for $dir" ${FUNCNAME[0]}
			return
		elif [[ $exit_status -ne 0 ]]; then
			echo "ERROR cmseek.py - investigate manually for $dir" &>>"$LOGFILE"
			printf "\n${bgreen}ERROR cmseek.py - investigate manually for $dir" ${FUNCNAME[0]}
			return
		fi	# otherwise Assume we have a successfully exited cmseek
		for sub in $(cat ~/$domain/webs/webs.txt); do
			sub_out=$(echo $sub | sed -e 's|^[^/]*//||' -e 's|/.*$||')
			cms_id=$(cat $tools/CMSeeK/Result/${sub_out}/cms.json 2>>"$LOGFILE" | jq -r '.cms_id')
			if [ -z "$cms_id" ]; then
				rm -rf $tools/CMSeeK/Result/${sub_out}
			else
				mv -f $tools/CMSeeK/Result/${sub_out} ~/$domain/cms/
			fi
		done
		printf "\n${bgreen}Results are saved in $domain/cms/*subdomain* folder" ${FUNCNAME[0]}
	else
		printf "\n${bgreen}No $domain/web/webs.txts file found, cms scanner skipped" ${FUNCNAME[0]}
	fi
else
	if [ "$CMS_SCANNER" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi
