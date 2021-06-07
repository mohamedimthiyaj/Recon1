#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; then
    printf "${bblue}Running : DNS Subdomain Enumeration"
    dnsx -retry 3 -a -aaaa -cname -ns -ptr -mx -soa -resp -silent -l $HOME/$domain/subdomains/subdomains.txt -o $HOME/$domain/subdomains/subdomains_cname.txt -r $resolvers_trusted 
    cat $HOME/$domain/subdomains/subdomains_cname.txt | cut -d '[' -f2 | sed 's/.$//' | grep ".$domain$" | anew -q $HOME/$domain/.tmp/subdomains_dns.txt
    puredns resolve $HOME/$domain/.tmp/subdomains_dns.txt -w $HOME/$domain/.tmp/subdomains_dns_resolved.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
    NUMOFLINES=$(cat $HOME/$domain/.tmp/subdomains_dns_resolved.txt | grep "\.$domain$\|^$domain$" | anew $HOME/$domain/subdomains/subdomains.txt | wc -l)
    printf "\n${bgreen}${NUMOFLINES} new subs (dns resolution)" ${FUNCNAME[0]}
else
    printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
fi
