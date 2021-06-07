#!/usr/bin/env bash
source $HOME/Recon1/config.sh
if { [ ! -f "$called_fn_dir/.${FUNCNAME[0]}" ] || [ "$DIFF" = true ]; } && [ "$NUCLEICHECK" = true ]; then
	printf "${bblue}Templates based web scanner"
	nuclei -update-templates 2>>"$LOGFILE" &>/dev/null
	mkdir -p $HOME/$domain/nuclei_output
	if [ "$HOME/$domain/webs/webs.txt" ]; then
		printf "${yellow}\n Running : Nuclei Info${reset}\n\n"
		cat $HOME/$domain/webs/webs.txt | nuclei -silent -t $HOME/nuclei-templates/ -severity info -r $resolvers_trusted -o $HOME/$domain/nuclei_output/info.txt
		printf "${yellow}\n\n Running : Nuclei Low${reset}\n\n"
		cat $HOME/$domain/webs/webs.txt | nuclei -silent -t $HOME/nuclei-templates/ -severity low -r $resolvers_trusted -o $HOME/$domain/nuclei_output/low.txt
		printf "${yellow}\n\n Running : Nuclei Medium${reset}\n\n"
		cat $HOME/$domain/webs/webs.txt | nuclei -silent -t $HOME/nuclei-templates/ -severity medium -r $resolvers_trusted -o $HOME/$domain/nuclei_output/medium.txt
		printf "${yellow}\n\n Running : Nuclei High${reset}\n\n"
		cat $HOME/$domain/webs/webs.txt | nuclei -silent -t $HOME/nuclei-templates/ -severity high -r $resolvers_trusted -o $HOME/$domain/nuclei_output/high.txt
		printf "${yellow}\n\n Running : Nuclei Critical${reset}\n\n"
		cat $HOME/$domain/webs/webs.txt | nuclei -silent -t $HOME/nuclei-templates/ -severity critical -r $resolvers_trusted -o $HOME/$domain/nuclei_output/critical.txt
		printf "\n\n"
	fi
	printf "\n${bgreen}Results are saved in $domain/nuclei_output folder" ${FUNCNAME[0]}
else
	if [ "$NUCLEICHECK" = false ]; then
		printf "\n${yellow} ${FUNCNAME[0]} skipped in this mode or defined in reconftw.cfg ${reset}\n"
	else
		printf "${yellow} ${FUNCNAME[0]} is already processed, to force executing ${FUNCNAME[0]} delete\n    $called_fn_dir/.${FUNCNAME[0]} ${reset}\n\n"
	fi
fi
