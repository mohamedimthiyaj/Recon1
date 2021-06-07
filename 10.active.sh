#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; then
        printf "${bblue}Running : Active Subdomain Enumeration"
    [ -s "${inScope_file}" ] && cat ${inScope_file} $HOME/$domain/.tmp/inscope_subs.txt
    cat $HOME/$domain/.tmp/*_subs.txt | anew -q $HOME/$domain/.tmp/subs_no_resolved.txt
    [ -s "$HOME/$domain/.tmp/subs_no_resolved.txt" ] && puredns resolve $HOME/$domain/.tmp/subs_no_resolved.txt -w $HOME/$domain/.tmp/subdomains_tmp.txt -r $resolvers --resolvers-trusted $resolvers_trusted -l $PUREDNS_PUBLIC_LIMIT --rate-limit-trusted $PUREDNS_TRUSTED_LIMIT 
    NUMOFLINES=$(cat $HOME/$domain/.tmp/subdomains_tmp.txt | grep "\.$domain$\|^$domain$" | anew subdomains/subdomains.txt | wc -l)
    printf "\n${bgreen}${NUMOFLINES} new subs (active resolution)" ${FUNCNAME[0]}
else
    printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
fi
