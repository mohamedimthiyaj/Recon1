#!/usr/bin/env bash
source $HOME/Recon1/config.sh
mkdir -p $HOME/$domain/.tmp
mkdir -p $HOME/$domain/.log
mkdir -p $HOME/$domain/osint
mkdir -p $HOME/$domain/gf
mkdir -p $HOME/$domain/js
mkdir -p $HOME/$domain/nuclei_output
mkdir -p $HOME/$domain/subdomains
mkdir -p $HOME/$domain/hosts
mkdir -p $HOME/$domain/webs
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$DOMAIN_INFO" = true ] && [ "$OSINT" = true ]; then
    printf "${bblue}Searching domain info (whois, registrant name/email domains)"
    lynx -dump "https://domainbigdata.com/${domain}" | tail -n +19 > $HOME/$domain/osint/domain_info_general.txt
    if [ -s "$HOME/$domain/osint/domain_info_general.txt" ]; then
        cat $HOME/$domain/osint/domain_info_general.txt | grep '/nj/' | tr -s ' ' ',' | cut -d ',' -f3 > $HOME/$domain/.tmp/domain_registrant_name.txt
        cat $HOME/$domain/osint/domain_info_general.txt | grep '/mj/' | tr -s ' ' ',' | cut -d ',' -f3 > $HOME/$domain/.tmp/domain_registrant_email.txt
        cat $HOME/$domain/osint/domain_info_general.txt | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep "https://domainbigdata.com" | tr -s ' ' ',' | cut -d ',' -f3 > $HOME/$domain/.tmp/domain_registrant_ip.txt
    fi
    sed -i -n '/Copyright/q;p' $HOME/$domain/osint/domain_info_general.txt

    if [ "$HOME/$domain/.tmp/domain_registrant_name.txt" ]; then
        for line in $(cat $HOME/$domain/.tmp/domain_registrant_name.txt); do
            lynx -dump $line | tail -n +18 | sed -n '/]domainbigdata.com/q;p' >> $HOME/$domain/osint/domain_info_name.txt && echo -e "\n\n#######################################################################\n\n" >> $HOME/$domain/osint/domain_info_name.txt
        done
    fi

    if [ "$HOME/$domain/.tmp/domain_registrant_email.txt" ]; then
        for line in $(cat $HOME/$domain/.tmp/domain_registrant_email.txt); do
            lynx -dump $line | tail -n +18 | sed -n '/]domainbigdata.com/q;p'  >> $HOME/$domain/osint/domain_info_email.txt && echo -e "\n\n#######################################################################\n\n" >> $HOME/$domain/osint/domain_info_email.txt
        done
    fi

    if [ "$HOME/$domain/.tmp/domain_registrant_ip.txt" ]; then
        for line in $(cat $HOME/$domain/.tmp/domain_registrant_ip.txt); do
            lynx -dump $line | tail -n +18 | sed -n '/]domainbigdata.com/q;p'  >> $HOME/$domain/osint/domain_info_ip.txt && echo -e "\n\n#######################################################################\n\n" >> $HOME/$domain/osint/domain_info_ip.txt
        done
    fi
    printf "\n${bgreen}Results are saved in $HOME/$domain/osint/domain_info_[general/name/email/ip].txt" ${FUNCNAME[0]}
else
    if [ "$DOMAIN_INFO" = false ] || [ "$OSINT" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi
