#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$URL_EXT" = true ]; then
    ext=("7z" "achee" "action" "adr" "apk" "arj" "ascx" "asmx" "asp" "aspx" "axd" "backup" "bak" "bat" "bin" "bkf" "bkp" "bok" "cab" "cer" "cfg" "cfm" "cfml" "cgi" "cnf" "conf" "config" "cpl" "crt" "csr" "csv" "dat" "db" "dbf" "deb" "dmg" "dmp" "doc" "docx" "drv" "email" "eml" "emlx" "env" "exe" "gadget" "gz" "html" "ica" "inf" "ini" "iso" "jar" "java" "jhtml" "json" "jsp" "key" "log" "lst" "mai" "mbox" "mbx" "md" "mdb" "msg" "msi" "nsf" "ods" "oft" "old" "ora" "ost" "pac" "passwd" "pcf" "pdf" "pem" "pgp" "php" "php3" "php4" "php5" "phtm" "phtml" "pkg" "pl" "plist" "pst" "pwd" "py" "rar" "rb" "rdp" "reg" "rpm" "rtf" "sav" "sh" "shtm" "shtml" "skr" "sql" "swf" "sys" "tar" "tar.gz" "tmp" "toast" "tpl" "txt" "url" "vcd" "vcf" "wml" "wpd" "wsdl" "wsf" "xls" "xlsm" "xlsx" "xml" "xsd" "yaml" "yml" "z" "zip")
    echo "" > $HOME/$domain/webs/url_extract.txt
    for t in "${ext[@]}"; do
        NUMOFLINES=$(cat $HOME/$domain/.tmp/url_extract_tmp.txt | grep -Ei "\.(${t})($|\/|\?)" | sort -u | wc -l)
        if [[ ${NUMOFLINES} -gt 0 ]]; then
            echo -e "\n############################\n + ${t} + \n############################\n" >> $HOME/$domain/webs/urls_by_ext.txt
            [ -s "$HOME/$domain/.tmp/url_extract_tmp.txt" ] && cat $HOME/$domain/.tmp/url_extract_tmp.txt | grep -Ei "\.(${t})($|\/|\?)" | sort -u >> $HOME/$domain/webs/urls_by_ext.txt
        fi
    done
    printf "\n${bgreen}Results are saved in $domain/webs/urls_by_ext.txt" ${FUNCNAME[0]}
else
    if [ "$URL_EXT" = false ]; then
        printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
    else
        printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
    fi
fi
