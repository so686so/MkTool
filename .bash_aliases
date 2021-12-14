# CUSTOM ALIAS

# Fix Error when Window <-> Linux 
sed -i -e 's/\r$//' ~/.bash_aliases
sed -i -e 's/\r$//' ~/.bash_completion

# ============================= #
# 		   fzf Utility			#
# ============================= #

# PACKAGE NEED TO : fzf, ripgrep
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install

FZF_SETTING="	--height 50% --border --extended --ansi --reverse --cycle --multi \
		        --bind=ctrl-d:preview-page-down --bind=ctrl-u:preview-page-up \
                --bind=ctrl-space:preview-page-down --bind=ctrl-z:preview-page-up --bind=ctrl-/:toggle-preview"

function fzf_connect_vim() {
	local pre_dir=`pwd`
	local search_value="\x1b[33mNone Search Value"
	local search_time=`date +%H:%M:%S`
	local search_list=()

	echo -e "[ Run ] fzf-vim Utility By $1"

	if [ "$1" == "Source_Dir" ]
	then
		cd ~/blackbox/source
	elif [ "$1" == "All_Dir" ]
	then
		cd ~/
	fi

	if [ "$#" -eq 2 ]
	then
		search_value=$2 
		echo -e "- grep : $2"
		_file=$(rg -i --files-with-matches --no-messages "$2" | \
				fzf ${FZF_SETTING} \
				--preview "cat -n {} | rg -i --color always \"$2\"" \
				--header "[ Select the file you want to edit ]")
	else
		_file=$(fzf ${FZF_SETTING} \
				--preview "cat -n {}" \
				--header "[ Select the file you want to edit ]")
	fi

	search_list+=(${_file})
	echo -e "[ \x1b[32m${search_value}\x1b[0m ] _${search_time}" >> ${HOME}/fzf_search_log.txt
	for i in ${!search_list[@]}
	do
		echo -e "-" ${search_list[i]} >> ${HOME}/fzf_search_log.txt
	done
	echo -e "" >> ${HOME}/fzf_search_log.txt

	if [ ! "${_file}" == "" ]
	then
		if [ "$#" -eq 2 ]
		then 
			vim -O -c "/$2" ${_file}
		else
			vim -O ${_file}
		fi
	fi

	cd ${pre_dir}
}

function fzf_connect_cd() {
	pre_dir=`pwd`
	cd ~/

	echo -e "[ Run ] fzf-cd Utility"
	if [ "$#" -eq 1 ]
	then 
		echo -e "- grep : $1"
		_file=$(  rg -i --files-with-matches --no-messages "$1" |\
		fzf ${FZF_SETTING}\
				--preview "cat -n {} | rg -i --color always \"$1\""\
				--header "[ Select Dir/File you want to move Dir ]")
	else
		_file=$(fzf ${FZF_SETTING}\
				--preview "cat -n {}"\
				--header "[ Select Dir/File you want to move Dir ]")
	fi

	if [ ! "${_file}" == "" ]
	then
		cd $(dirname ${_file})
	else
		cd ${pre_dir}
	fi
}

function shorten_path() {
	local PATH=$(echo -e `pwd` | sed "s#${HOME}##g")
	test x"${PATH}" == x && PATH="\e[1;36mHOME_${TIBET_PROJECT}"
	echo $PATH
}

function show_fzf_search_log {
	local search_count="3"

	if [ $# -eq 1 ]
	then
		search_count=$1
	fi

	local CUT_LINE=$(cat ~/fzf_search_log.txt | grep -n "\[ " | tail -n ${search_count} | head -n 1 | awk -F ':' '{print $1}')
	local END_LINE=$(wc -l ~/fzf_search_log.txt | awk -F ' ' '{print $1}')
	local START_LINE=$(( ${END_LINE} - ${CUT_LINE} + 1 ))

	echo
	cat ~/fzf_search_log.txt | tail -n ${START_LINE}
}

alias ff='fzf_connect_vim Curr_Dir'
alias ffs='fzf_connect_vim Source_Dir'
alias ffa='fzf_connect_vim All_Dir'
alias fcd='fzf_connect_cd'
alias fl='show_fzf_search_log'

alias sc='f() {
			source ~/.bashrc;
			echo -e "[ Source ~/.bashrc Complete ]";
			}; f'

alias x='exit'
alias t='gnome-terminal'

alias cds='cd ~/blackbox/source'
alias cdss='cd ~/blackbox/system'
alias cdu='cd ~/blackbox/util'
alias Vim='vim -O'

# ============================= #
# 			mk Tool.			#
# ============================= #

# Option
AUTO_DIR_COPY=Y
AUTO_NFS_DETECT=Y
AUTO_BACKUP=N
CHANGE_PROMPT=Y
IMPROVED_AUTO_COMPLETE=Y

MK_VERSION=1.2.7
LAST_UPDATE=2021-12-14

PROJECT_LIST=( "A3" "S3" "V3" "V4" "V8") 

ERROR='[ \x1b[31mERROR\x1b[0m ]'
NOTICE='[ \x1b[33mNOTICE\x1b[0m ]'

TEMP_BACKUP_CONFILICT_FILES="${HOME}/blackbox/tempBackupConflict"

NFS_IP='192.168.0.200'
LAST_BACKUP_DATE=0630
LAST_BACKUP_HOUR=11

FTP_ID=so686so
FTP_PW=1663
ROOT_PW=

cRed='\x1b[31m'
cGreen='\x1b[32m'
cYellow='\x1b[33m'
cSky='\x1b[36m'
cReset='\x1b[0m'

# Set option when 'source ~/.bashrc'
if [ "${CHANGE_PROMPT}" == "Y" ]
then
	PS1="\[\e[1;37m\][ \[\e[1;32m\]\$(echo -e \$(shorten_path))\[\e[0m\] \[\e[1;37m\]]\[\e[0m\] \[\e[37m\]> \[\e[0m\]"
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

if [ "${IMPROVED_AUTO_COMPLETE}" == "Y" ]
then
	bind 'TAB:menu-complete'
	bind '"\e\e":unix-word-rubout'
	bind "set show-all-if-ambiguous on"
	bind "set completion-ignore-case on"
	bind "set menu-complete-display-prefix on"
	bind "set colored-completion-prefix on"
	bind "set colored-stats on"
else
	# Default
	bind 'TAB:complete'
	bind '"\e\e":complete'
	bind "set show-all-if-ambiguous off"
	bind "set completion-ignore-case off"
	bind "set menu-complete-display-prefix off"
	bind "set colored-completion-prefix off"
	bind "set colored-stats off"
fi

