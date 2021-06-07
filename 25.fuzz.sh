#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$FUZZ" = true ]; then
	printf "${bblue}Web directory fuzzing"
	if [ "$HOME/$domain/webs/webs.txt" ]; then
		mkdir -p $HOME/$domain/fuzzing
		interlace -tL $HOME/$domain/webs/webs.txt -threads 10 -c "ffuf -mc all -fc 404 -ac -t ${FFUF_THREADS} -sf -s -H \"${HEADER}\" -w ${fuzz_wordlist} -maxtime ${FFUF_MAXTIME} -u  _target_/FUZZ -of csv -o _output_/_cleantarget_.csv -ac" -o $HOME/$domain/fuzzing 2>>"$LOGFILE" &>/dev/null

		for sub in $(cat $HOME/$domain/webs/webs.txt); do
			sub_out=$(echo $sub | sed -e 's|^[^/]*//||' -e 's|/.*$||')
			[ "$HOME/$domain/fuzzing/${sub_out}.csv" ] && cat $HOME/$domain/fuzzing/${sub_out}.csv | cut -d ',' -f2,5,6 | tr ',' ' ' | awk '{ print $2 " " $3 " " $1}' | tail -n +2 | sort -k1 | anew -q $HOME/$domain/fuzzing/${sub_out}.txt
			rm -f $HOME/$domain/fuzzing/${sub_out}.csv 2>>"$LOGFILE"
		done

		printf "\n${bgreen}Results are saved in $domain/fuzzing/*subdomain*.txt" ${FUNCNAME[0]}
	else
		printf "\n${bgreen}No $domain/web/webs.txts file found, fuzzing skipped " ${FUNCNAME[0]}
	fi
else
	if [ "$FUZZ" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi

