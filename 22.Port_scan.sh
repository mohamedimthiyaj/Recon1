#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$PORTSCANNER" = true ]; then
	printf "${bblue}Port scan"
	#interlace -tL subdomains/subdomains.txt -threads 50 -c 'echo "_target_ $(dig +short a _target_ | tail -n1)" | anew -q _output_' -o $HOME/$domain/.tmp/subs_ips.txt
	resolveDomains -d $HOME/$domain/subdomains/subdomains.txt -t $RESOLVE_DOMAINS_THREADS 2>>"$LOGFILE" | anew -q $HOME/$domain/.tmp/subs_ips.txt
	awk '{ print $2 " " $1}' $HOME/$domain/.tmp/subs_ips.txt | sort -k2 -n | anew -q $HOME/$domain/hosts/subs_ips_vhosts.txt
	cat $HOME/$domain/hosts/subs_ips_vhosts.txt | cut -d ' ' -f1 | grep -Eiv "^(127|10|169\.154|172\.1[6789]|172\.2[0-9]|172\.3[01]|192\.168)\." | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | anew -q $HOME/$domain/hosts/ips.txt
	cat $HOME/$domain/hosts/ips.txt | cf-check | grep -Eiv "^(127|10|169\.154|172\.1[6789]|172\.2[0-9]|172\.3[01]|192\.168)\." | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | anew -q $HOME/$domain/.tmp/ips_nowaf.txt
	printf "${bblue}\n Resolved IP addresses (No WAF) ${reset}\n\n";
	cat $HOME/$domain/.tmp/ips_nowaf.txt | sort
	printf "${bblue}\n Scanning ports... ${reset}\n\n";
	if [ "$PORTSCAN_PASSIVE" = true ] && [ ! -f "$HOME/$domain/hosts/portscan_passive.txt" ]; then
		for sub in $(cat $HOME/$domain/hosts/ips.txt); do
			shodan host $sub 2>/dev/null >> hosts/portscan_passive.txt && echo -e "\n\n#######################################################################\n\n" >> $HOME/$domain/hosts/portscan_passive.txt
		done
	fi
	if [ "$PORTSCAN_ACTIVE" = true ]; then
		[ -s "$HOME/$domain/.tmp/ips_nowaf.txt" ] && sudo nmap --top-ports 1000 -sV -n --max-retries 2 -Pn -iL $HOME/$domain/.tmp/ips_nowaf.txt -oN $HOME/$domain/hosts/portscan_active.txt -oG $HOME/$domain/.tmp/portscan_active.gnmap 2>>"$LOGFILE" &>/dev/null
	fi
	 printf "\n${bgreen}Results are saved in hosts/portscan_[passive|active].txt" ${FUNCNAME[0]}
else
	if [ "$PORTSCANNER" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi
