#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; then
    printf "${bblue}Running : Passive Subdomain Enumeration"
    subfinder -d $domain -all -o $HOME/$domain/.tmp/subfinder_psub.txt 
    assetfinder --subs-only $domain  | anew -q $HOME/$domain/.tmp/assetfinder_psub.txt
    amass enum -passive -d $domain -config $AMASS_CONFIG -o $HOME/$domain/.tmp/amass_psub.txt 
    findomain --quiet -t $domain -u $HOME/$domain/.tmp/findomain_psub.txt 
    timeout 10m waybackurls $domain | unfurl -u domains  | anew -q $HOME/$domain/.tmp/waybackurls_psub.txt
    timeout 10m gauplus -t $GAUPLUS_THREADS -random-agent -subs $domain | unfurl -u domains  | anew -q $HOME/$domain/.tmp/gau_psub.txt
    crobat -s $domain  | anew -q $HOME/$domain/.tmp/crobat_psub.txt
    if [ -s "${GITHUB_TOKENS}" ]; then
        if [ "$DEEP" = true ]; then
            github-subdomains -d $domain -t $GITHUB_TOKENS -o $HOME/$domain/.tmp/github_subdomains_psub.txt 
        else
            github-subdomains -d $domain -k -q -t $GITHUB_TOKENS -o $HOME/$domain/.tmp/github_subdomains_psub.txt 
        fi
    fi
    curl -s "https://jldc.me/anubis/subdomains/${domain}" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sed '/^\./d' | anew -q $HOME/$domain/.tmp/jldc_psub.txt
    if echo $domain | grep -q ".mil$"; then
        mildew
        mv mildew.out $HOME/$domain/.tmp/mildew.out
        [ -s "$HOME/$domain/.tmp/mildew.out" ] && cat $HOME/$domain/.tmp/mildew.out | grep ".$domain$" | anew -q $HOME/$domain/.tmp/mil_psub.txt
    fi
    NUMOFLINES=$(cat $HOME/$domain/.tmp/*_psub.txt 2>>"$LOGFILE" | sed "s/*.//" | anew $HOME/$domain/.tmp/passive_subs.txt | wc -l)
    printf "\n${bgreen}${NUMOFLINES} new subs (passive).Results are saved in $HOME/$domain/.tmp/passive_subs.txt" ${FUNCNAME[0]}
else
    printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
fi