# Line number of projects currently active in bashrc
function get_line_project_name() {
	if [ $# -eq 1 ]
	then
		cat ~/.bashrc | grep -n TIBET_PROJECT | grep $1$ | awk -F ':' '{print $1}'
	else
		cat ~/.bashrc | grep -n ^TIBET_PROJECT | grep -v "#" | awk -F ':' '{print $1}'
	fi
}

# ex) TIBET_PROJECT=S3
function get_value_project_name() {
	if [ $# -eq 1 ]
	then
		cat ~/.bashrc | grep -n TIBET_PROJECT | grep $1$ | awk -F '#' '{print $2}'
	else
		cat ~/.bashrc | grep -n ^TIBET_PROJECT | grep -v "#" | awk -F ':' '{print $2}'
	fi
}

# ex) s3
function project_version_name() {
	cat ~/.bashrc | grep -n ^TIBET_PROJECT | grep -v "#" | awk -F '=' '{print $2}' | tr [A-Z] [a-z]
}

function get_line_option() {
	cat ~/.bash_aliases | grep -na ^$1 | awk -F ':' '{print $1}'
}

function get_value_option() {
	cat ~/.bash_aliases | grep -na ^$1 | awk -F '=' '{print $2}'
}

function get_backup_value_option() {
	cat ~/.bash_aliases_backUp | grep -na ^$1 | awk -F '=' '{print $2}'
}

function version_change_to_upload() {
	local VERSION_LINE=$(get_line_option MK_VERSION)
	local UPDATE_TIME_LINE=$(get_line_option LAST_UPDATE)

	local LAST_VERSION=`echo ${MK_VERSION//./}`
	LAST_VERSION=$(( ${LAST_VERSION} + 1 )) 

	local CURRENT_VERSION=`echo ${LAST_VERSION:0:1}.${LAST_VERSION:1:1}.${LAST_VERSION:2:1}`
	local CURRENT_DATE=`date +%Y-%m-%d`

	sed -i "${VERSION_LINE}s/.*/MK_VERSION=${CURRENT_VERSION}/g" ~/.bash_aliases
	sed -i "${UPDATE_TIME_LINE}s/.*/LAST_UPDATE=${CURRENT_DATE}/g" ~/.bash_aliases

	# Clear my private info
	local PW_LINE=$(get_line_option ROOT_PW)
	sed -i "${PW_LINE}s/.*/ROOT_PW=/g" ~/.bash_aliases

	cd ~
	source ~/.bashrc
}

function version_info() {
	echo -e "[ Version ] \t: ${MK_VERSION}"
	echo -e "[ Last Update ] : ${LAST_UPDATE}"
}

function change_project_by_bashrc() {
	local TARGET_PROJECT_NAME=$1

	local PROJECT_NAME=$(project_version_name)
	local PROJECT_LINE=$(get_line_project_name)
	local PROJECT_VALUE=$(get_value_project_name)

	sed -i "${PROJECT_LINE}s/.*/#${PROJECT_VALUE}/g" ~/.bashrc

	PROJECT_LINE=$(get_line_project_name ${TARGET_PROJECT_NAME})
	PROJECT_VALUE=$(get_value_project_name ${TARGET_PROJECT_NAME})

	sed -i "${PROJECT_LINE}s/.*/${PROJECT_VALUE}/g" ~/.bashrc
}

function change_project() {
	local check_value="false"
	local PRE_PROJECT=$(project_version_name | tr [a-z] [A-Z])
	echo -e "\n[ Current Project : ${cYellow}${PRE_PROJECT}${cReset} ]"

	local LIST=(${PROJECT_LIST[@]})

	local is_valid_arg="false"
	local temp_select=""
	local SELECT_PROJECT=""

	# Check Var is valid
	if [ $# -ge 1 ]
	then
		temp_select=`echo -e $1 | tr [a-z] [A-Z]`
		for each in ${LIST[@]}
		do
			if [ "${temp_select}" == "${each}" ]
			then
				is_valid_arg="true"
				break
			fi
		done

		if [ "${is_valid_arg}" == "false" ]
		then
			echo -e "${NOTICE} Not Valid Argument.\n"
		fi
	fi

	# Choose Project to Change
	if [ "${is_valid_arg}" == "true" ]
	then
		# Set Change Project when recv Correct Arg
		SELECT_PROJECT="${temp_select}"
	else
		# Set Change Project when not recv Arg
		LIST+=( "Exit" )
		echo -e "${cYellow}[ Choice Project to Change ]${cReset}"
		select var in "${LIST[@]}"
		do
			SELECT_PROJECT="${var}"
			break
		done

		# Exit
		for value in ${LIST[@]}; do [ "${value}" == "${SELECT_PROJECT}" ] && check_value="true"; done
		if [ "${check_value}" == "false" ] 
		then 
			echo -e ${ERROR} "Invalid Project Name"
			return
		fi
		test "${SELECT_PROJECT}" == "Exit" && return
	fi

	# Change Setting
	echo -e " - Change setting : bashrc..."
	change_project_by_bashrc ${SELECT_PROJECT}
	echo -e " - ${cYellow}${PRE_PROJECT}${cReset} -> ${cGreen}${SELECT_PROJECT}${cReset}"

	SELECT_PROJECT=$(echo -e ${SELECT_PROJECT} | tr [A-Z] [a-z])

	echo -e " - Change setting : project_change.sh : ${SELECT_PROJECT}"
	cd ~/blackbox
	./project_change.sh ${SELECT_PROJECT}
	echo -e " - Change Done."

	cd ~
	source ~/.bashrc

	echo -e " - source ~/.bashrc Done.\n"
}

function show_mkapp_list() {
	local PROJECT_NAME=$(project_version_name | tr [a-z] [A-Z])
	echo -e "\n${cYellow}[ Current Project : ${PROJECT_NAME} ]${cReset}"

	local START_LINE=$(cat ~/blackbox/system/mk_app.sh | grep -n 'case $1 in' | awk -F ':' '{print $1}')
	local END_LINE=$(wc -l ~/blackbox/system/mk_app.sh | awk -F ' ' '{print $1}')
	local LIST_LINE=$(cat ~/blackbox/system/mk_app.sh | grep -n 'esac' | awk -F ':' '{print $1}')

	local SUBS=$(( ${END_LINE} - ${START_LINE} + 1 ))
	local TAIL_CUT=$(( ${LIST_LINE} - ${START_LINE} ))	#HC

	if [ ! "$1" == "" ]
	then
		cat ~/blackbox/system/mk_app.sh | tail -n ${SUBS} | head -n ${TAIL_CUT} | grep -i $1
	else
		cat ~/blackbox/system/mk_app.sh | tail -n ${SUBS} | head -n ${TAIL_CUT}
	fi
}

function extract_mkapp_list() {
	local TEMP=`show_mkapp_list | grep \) | awk -F ')' '{print $1}' | head -n -1`
	TEMP=`echo ${TEMP// /} | awk -F ' ' '{print $0}'`
	echo -e $TEMP 
}

function setting_option() {
	local choice_num="-1"
	local OPT_LIST=( "AUTO_DIR_COPY" "AUTO_NFS_DETECT" "AUTO_BACKUP" "CHANGE_PROMPT" "IMPROVED_AUTO_COMPLETE" "Exit" )
	local opt_line=""
	local opt_value=""

    local DETAIL_INFO_LIST=( \
        "- Create FW directory in home directory.\n- Automatically copies the .arm file generated by 'mk' to the ${cYellow}~/FW${cReset} directory." \
        "- Check if nfs is mounted.\n- If connected, the .arm file is automatically copied to the ${cYellow}~/install${cReset} directory." \
        "- Automatically save the code you are currently working on in git stash.\n- This function only works once every hour."
        "- Replace the prompt output of the terminal.\n- Prints the current project and directory."
        "- Change the autocomplete algorithm.\n- Delete word when esc key twice | Auto-completion cycle | Highlight"
    )

	while [ "${choice_num}" -lt 5 ]
	do
		clear
		echo -e "\n== [ Option ] ================================================================="
		for n in {0..5}
		do
			opt_line=$(get_line_option ${OPT_LIST[$n]})
			opt_value=$(get_value_option ${OPT_LIST[$n]})
			test "${opt_value}" == "Y" && printf "${cGreen}"
			echo -e "$n ) ${OPT_LIST[$n]}" 
			printf "${cReset}"
		done
		echo -e "-------------------------------------------------------------------------------"
        if [ "${choice_num}" == "-1" ]
        then
            echo -e "* No number has been entered yet.\n-\n-"
        else
            echo -e "* ${OPT_LIST[$choice_num]}"
            echo -e "${DETAIL_INFO_LIST[$choice_num]}"
        fi
		echo -e "== [ Option ] ================================================================="
		printf "Enter the number of options you want to enable/disable : "

		read choice_num

		if [ "${choice_num}" -gt 5 ]
		then
			continue
		elif [ "${choice_num}" -eq 5 ]
		then
			cd ~
			source ~/.bashrc
			break
		fi

		opt_line=$(get_line_option ${OPT_LIST[$choice_num]})
		opt_value=$(get_value_option ${OPT_LIST[$choice_num]})

		if [ "${opt_value}" == "Y" ]
		then
			sed -i "${opt_line}s/.*/${OPT_LIST[$choice_num]}=N/g" ~/.bash_aliases
		else
			sed -i "${opt_line}s/.*/${OPT_LIST[$choice_num]}=Y/g" ~/.bash_aliases
		fi

		cd ~
		source ~/.bashrc
	done
	echo -e "\n[ mk Option Setting Done. ]\n"
}

function check_installed_package() {
	$1 --version &>/dev/null
}

function send_file_to_nfs() {

	local CUR_DATE=`date +%Y%m%d`
	local INS_DIR=""
	local PROJECT_NAME=$(project_version_name)
	local SELECT_FILE=""
	local COPY_DIR=""

	# Set To. Dir
	if [ "${PROJECT_NAME}" == "a3" ]
	then
		INS_DIR="${HOME}/tftpboot/janus_a3/fw_install"
	else
		INS_DIR="${HOME}/tftpboot/gnet_${PROJECT_NAME}/fw_install"
	fi

	cd ${INS_DIR}

	# Set Target File
	if [ $(ls -l | grep ${CUR_DATE}\.arm$ | wc -l) -ge 2 ]
	then
		check_installed_package fzf
		if [ "$?" == 0 ]
		then
			SELECT_FILE=`ls -t | grep ${CUR_DATE}\.arm$ | head -n 5 | \
						fzf --cycle --height 10% --reverse --border \
							--header "[ Choice file to move ./janus ]"`
		else
			local FILE_LIST=(	$(ls -t | grep \.arm$ | awk "NR==1") \
								$(ls -t | grep \.arm$ | awk "NR==2") \
								$(ls -t | grep \.arm$ | awk "NR==3") \
								"Not Copy File" )

			echo -e "[ More than one file in fw_install dir. ]"
			echo -e "${cYellow}[ Choice file to move ./janus ]${cReset}"
			select var in "${FILE_LIST[@]}"
			do
				SELECT_FILE="${var}"
				break
			done

		fi
	else
		SELECT_FILE="$(ls -t | grep ${CUR_DATE}\.arm$ | head -n 1)"
	fi

	if [ "${SELECT_FILE}" == "Not Copy File" -o "${SELECT_FILE}" == "" ]
	then
		echo -e "\n - Cancel File Copy to ./janus"
		return
	fi

	# Set From. Dir
	if [ "${PROJECT_NAME}" == "a3" ]
	then
		COPY_DIR="janus_a3"
	else
		COPY_DIR="gnet_${PROJECT_NAME}"
	fi

	cd ${HOME}/install/${COPY_DIR}
	if [ $(ls -l | grep \.arm$ | wc -l) -gt 0 ]
	then
		rm *.arm
	fi

	cp -a ${INS_DIR}/${SELECT_FILE} ~/install/${COPY_DIR}

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Copy file to NFS FAILED.\n"
		return
	fi

	echo -e "\n[ Done ] File Copy ./janus for NFS : ${cGreen}${SELECT_FILE}${cReset}"
}

function change_backup_date() {
	local DATE_LINE=$(get_line_option LAST_BACKUP_DATE)
	local HOUR_LINE=$(get_line_option LAST_BACKUP_HOUR)

	local CUR_DATE=`date +%m%d`
	local CUR_HOUR=`date +%H`

	sed -i "${DATE_LINE}s/.*/LAST_BACKUP_DATE=${CUR_DATE}/g" ~/.bash_aliases
	sed -i "${HOUR_LINE}s/.*/LAST_BACKUP_HOUR=${CUR_HOUR}/g" ~/.bash_aliases

	cd ~
	source ~/.bashrc
}

function git_backup() {
	cd ~/blackbox/source

	if [ "$(git stash list | grep "mkBackUp" | wc -l)" -eq 1 ]
	then
		echo -e "\n[ Stash BackUp file Already Exist. It will be replaced by the latest backup file. ]\n"
		STASH_NUM=`git stash list | grep "mkBackUp" | awk -F ':' '{print $1}'`
		git stash drop ${STASH_NUM}
	fi

	git stash save "mkBackUp"
	STASH_NUM=`git stash list | grep "mkBackUp" | awk -F ':' '{print $1}'`

	git stash apply ${STASH_NUM}

	echo -e "\n[ BackUp Complete. If you want load backup file, press ${cGreen}'mk load'${cReset} ]\n"

	change_backup_date
}

function git_backup_load() {
	cd ~/blackbox/source

	echo -e "\n[ Stash BackUp file load... ]\n"

	if [ "$(git stash list | grep "mkBackUp" | wc -l)" -eq 0 ]
	then
		echo -e "\n[ Stash BackUp file Not Exist. Load process exit. ]\n"
		return
	fi

	if [ "$(git stash list | grep "TEMP" | wc -l)" -ge 1 ]
	then
		STASH_NUM=`git stash list | grep "TEMP" | awk -F ':' '{print $1}'`
		git stash drop ${STASH_NUM}
	fi

	git stash save "TEMP"

	STASH_NUM=`git stash list | grep "mkBackUp" | awk -F ':' '{print $1}'`

	git stash apply ${STASH_NUM}

	echo -e "\n[ BackUp file load complete ]\n"
}

function make_update_file() {

	local _option=" "
	local _project_name=$(project_version_name)

	echo -e "\n[ Run : make_update_file ]"

    local valid_model_list=($(extract_mkapp_list))
    local valid_model_value="false"
    valid_model_list+=(".")

    for arg in ${valid_model_list[@]}
    do
        if [ "${arg}" == "$1" ]
        then
            valid_model_value="true"
            break
        fi
    done

    if [ "${valid_model_value}" == "false" ]
    then
        echo -e "${NOTICE} Model name Invalid. mkTool run canceled.\n"
        return
    fi

	if [ ! "$2" == "mkAppOnly" ]
	then
		# Setting option
		if [ "$2" == "all" -o "$2" == "cleanInstall" ]
		then
			_option=" clean "
		fi

		if [ "${AUTO_DIR_COPY}" == "Y" ]
		then
			if [ -d "${HOME}/FW" ]
			then
				echo -e "[ Running... ] reset FW dir."
				cd ~/FW
				if [ $(ls -l | grep \.arm$ | wc -l) -gt 0 ]
				then
					rm *
				fi
			else
				echo -e "${NOTICE} FW dir not exist. make dir."
				cd ~
				mkdir FW
			fi
		fi

		if [ "${AUTO_BACKUP}" == "Y" ]
		then
			local CUR_BACKUP_DATE=`date +%m%d`
			local CUR_BACKUP_HOUR=`date +%k`

			echo -e "[ Running... ] Auto backup option."
			if [ ! "${LAST_BACKUP_DATE}" == "${CUR_BACKUP_DATE}" ] || [ ! "${LAST_BACKUP_HOUR}" == "${CUR_BACKUP_HOUR}" ]
			then
				git_backup

				if [ $? -gt 0 ]
				then
					echo -e "${ERROR} Auto backup FAILED.\n"
					break
				fi

				echo -e "[ Done ] Auto backup done."

			else
				echo -e ${cGreen}"* Already backed up within an hour"${cReset}
			fi

		fi

		cd ~/blackbox/source

		echo -e "[ Running... ] make${_option}install.\n"
		make${_option}install
		
		if [ $? -gt 0 ]
		then
			echo -e "\n${ERROR} make${_option}install FAILED.\n"
			return
		fi

		echo -e "\n\n\n[ Done ] make${_option}install."
	fi

	cd ~/blackbox/system
	echo -e "[ Running... ] mk_app.sh${cGreen}" $1 "${cReset}\n\n"
	./mk_app.sh "$1"
	
	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} mk_app.sh $1 FAILED.\n"
		return
	fi

	echo -e "\n\n[ Done ] F/W update File (${cGreen} $1 ${cReset}) make Done."
	echo -e "[ PROJECT NAME ] :" ${_project_name} | tr [a-z] [A-Z]

	local CUR_DATE=`date +%Y%m%d`
	local INS_DIR=""

	echo -e "[ MAKE TIME ] : "`date`

	# Auto copy file to ~/FW ( when option : Y )
	if [ "${AUTO_DIR_COPY}" == "Y" ]
	then
		if [ "${_project_name}" == "a3" ]
		then
			INS_DIR="${HOME}/tftpboot/janus_a3/fw_install"
		else
			INS_DIR="${HOME}/tftpboot/gnet_${_project_name}/fw_install"
		fi

		cd ${INS_DIR}

		if [ $(ls -l | grep ${CUR_DATE}\.arm$ | wc -l) -ge 2 ]
		then
			local file_count=$(ls -l | grep ${CUR_DATE}\.arm$ | wc -l)
			for n in `seq 1 ${file_count}`
			do
				cp -a ${INS_DIR}/$(ls -t | grep ${CUR_DATE}\.arm$ | awk "NR==${n}") ~/FW
				if [ ${n} -gt 3 ]; then break; fi
			done
		else
			cp -a ${INS_DIR}/$(ls -t | grep ${CUR_DATE}\.arm$ | head -1) ~/FW
		fi

		if [ $? -gt 0 ]
		then
			echo -e "\n${ERROR} Copy file FAILED.\n"
			return
		fi		

		echo -e "[ Done ] File Copy to '~/FW' Direcotry.\n"
	fi

	# Auto copy file to ~install ( ./janus ) 
	if [ "${AUTO_NFS_DETECT}" == "Y" ]
	then
		ping ${NFS_IP} -c 1 -i 0.3 &>/dev/null
		if [ $? -eq 0 ]
		then
			echo -e "${cSky}[ NFS Connected : Copy to update file to ./janus ]${cReset}\n"
			send_file_to_nfs
		fi
	fi

	echo ""
}

function make_update_file_help() {
	resize -s 50 ${COLUMNS} >/dev/null

	echo -e "\n== [ HELP ] =================================================================\n"
	echo -e " * ${cSky}mk list${cReset} 	: Show mk_app.sh list at Current Project"
	echo -e " * ${cSky}mk setting${cReset} 	: Change & Adjust project"
	echo -e " * ${cSky}mk option${cReset} 	: Setting mk Tool option"
	echo -e " * ${cSky}mk update${cReset} 	: Update mkTool with latest file from NAS"
	echo -e "\n ---------------------------------------------------------------------------\n"
	echo -e " * ${cSky}mk [<Option>] [<model>] [<Sub Option>]${cReset}\n"
	echo -e " # Make install & Create f/w update file(.arm) at ${cYellow}Once${cReset}"
	echo -e " # If connected to NFS, automatically copy to that path as well"
	echo -e "\n ${cSky}[Option]${cReset}"
	echo -e " - i	: 'make install' current Project"
	echo -e " - c 	: 'make clean' current Project"
	echo -e " - a 	: 'mk_app' without make install"
	echo -e " - ci 	: 'make clean install' current Project"
	echo -e " - r 	: './release.sh'"
	echo -e "\n ${cSky}[Sub Option]${cReset}"
	echo -e " - . 	: run at current directory ( with c, i, ci )"
	echo -e "     	  if use 'mk ${cGreen}.${cReset}' work that 'make install' & 'mk_app.sh' ${cGreen}default ${cReset}model"
	echo -e " - all 	: 'make clean install' instead of 'make install'"
	echo -e ""
	echo -e " ex) mk i	: 'make install' the Project in any directory"
	echo -e "     mk ci .	: 'make clean install' at current directory"
	echo -e "     mk ${cGreen}.${cReset}	: 'make install' & 'mk_app.sh' ${cGreen}default${cReset} model"
	echo -e "     mk ${cGreen}aoki${cReset}	: 'make install' & 'mk_app.sh ${cGreen}aoki${cReset}'"
	echo -e "     mk ${cGreen}gdr${cReset} all	: 'make clean install' & 'mk_app.sh ${cGreen}gdr${cReset}'"
	echo -e "\n ---------------------------------------------------------------------------\n"
	echo -e " * mk clear\t: Clear the '~/tftpboot/../fw_install' in Current Project"
	echo -e " * mk store\t: Backup the '../fw_install' in Current Project"
	echo -e " * mk open\t: Open the '../fw_install' in Current Project or Other Dir."
	echo -e " * mk upp\t: sudo apt update & upgrade at once"
	echo -e " * mk version\t: View version information"
	echo -e " * mk patch_log\t: View the patch log"
	echo -e " * mk sd_copy\t: Copy the most recent arm file to the mounted SD card"
	echo -e " * mk pull\t: Git pull Current Project"
	echo -e " * mk kill\t: Close all terminals except the process is running"

    echo -e "\n== [ HELP ] =================================================================\n"
}

function mk_open_dir() {
	local INS_DIR=""
	local PROJECT_NAME=$(project_version_name)

	if [ $# -eq 1 ]
	then
		if [ "$1" == "FW" ]
		then
			nautilus ${HOME}/FW
		else
			nautilus $1
			return
		fi
	fi

	if [ "${PROJECT_NAME}" == "a3" ]
	then
		INS_DIR="${HOME}/tftpboot/janus_a3/fw_install"
	else
		INS_DIR="${HOME}/tftpboot/gnet_${PROJECT_NAME}/fw_install"
	fi

	nautilus ${INS_DIR}
}

function run_dir_clear() {
	local INS_DIR=""
	local PROJECT_NAME=$(project_version_name)

	if [ "${PROJECT_NAME}" == "a3" ]
	then
		INS_DIR="${HOME}/tftpboot/janus_a3/$1"
	else
		INS_DIR="${HOME}/tftpboot/gnet_${PROJECT_NAME}/$1"
	fi

	if [ -d "${INS_DIR}" ]
	then
		cd ${INS_DIR}
	else
		echo -e "${NOTICE} ${INS_DIR} not exist."
		return
	fi

	if [ $(ls -l | grep \.arm$ | wc -l) -gt 0 ]
	then
		rm *.arm
	fi
	echo -e "- ${cGreen}${INS_DIR}${cReset} Clear"
}

function manage_dir_clear() {
	local route_list=( "app" "fw_install" "os" "pack" "all" )
	local is_all_value="false"
	local args=$@

	if [ "${args}" == "" ]
  	then
    	run_dir_clear fw_install
    	return
  	fi

	for arg in ${args[@]}
  	do
    	if [ "${arg}" == "all" ]
		then
			run_dir_clear app
			run_dir_clear fw_install
			run_dir_clear os
			run_dir_clear pack
			return
		fi

		for route in ${route_list[@]}
		do
			if [ "${arg}" == "${route}" ]
			then
				run_dir_clear ${arg}
			fi
		done 
  	done
}

function run_git_pull() {
	local PROJECT_NAME=$1
	local Pull_Dir="${HOME}/blackbox/${PROJECT_NAME}"

	printf "[ Run ] Git Pull - ${cGreen}"
	echo -e ${PROJECT_NAME} | tr [a-z] [A-Z]
	printf ${cReset}

	cd ${Pull_Dir}
	git pull
	echo
}

function manage_git_pull() {
	local route_list=( "v4" "a3" "s3" "v3" "v8" "util" "all" )
	local is_all_value="false"
	local args=`echo $@ | tr [A-Z] [a-z]`
	local PROJECT_NAME=$(project_version_name)

	echo ""
	if [ "${args}" == "" ]
  	then
    	run_git_pull ${PROJECT_NAME}
		echo -e "[ Done ] Git Pull\n"
    	return
  	fi

	for arg in ${args[@]}
  	do
    	if [ "${arg}" == "all" ]
		then
			run_git_pull v4
			run_git_pull s3
			run_git_pull a3
			run_git_pull v3
			run_git_pull v8
			run_git_pull util
			echo -e "[ Done ] Git Pull\n"
			return
		fi

		for route in ${route_list[@]}
		do
			if [ "${arg}" == "${route}" ]
			then
				run_git_pull ${arg}
			fi
		done 
  	done
	echo -e "[ Done ] Git Pull\n"
}

function fw_install_dir_backup() {
	local CUR_DATE=`date +%Y%m%d`
	local INS_DIR=""
	local PROJECT_NAME=$(project_version_name)
	local SELECT_FILE=""
	local COPY_DIR=""
	local BACKUP_DIR="${INS_DIR}/${CUR_DATE}"

	# Set To. Dir
	if [ "${PROJECT_NAME}" == "a3" ]
	then
		INS_DIR="${HOME}/tftpboot/janus_a3/fw_install"
	else
		INS_DIR="${HOME}/tftpboot/gnet_${PROJECT_NAME}/fw_install"
	fi

	BACKUP_DIR="${INS_DIR}/${CUR_DATE}"

	echo -e "[ Running... ] Backup arm file in fw_install dir"

	if [ -d ${BACKUP_DIR} ]
	then
		cd ${INS_DIR}
		mv -vf *.arm ${BACKUP_DIR}
	else
		mkdir ${BACKUP_DIR}
		cd ${INS_DIR}
		mv -vf *.arm ${BACKUP_DIR}
	fi

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Move file FAILED.\n"
		return
	fi		

	echo -e "\n[ Done ] File Move to ${cGreen}${BACKUP_DIR}${cReset} Directory.\n"
}

function update_mk_file() {
	local pre_dir=`pwd`

	echo -e "\n[ Run : mk Tool Update ]"

	cd ~
	cp ~/.bash_aliases ~/.bash_aliases_backUp
	cp ~/.bash_completion ~/.bash_completion_backUp

	local BACKUP_FLAG=( "AUTO_DIR_COPY" "AUTO_NFS_DETECT" "AUTO_BACKUP" "CHANGE_PROMPT" "IMPROVED_AUTO_COMPLETE"\
						"LAST_BACKUP_DATE" "LAST_BACKUP_HOUR" "ROOT_PW" )
	local BACKUP_OPTION_LINE=()
	local BACKUP_OPTION_VALUE=()
	local temp_line=""
	local temp_value=""
	local opt_len=${#BACKUP_FLAG[@]}

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Copy Backup file Failed.\n"
		return
	fi

	for (( i=0; i<${opt_len}; i++ ));
	do
		temp_value=$(get_backup_value_option ${BACKUP_FLAG[$i]})
		BACKUP_OPTION_VALUE+=(${temp_value})
	done

	if [ -d "${HOME}/blackbox/MkTool" ]
	then
		rm -rf ${HOME}/blackbox/MkTool
	fi

	cd ${HOME}/blackbox
	git clone https://github.com/so686so/MkTool.git
	cd MkTool

	\mv -f .bash_aliases ${HOME}/
	\mv -f .bash_completion ${HOME}/

	if [ $? -gt 0 ]
	then
		echo -e "[ ${ERROR} Update Failed. Roll Back .bash_aliases file ]"
		mv ~/.bash_aliases_backUp ~/.bash_aliases
		return
	fi

	for (( i=0; i<${opt_len}; i++ ));
	do
		temp_line=$(get_line_option ${BACKUP_FLAG[$i]})
		BACKUP_OPTION_LINE+=(${temp_line})
	done

	for (( i=0; i<${opt_len}; i++ ));
	do
		sed -i "${BACKUP_OPTION_LINE[$i]}s/.*/${BACKUP_FLAG[$i]}=${BACKUP_OPTION_VALUE[$i]}/g" ~/.bash_aliases
	done

	cd ~
	echo -e "[ Running... ] Remove temp MkTool Dir"
	rm -rf ${HOME}/blackbox/MkTool

	echo -e "[ Running... ] Meld Backup .bash_aliases & .bash_completion"
	meld .bash_aliases .bash_aliases_backUp
	meld .bash_completion .bash_completion_backUp

	echo -e "[ Running... ] Autocomplete script being applied to root directory"
	source ~/.bashrc

	echo -e "[ Done ] Autocomplete script being applied done."
	echo -e "[ Done ] mk Tool Update Complete\n"

	cd ${pre_dir}
}

function check_root_pw() {
	if [ "${ROOT_PW}" == "" ]
	then
		printf "* Please input your root passwd : "
		read
		local PW_LINE_=$(get_line_option ROOT_PW)
		sed -i "${PW_LINE_}s/.*/ROOT_PW=${REPLY}/g" ~/.bash_aliases
		cd ~
		source ~/.bashrc
	fi
}

function upload_mkTool() {
	version_change_to_upload

	cd ${HOME}/Personal/MkTool

	printf "[ ${MK_VERSION} ] : "
	read patch_log_comment

	cp -af ~/.bash_aliases ${HOME}/Personal/MkTool
	cp -af ~/.bash_completion ${HOME}/Personal/MkTool

	git commit -am "${patch_log_comment}"

	git push

	echo -e "[ Done ] Upload Done : <${MK_VERSION}> ${patch_log_comment}"
}

function update_package_version() {
	echo -e "\n[ Run ] Package Update "

	check_root_pw

	echo -e ${cSky}"\n [ apt-get update ] \n"${cReset}
	echo "${ROOT_PW}" | sudo -kS apt-get update -y
	echo -e ${cSky}"\n [ apt-get upgrade ] \n"${cReset}
	echo "${ROOT_PW}" | sudo -kS apt-get upgrade -y

	check_installed_package snap
	if [ "$?" == 0 ]
	then
		echo -e ${cSky}"\n [ snap refresh ] \n"${cReset}
		echo "${ROOT_PW}" | sudo -kS snap refresh
	fi

	echo -e "\n[ Done ] Package Update Done\n"
}

function setting_nfs() {
	echo -e "\n[ Run ] NFS Setting \n"
	check_installed_package fzf
	if [ $? -gt 0 ]
	then
		echo -e "${NOTICE} : Sorry. that function need ${cGreen}fzf${cReset} Package"
		echo -e "- git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
		echo -e "- ~/.fzf/install"
		return
	fi

	local PROJECT_NAME=$(project_version_name)
	local NFS_DIR=""
	local SELECT_VALUE=""

	# Set Dir
	if [ "${PROJECT_NAME}" == "a3" ]
	then
		NFS_DIR="${HOME}/install/janus_a3"
	else
		NFS_DIR="${HOME}/install/gnet_${PROJECT_NAME}"
	fi

	cd ${NFS_DIR}/pack
	SELECT_FILE=`find . -maxdepth 1 -type d | \
				fzf --cycle --height 30% --reverse --border \
				--header "[ Select Model to apply oem.ini ]"`

	if [ "${SELECT_FILE}" == "" ]
	then
		echo -e "- setting nfs cancel"
		return
	fi

	cd ${SELECT_FILE}
	cp -a * ../..
	echo -e "[ Copy : oem.ini ]"

	cd ${NFS_DIR}/skin
	SELECT_FILE=`find . -maxdepth 1 -type d | \
				fzf --cycle --height 30% --reverse --border \
				--header "[ Select Model to apply skin ]"`

	if [ "${SELECT_FILE}" == "" ]
	then
		echo -e "- setting nfs cancel"
		return
	fi

	cd ${SELECT_FILE}
	cp -a * ./..
	echo -e "[ Copy : Model skin ]"	

	if [ "${PROJECT_NAME}" == "v3" ]
	then
		cd ${NFS_DIR}/language/gnet/
		cp -a * ./..
		echo -e "[ Copy : gnet Langugae ]"
	fi

	echo -e "\n[ Done ] NFS Setting Done\n"
}

function sd_copy_file() {
	check_installed_package fzf
	if [ $? -gt 0 ]
	then
		echo -e "${NOTICE} : Sorry. that function need ${cGreen}fzf${cReset} Package"
		echo -e "- git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
		echo -e "- ~/.fzf/install"
		return
	fi

	echo -e "\n[ Run ] Copy file to SD card\n"

	local SD_PATH=""
	local SD_NUM=`df -h | grep "sd" | grep -v "/$" | wc -l`

	if [ "${SD_NUM}" -gt 1 ]
	then
		SD_PATH=`df -h | grep "sd" | grep -v "/$" | fzf --cycle --height 10% --reverse --border --header "[ Select Disk for Copy file ]"`
	elif [ "${SD_NUM}" -eq 0 ]
	then
		echo -e "${ERROR} Not Connected SD card - Please check SD card mounted\n"
		return
	else
		SD_PATH=`df -h | grep "sd" | grep -v "/$"`
	fi

	SD_PATH=`echo ${SD_PATH} | awk -F ' ' '{printf $6}'`
	echo -e "[ Running... ] SD card Path - ${SD_PATH}"

	local INS_DIR=""
	local CUR_DATE=`date +%Y%m%d`
	local PROJECT_NAME=$(project_version_name)
	local SELECT_FILE=""

	if [ "${PROJECT_NAME}" == "a3" ]
	then
		INS_DIR="${HOME}/tftpboot/janus_a3/fw_install"
	else
		INS_DIR="${HOME}/tftpboot/gnet_${PROJECT_NAME}/fw_install"
	fi

	cd ${INS_DIR}

	# Set Target File
	if [ $(ls -l | grep ${CUR_DATE}\.arm$ | wc -l) -ge 2 ]
	then
		SELECT_FILE=`ls -t | grep ${CUR_DATE}\.arm$ | head -n 5 | \
					fzf --cycle --height 10% --reverse --border \
						--header "[ Choice file to move SD disk ]"`
	else
		SELECT_FILE="$(ls -t | grep ${CUR_DATE}\.arm$ | head -n 1)"
	fi

	if [ "${SELECT_FILE}" == "" ]
	then
		echo -e "\n - Cancel File Copy to SD disk"
		return
	fi

	if [ ! -d "${SD_PATH}/update" ]
	then
		mkdir "${SD_PATH}/update"
	fi

	echo -e "- Copying..."
	cp -av ${SELECT_FILE} "${SD_PATH}/update"

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Copy file to SD card FAILED.\n"
		return
	fi

	echo -e "\n- Unmount SD card : ${SD_PATH}"
	umount ${SD_PATH}
	echo -e "- Unmount SD card Done"

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Unmount SD card FAILED.\n"
		return
	fi
	
	echo -e "\n[ Done ] Copy file ${cGreen}${SELECT_FILE}${cReset} to SD card Done"
	echo -e "${NOTICE} Please Uncheck Vbox Menu - USB\n"
}

function kill_all_terminal() {
	local PID_LIST=()
	local PPID_LIST=()
	local RUN_LIST=()
	local count=0

	PID_LIST+=($(ps -efc | grep "bash$" | awk '{print $2}'))
	PPID_LIST+=($(ps -efc | grep "bash$" | awk '{print $3}'))

	echo -e "\n[ Run ] Kill all Terminal\n"

	if [ ! "$1" == "all" ]
	then
		echo -e "${NOTICE} Safe Mode : The terminal where the process is running is not killed."
		echo -e "- If you want to kill all terminal, use '${cYellow}mk kill all${cReset}'\n"
		RUN_LIST+=($(ps -efc | grep "pts" | grep -v "bash$" | grep -v $$ | awk '{print $3}'))

		for i in ${!RUN_LIST[@]}
		do
			for j in ${!PID_LIST[@]}
			do
				if [ "${RUN_LIST[i]}" == "${PID_LIST[j]}" ]
				then
					unset PID_LIST[j]
					unset PPID_LIST[j]
					break
				fi
			done
		done
	fi

	# Excluding processes whose PPID is PID of the current terminal
    for i in ${!PPID_LIST[@]}
    do
        if [ "${PPID_LIST[i]}" == "$$" ]
        then
            unset PID_LIST[i]
        fi
    done

	# Exclude current terminal from terminal exit list
    for i in ${!PID_LIST[@]}
    do
        if [ "${PID_LIST[i]}" == "$$" ]
        then
            unset PID_LIST[i]
            break
        fi
    done

    echo -e "- Total Terminal : ${#PID_LIST[@]}\n"

    for i in ${!PID_LIST[@]}
    do
        count=$(( ${count} + 1 ))
        kill -9 ${PID_LIST[i]}
        echo -e "- Kill Terminal ${count} [ ${cYellow}${PID_LIST[i]}${cReset} ]"
    done

	killall nautilus

    echo -e "\n[ Done ] Kill all Terminal & Folder\n"
}

function show_info() {
	check_installed_package duf
	if [ "$?" -gt 0 ]
	then
		echo -e "${NOTICE} : Sorry. that function need ${cGreen}duf${cReset} Package"
		echo -e "- sudo apt-get install duf"
		return
	fi	

	resize -s 32 ${COLUMNS} >/dev/null
	duf /home
	echo
	neofetch --ascii_colors 7 4 --colors 4 4 4 4 --color_blocks off
	echo
}

function check_inDir_size() {
	local SELECT_DIR=""
	local pre_dir=`pwd`

	echo -e "\n[ Run : check_inDir_size ]"

	if [ $# -eq 1 ]
	then
		if [ "$1" == "?" ]
		then
			cd ~/
			SELECT_DIR=$(fzf ${FZF_SETTING}\
						--preview "cat -n {}"\
						--header "[ Select Dir to Check Size ]")
			if [ ! "${SELECT_DIR}" == "" ]
			then
				echo -e "* SearchDir : ${cGreen}$(dirname ${SELECT_DIR})${cReset}\n"
				du -kh $(dirname ${SELECT_DIR}) --max-depth=1
			fi
			cd ${pre_dir}
		elif [ -d "$1" ]
		then
			echo -e "* SearchDir : ${cGreen}$1${cReset}\n"
			du -kh $1 --max-depth=1
			echo
		else
			echo -e "${NOTICE} $1 not exist.\n"
		fi
		return
	fi

	echo -e "* SearchDir : ${cGreen}$(pwd)${cReset}\n"
	du -kh --max-depth=1
	echo
}

function show_package_list() {
	if [ ! "$1" == "" ]
	then
		dpkg -l | grep $1
	else
		dpkg -l
	fi
}

function solve_gitPull_conflict() {
	local moveList=()
	local checkList=()
	local selectFile=""
	local pre_dir=`pwd`
	local CUR_BACKUP_DATE=`date +%m%d`
	local check_format='\.c|makefile|\.ini|\.h'
	local prevFile=""
	local fixedFile=""
	local CUR_PROJECT=$(project_version_name | tr [a-z] [A-Z])
	local PROJECT_NAME=$(project_version_name)
	local rootDir=`echo -e ${HOME}/blackbox/${PROJECT_NAME}`

	echo -e "\n[ Run : solve_gitPull_conflict ]"
	echo -e "${NOTICE} You Need Match Project to SolveConflict [ Cur : ${cYellow}${CUR_PROJECT}${cReset} ]"
	echo -e "( Tab : Choose File / Enter : Finish Choose File / Esc : Exit )"

	if [ ! -d "${TEMP_BACKUP_CONFILICT_FILES}" ]
	then
		echo -e "${NOTICE} TEMP_BACKUP_CONFILICT_FILES dir not exist. make dir."
		mkdir ${TEMP_BACKUP_CONFILICT_FILES}
	fi

	if [ ! -d "${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}" ]
	then
		echo -e "* Create BackupDir : ${cGreen}${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}${cReset}"
		mkdir ${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}
	fi

	cd ${rootDir}
	selectFile=$(fzf ${FZF_SETTING} \
			--preview "cat -n {}" \
			--header "[ Select the file to Move ]")

	moveList+=(${selectFile})

	echo -e "\n* Move ${#moveList[@]} Files"

	if [ "${#moveList[@]}" == "0" ]
	then
		echo -e "${NOTICE} solve_gitPull_conflict Canceled.\n"
		return
	fi

	for i in ${!moveList[@]}
	do
		cp -avi ${moveList[i]} ${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}
		git checkout -- ${rootDir}/${moveList[i]}
	done

	manage_git_pull

	cd ${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}
	checkList+=($(ls))

	resize -s 24 160 >/dev/null

	for i in ${!checkList[@]}
	do
		prevFile=""
		prevFile=`echo -e ${checkList[i]} | grep -E ${check_format}`
		if [ ! "${prevFile}" == "" ]
		then
			fixedFile=""
			for j in ${!moveList[@]}
			do
				fixedFile=`echo -e ${moveList[j]} | grep -E ${prevFile}`
				if [ ! "${fixedFile}" == "" ]
				then
					echo -e "* File Matching  : '${cGreen}${prevFile}${cReset}' -> ${rootDir}/${fixedFile}"
					meld ./${prevFile} ${rootDir}/${fixedFile}
					break
				fi
			done
		else
			echo -e "* Invalid Format : '${cYellow}${checkList[i]}${cReset}' is Not Valid Format"
		fi
	done

	echo -e "\n[ Done ] solve_gitPull_conflict\n"
	cd ${pre_dir}
}

function open_git_cola() {
	local PROJECT_LIST=(${PROJECT_LIST[@]})

	local is_valid_arg="false"
	local temp_select=""
	local SELECT_PROJECT=""

	# Check Var is valid
	if [ $# -ge 1 ]
	then
		temp_select=`echo -e $1 | tr [a-z] [A-Z]`
		for each in ${PROJECT_LIST[@]}
		do
			if [ "${temp_select}" == "${each}" ]
			then
				is_valid_arg="true"
				break
			fi
		done

		if [ "${is_valid_arg}" == "false" ]
		then
			echo -e "${NOTICE} Not Valid Argument.\n"
			return
		fi
	fi

	# Choose Project to Change
	if [ "${is_valid_arg}" == "true" ]
	then
		# Set Change Project when recv Correct Arg
		SELECT_PROJECT=`echo -e ${temp_select} | tr [A-Z] [a-z]`
	else
		SELECT_PROJECT=$(project_version_name)
	fi
	
	git-cola -r ${HOME}/blackbox/${SELECT_PROJECT}

}

function make_update_file_tool() {
	CUR_DIR=`pwd`
	cd ~/blackbox/source

	if [ $# -eq 0 ]
	then
		make_update_file_help

	elif [ $# -ge 1 ]
	then
		case $1 in
			.)
				make_update_file . $2
				;;
			c)
				if [ $# -eq 1 ]
				then
					make clean
				elif [ "$2" == "." ]
				then
					cd ${CUR_DIR}
					make clean
				fi
				;;
			i)
				if [ $# -eq 1 ]
				then
					make install
				elif [ "$2" == "." ]
				then
					cd ${CUR_DIR}
					make install
				else
					make_update_file $2
				fi
				;;
			ci)
				if [ $# -eq 1 ]
				then
					make clean install
				elif [ "$2" == "." ]
				then
					cd ${CUR_DIR}
					make clean install
				else
					make_update_file $2 cleanInstall
				fi
				;;
			a)
				if [ $# -eq 1 ]
				then
					make_update_file . mkAppOnly
				else
					make_update_file $2 mkAppOnly
				fi
				;;
			r)
				./release.sh
				;;
			dir)
				make make_dir
				;;
			help | -h)
				make_update_file_help
				;;
			list | -l | \?)
				show_mkapp_list $2
				;;
			set | setting | -s)
				change_project $2
				;;
			bu | backup)
				git_backup
				;;
			load)
				git_backup_load
				;;
			opt | -o | option)
				setting_option
				;;
			cp)
				send_file_to_nfs
				;;
			clear)
				manage_dir_clear ${@:2}
				;;
			store)
				fw_install_dir_backup
				;;
			open)
				cd ${CUR_DIR}
				mk_open_dir $2
				;;
			update)
				update_mk_file
				;;
			upp | update_package)
				update_package_version
				;;
			ver | version | verison)
				version_info
				;;
			nfs)
				setting_nfs
				;;
			sd_copy)
				sd_copy_file
				;;
			pull)
				manage_git_pull ${@:2}
				;;
            kill | kill_terminal)
                kill_all_terminal $2
                ;;
			show)
				show_info
				;;
			start)
				update_package_version
				manage_git_pull all
				code
				show_info
				;;
			size)
				cd ${CUR_DIR}
				check_inDir_size $2
				;;
			package_list | plist)
				show_package_list $2
				;;
			solve_conflict | solve)
				solve_gitPull_conflict
				;;
			git_cola | gc)
				open_git_cola $2
				;;
			*)
				make_update_file $1 $2
				;;
		esac
	fi 

	cd ${CUR_DIR}
}

alias mk='make_update_file_tool'

# Personal Function

strip_file() {
	local FileList=()
	FileList+=($(ls -R))
	CUR_DIR=
	VAR=

	for each in ${FileList[@]}
	do
		if [[ "${each}" =~ "./" ]]
		then
			CUR_DIR=${each/:/\/}
			continue
		fi

		VAR=$(file ${CUR_DIR}${each} | grep "not stripped")
		if [ -n "${VAR}" ]
		then
			${CROSS_COMPILE}strip --strip-unneeded ${CUR_DIR}${each}
			if [ $? -gt 0 ]
			then
				echo -e "[ \x1b[31mStip File Failed\x1b[0m ] - ${CUR_DIR}${each}"
				continue
			fi
			echo -e "[ \x1b[32mStip File\x1b[0m ] - ${CUR_DIR}${each}"
		else
			echo -e "${CUR_DIR}${each} not a suitable format to run strip"
		fi 
		VAR=
	done
}

# alias st='strip_file'
alias get_idf='. $HOME/ESP/esp-idf/export.sh'
alias mm='make clean; make; make install;'