#!/bin/bash
# ================================================================= #
#                           CUSTOM SCRIPT                           #
# ----------------------------------------------------------------- #
#                                                                   #
# * This file is shell script bundle for 'Gnet System'				#
#                                                                   #
# ----------------------------------------------------------------- #
#                                                                   #
# 1. fzf Utility													#
#       - Search utility function using fzf							#
#                                                                   #
# 2. Mk Tool														#
#       - A set of shell script commands for convenience			#
#                                                                   #
# ----------------------------------------------------------------- #
#                                                                   #
# 1. Essential Package												#
#       - fzf														#
#       - ripgrep													#
#                                                                   #
# 2. Recommended Package											#
#       - duf														#
#       - neofetch													#
#                                                                   #
# ----------------------------------------------------------------- #
#                                                                   #
# > Install 'fzf'													#
#   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf	#
#   ~/.fzf/install													#
#                                                                   #
# ----------------------------------------------------------------- #
#											Author : So Byung Jun	#
# ================================================================= #

# Fix Carriage Return Error when Window <-> Linux 
sed -i -e 's/\r$//' ~/.bash_aliases
sed -i -e 's/\r$//' ~/.bash_completion

# Global Define : Color
cRed='\e[31m'
cBlue='\e[34m'
cGreen='\e[32m'
cYellow='\e[33m'
cWhite='\e[37m'
cSky='\e[36m'
cDim='\e[2m'
cBold='\e[1m'
cLine='\e[4m'
cReset='\e[0m'

# Global Define : Prefix
RUN="${cBold}[ ${cGreen}RUN${cReset} ${cBold}]${cReset}"
SET="${cBold}[ ${cBlue}SET${cReset} ${cBold}]${cReset}"
ERROR="${cBold}[ ${cRed}ERROR${cReset} ${cBold}]${cReset}"
NOTICE="${cBold}[ ${cYellow}NOTICE${cReset} ${cBold}]${cReset}"
DONE="${cBold}[ ${cGreen}DONE${cReset} ${cBold}]${cReset}"

function HEAD() { 
	echo -e -n "${cBold}[ $1 ]${cReset}" 
}

function check_installed_package() {
	$1 --version &>/dev/null
}

function show_how_install_fzf() {
		echo -e "${NOTICE} Sorry. that function need ${cGreen}fzf${cReset} Package"
		echo -e "  ================================================================="
		echo -e "  - git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
		echo -e "  - ~/.fzf/install"
		echo -e "  ================================================================="
}

function shorten_path() {
	local PATH=$(echo -e `pwd` | sed "s#${HOME}##g")
	test x"${PATH}" == x && PATH="${cSky}HOME_${TIBET_PROJECT}"
	echo $PATH
}

function get_fw_install_dir() {
	# $1 : project name ( ex : a3, v8 )
	if [ "$1" == "" ]
	then
		local project_name=$(echo -e ${TIBET_PROJECT} | tr [A-Z] [a-z])
		if [ "${project_name}" == "a3" ]
		then
			echo -e -n "${HOME}/tftpboot/janus_a3/fw_install"
		else
			echo -e -n "${HOME}/tftpboot/gnet_${project_name}/fw_install"
		fi
	elif [ "$1" == "a3" ]
	then
		echo -e -n "${HOME}/tftpboot/janus_a3/fw_install"
	else
		echo -e -n "${HOME}/tftpboot/gnet_$1/fw_install"
	fi
}

function get_install_dir() {
	# $1 : project name ( ex : a3, v8 )
	if [ "$1" == "" ]
	then
		local project_name=$(echo -e ${TIBET_PROJECT} | tr [A-Z] [a-z])
		if [ "${project_name}" == "a3" ]
		then
			echo -e -n "${HOME}/install/janus_a3"
		else
			echo -e -n "${HOME}/install/gnet_${project_name}"
		fi
	elif [ "$1" == "a3" ]
	then
		echo -e -n "${HOME}/install/janus_a3"
	else
		echo -e -n "${HOME}/install/gnet_$1"
	fi	
}


# ================================================================= #
# 		                     fzf Utility	                  		#
# ================================================================= #

# base fzf setting
FZF_SETTING="	--height 50%                        \
                --border                            \
                --extended                          \
                --ansi                              \
                --reverse                           \
                --cycle                             \
                --multi                             \
		        --bind=ctrl-d:preview-page-down     \
                --bind=ctrl-u:preview-page-up       \
                --bind=ctrl-space:preview-page-down \
                --bind=ctrl-z:preview-page-up       \
                --bind=ctrl-/:toggle-preview"

# fzf Functions
function fzf_connect_vim() {
	local pre_dir=`pwd`
	local search_value="${cYellow}None Search Value${cReset}"
	local search_time=`date +%H:%M:%S`
	local search_list=()

	echo -n -e "${RUN} fzf-vim Utility By ${cYellow}$1${cReset} "

	if [ "$1" == "Source_Dir" ]
	then
		cd ~/blackbox/source
	elif [ "$1" == "All_Dir" ]
	then
		cd ~/
	fi

	echo -e "( ${cLine}$(pwd)${cReset} )"

	# check grep word
	if [ "$#" -eq 2 ]
	then
		search_value=$2 
		echo -e "${SET} grep -> ${cLine}$2${cReset}"
		_file=$(rg -i --files-with-matches --no-messages "$2" | \
				fzf ${FZF_SETTING} \
				--preview "cat -n {} | rg -i --color always \"$2\"" \
				--header "[ Select the file you want to edit ]")
	else
		_file=$(fzf ${FZF_SETTING} \
				--preview "cat -n {}" \
				--header "[ Select the file you want to edit ]")
	fi

	# write log
	search_list+=(${_file})
	echo -e "[ ${cGreen}${search_value}${cReset} ] _${search_time}" >> ${HOME}/fzf_search_log.txt
	for i in ${!search_list[@]}
	do
		echo -e "-" ${search_list[i]} >> ${HOME}/fzf_search_log.txt
	done
	echo -e "" >> ${HOME}/fzf_search_log.txt

	# open vim
	if [ ! "${_file}" == "" ]
	then
		if [ "$#" -eq 2 ]
		then 
			vim -O -c "/$2" ${_file}
		else
			vim -O ${_file}
		fi
	echo -e "${NOTICE} If you want to see the search history, enter the '${cYellow}fl${cReset}' command."
	fi

	cd ${pre_dir}
}

function fzf_connect_cd() {
	local pre_dir=`pwd`

	cd ~/
	echo -e "${RUN} fzf-cd Utility in ${cLine}$(pwd)${cReset}"

	if [ "$#" -eq 1 ]
	then 
		echo -e "${SET} grep -> ${cLine}$1${cReset}"
		_file=$(rg -i --files-with-matches --no-messages "$1" |\
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

# fzf Aliases
alias ff='fzf_connect_vim Curr_Dir'
alias ffs='fzf_connect_vim Source_Dir'
alias ffa='fzf_connect_vim All_Dir'
alias fcd='fzf_connect_cd'
alias fl='show_fzf_search_log'


# ================================================================= #
#                              Mk Tool                              #
# ================================================================= #

# Option
AUTO_DIR_COPY=Y
AUTO_NFS_DETECT=Y
AUTO_BACKUP=N
CHANGE_PROMPT=Y
IMPROVED_AUTO_COMPLETE=Y

MK_VERSION=1.2.8
LAST_UPDATE=2021-12-28

PROJECT_LIST=( "A3" "S3" "V3" "V4" "V8") 

TEMP_BACKUP_CONFILICT_FILES="${HOME}/blackbox/tempBackupConflict"

NFS_IP='192.168.0.200'
LAST_BACKUP_DATE=1228
LAST_BACKUP_HOUR=09

ROOT_PW=!@so7019so

# ============== Extensions ============== #
EXTENSIONS_DIR=${HOME}/MkTool/Extensions

# SearchTree Ext
EXT_SEARCH_TREE="${EXTENSIONS_DIR}/search_tree.py"
SEARCH_TREE_LOG="openDirName.tree"
# ============== Extensions ============== #

# Set option when 'source ~/.bashrc'
if [ "${CHANGE_PROMPT}" == "Y" ]
then
	PS1="\[${cBold}${cWhite}\][ \[${cGreen}\]\$(echo -e \$(shorten_path))\[\] \[${cWhite}\]]\[${cReset}\] \[${cWhite}\]> \[${cReset}\]"
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
	echo -e "`HEAD Version` \t: ${MK_VERSION}"
	echo -e "`HEAD Last_Update` : ${LAST_UPDATE}"
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
	local PRE_PROJECT=${TIBET_PROJECT}
	local LIST=(${PROJECT_LIST[@]})

	local is_valid_arg="false"
	local temp_select=""
	local SELECT_PROJECT=""

	echo -e "\n[ Current Project : ${cYellow}${PRE_PROJECT}${cReset} ]"

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
	echo -e " - Change setting : .bashrc"
	change_project_by_bashrc ${SELECT_PROJECT}
	echo -e " - ${cYellow}${PRE_PROJECT}${cReset} -> ${cGreen}${SELECT_PROJECT}${cReset}"

	SELECT_PROJECT=$(echo -e ${SELECT_PROJECT} | tr [A-Z] [a-z])

	echo -e " - Change setting : project_change.sh -> ${SELECT_PROJECT}"
	cd ~/blackbox
	./project_change.sh ${SELECT_PROJECT}
	echo -e " - Change Done."

	cd ~
	source ~/.bashrc

	echo -e " - source ~/.bashrc Done.\n"
}

function show_mkapp_list() {
	local PROJECT_NAME=${TIBET_PROJECT}

	local START_LINE=$(cat ~/blackbox/system/mk_app.sh | grep -n 'case $1 in' | awk -F ':' '{print $1}')
	local END_LINE=$(wc -l ~/blackbox/system/mk_app.sh | awk -F ' ' '{print $1}')
	local LIST_LINE=$(cat ~/blackbox/system/mk_app.sh | grep -n 'esac' | awk -F ':' '{print $1}')

	local SUBS=$(( ${END_LINE} - ${START_LINE} + 1 ))
	local TAIL_CUT=$(( ${LIST_LINE} - ${START_LINE} ))	#HC

	echo -e "\n${cYellow}[ Current Project : ${PROJECT_NAME} ]${cReset}"

	if [ ! "$1" == "" ]
	then
		if [ ! "$1" == "title" ]
		then
			cat ~/blackbox/system/mk_app.sh | tail -n ${SUBS} | head -n ${TAIL_CUT} | grep -i $1
		else
			echo -e "${SET} Only Show Title"
			extract_mkapp_list
		fi
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
	local separator="|"

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
			separator="|"

			if [ "${choice_num}" -eq $n ]
			then
				echo -e -n "${cBold}"
				separator=">"
			fi

			test "${opt_value}" == "Y" && printf "${cGreen}"
			test "${opt_value}" == "N" && printf "${cDim}"
			echo -e "$n ${separator} ${OPT_LIST[$n]}" 
			printf "${cReset}"
		done
		echo -e "-------------------------------------------------------------------------------"
        if [ "${choice_num}" == "-1" ]
        then
            echo -e "* No number has been entered yet.\n-\n-"
        else
            echo -e "${cBold}* ${OPT_LIST[$choice_num]}${cReset}"
            echo -e "${DETAIL_INFO_LIST[$choice_num]}"
        fi
		echo -e "== [ Option ] ================================================================="
		printf "Enter the number of options you want to ${cGreen}enable${cReset}/${cDim}disable${cReset} : "

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
	echo -e "\n${DONE} mk Option Setting Done.\n"
}

function send_file_to_nfs() {

	local CUR_DATE=`date +%Y%m%d`
	local INS_DIR=""
	local PROJECT_NAME=$(project_version_name)
	local SELECT_FILE=""
	local COPY_DIR=""

	# Set To. Dir
	INS_DIR=$(get_fw_install_dir ${PROJECT_NAME})

	# Set From. Dir
	COPY_DIR=$(get_install_dir ${PROJECT_NAME})

	cd ${INS_DIR}

	echo -e "${RUN} .arm file : fw_install -> ${cLine}${COPY_DIR}${cReset}"

	# Set Target File
	if [ $(ls -l | grep ${CUR_DATE}\.arm$ | wc -l) -ge 2 ]
	then
		check_installed_package fzf
		if [ "$?" == 0 ]
		then
			SELECT_FILE=`ls -t | grep ${CUR_DATE}\.arm$ | head -n 5 | \
						fzf --cycle --height 10% --reverse --border \
							--header "[ Choice file to copy ./janus ]"`
		else
			local FILE_LIST=(	$(ls -t | grep \.arm$ | awk "NR==1") \
								$(ls -t | grep \.arm$ | awk "NR==2") \
								$(ls -t | grep \.arm$ | awk "NR==3") \
								"Not Copy File" )

			echo -e "[ More than one file in fw_install dir. ]"
			echo -e "${cYellow}[ Choice file to copy ./janus ]${cReset}"
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
		echo -e "- Cancel File Copy to ./janus"
		return
	fi

	cd ${COPY_DIR}
	if [ $(ls -l | grep \.arm$ | wc -l) -gt 0 ]
	then
		rm *.arm
	fi

	cp -a ${INS_DIR}/${SELECT_FILE} ${COPY_DIR}

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Copy file to NFS FAILED.\n"
		return
	fi

	echo -e "${DONE} file copy done : ${cGreen}${SELECT_FILE}${cReset}"
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

function git_stash_save_backup_file() {
	echo -e ${RUN} "git_stash_save_backup_file start"
	cd ~/blackbox/source

	if [ "$(git stash list | grep "mkBackUp" | wc -l)" -eq 1 ]
	then
		echo -e "\n${NOTICE} Stash BackUp file Already Exist. It will be replaced by the latest backup file."
		STASH_NUM=`git stash list | grep "mkBackUp" | awk -F ':' '{print $1}'`
		git stash drop ${STASH_NUM}
	fi

	echo -e "\n"${RUN}  "mkBackUp ---------> Git Stash"
	git stash save "mkBackUp"
	STASH_NUM=`git stash list | grep "mkBackUp" | awk -F ':' '{print $1}'`
	echo -e ${DONE} "git stash save done\n"

	echo -e ${NOTICE} "Current Saved CodeLine"
	git stash show ${STASH_NUM}

	echo -e "\n"${RUN}  " reload  <--------- Git Stash"
	git stash apply -q ${STASH_NUM}
	echo -e "${DONE} BackUp Complete. If you want load backup file, press ${cGreen}'mk load'${cReset}\n"

	change_backup_date
}

function git_stash_apply_backup_file() {
	echo -e ${RUN} "git_stash_apply_backup_file start\n"
	cd ~/blackbox/source

	if [ "$(git stash list | grep "mkBackUp" | wc -l)" -eq 0 ]
	then
		echo -e "\n${ERROR} Stash BackUp file Not Exist. Load process exit.\n"
		return
	fi

	if [ "$(git stash list | grep "TEMP" | wc -l)" -ge 1 ]
	then
		STASH_NUM=`git stash list | grep "TEMP" | awk -F ':' '{print $1}'`
		git stash drop ${STASH_NUM}
	fi

	git stash save "TEMP"

	STASH_NUM=`git stash list | grep "mkBackUp" | awk -F ':' '{print $1}'`
	echo -e "\n"${RUN} "apply  <--------- Git Stash"
	git stash apply -q ${STASH_NUM}

	echo -e ${NOTICE} "Load Code Summary"
	git stash show ${STASH_NUM}

	echo -e "${DONE} BackUp file load complete.\n"
}

function make_update_file() {

	local _option=" "
	local _project_name=$(project_version_name)

	echo -e "\n${RUN} make_update_file"

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
				echo -e "${SET} reset FW dir."
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

			echo -e "${SET} Auto backup option."
			if [ ! "${LAST_BACKUP_DATE}" == "${CUR_BACKUP_DATE}" ] || [ ! "${LAST_BACKUP_HOUR}" == "${CUR_BACKUP_HOUR}" ]
			then
				git_stash_save_backup_file

				if [ $? -gt 0 ]
				then
					echo -e "${ERROR} Auto backup FAILED.\n"
					break
				fi

				echo -e "${DONE} Auto backup done."

			else
				echo -e ${cGreen}"* Already backed up within an hour"${cReset}
			fi

		fi

		cd ~/blackbox/source

		echo -e "${RUN} make${_option}install.\n"
		make${_option}install
		
		if [ $? -gt 0 ]
		then
			echo -e "\n${ERROR} make${_option}install FAILED.\n"
			return
		fi

		echo -e "\n\n${DONE} make${_option}install."
	fi

	cd ~/blackbox/system
	echo -e "${RUN} mk_app.sh${cGreen}" $1 "${cReset}\n\n"
	./mk_app.sh "$1"
	
	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} mk_app.sh $1 FAILED.\n"
		return
	fi

	local make_name="Default"
	test "$1" == "." || make_name=$1

	echo -e "\n\n${DONE}\tF/W update File (${cGreen} ${make_name} ${cReset}) make Done."
	echo -e "`HEAD PROJECT`\t"${TIBET_PROJECT}

	local CUR_DATE=`date +%Y%m%d`
	local INS_DIR=""

	echo -e "`HEAD MAKE_TIME`\t"`date`

	# Auto copy file to ~/FW ( when option : Y )
	if [ "${AUTO_DIR_COPY}" == "Y" ]
	then
		INS_DIR=$(get_fw_install_dir ${_project_name})
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

		echo -e "${DONE}\tFile Copy to '~/FW' Direcotry.\n"
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
	echo -e " * ${cSky}mk list${cReset} 	: Show mk_app.sh list at Current Project ( also '${cSky}mk ?${cReset}' )"
	echo -e " * ${cSky}mk setting${cReset} 	: Change & Adjust project"
	echo -e " * ${cSky}mk option${cReset} 	: Setting mk Tool option"
	echo -e " * ${cSky}mk update${cReset} 	: Update mkTool with latest file from git"
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
	echo -e " * ${cYellow}mk open${cReset}\t: Open the '../fw_install' in Current Project or Other Dir."
	echo -e " * ${cYellow}mk upp${cReset}\t: sudo apt update & upgrade at once"
	echo -e " * mk version\t: View version information"
	echo -e " * mk patch_log\t: View the patch log"
	echo -e " * mk sd_copy\t: Copy the most recent arm file to the mounted SD card"
	echo -e " * ${cYellow}mk pull${cReset}\t: Git pull Current Project"
	echo -e " * ${cYellow}mk kill${cReset}\t: Close all terminals except the process is running"

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
			return
		else
			nautilus $1
			return
		fi
	fi

	INS_DIR=$(get_fw_install_dir ${PROJECT_NAME})
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

	echo -n -e "${RUN} Git Pull - ${cGreen}"
	echo -e ${PROJECT_NAME} | tr [a-z] [A-Z]
	echo -n -e ${cReset}

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
		echo -e "${DONE} Git Pull\n"
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
			echo -e "${DONE} Git Pull\n"
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
	echo -e "${DONE} Git Pull\n"
}

function fw_install_dir_backup() {
	local CUR_DATE=`date +%Y%m%d`
	local INS_DIR=""
	local PROJECT_NAME=$(project_version_name)
	local SELECT_FILE=""
	local COPY_DIR=""
	local BACKUP_DIR="${INS_DIR}/${CUR_DATE}"

	# Set To. Dir
	INS_DIR=$(get_fw_install_dir ${PROJECT_NAME})
	BACKUP_DIR="${INS_DIR}/${CUR_DATE}"

	echo -e "${RUN} Backup arm file in fw_install dir"

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

	echo -e "\n${DONE} File Move to ${cGreen}${BACKUP_DIR}${cReset} Directory.\n"
}

function update_mk_file() {
	local pre_dir=`pwd`

	echo -e "\n${RUN} mk Tool Update"

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

	echo -e "${SET} Extract and save locally saved options"

	for (( i=0; i<${opt_len}; i++ ));
	do
		temp_value=$(get_backup_value_option ${BACKUP_FLAG[$i]})
		BACKUP_OPTION_VALUE+=(${temp_value})
	done

	if [ -d "${HOME}/blackbox/MkTool" ]
	then
		rm -rf ${HOME}/blackbox/MkTool
	fi

	echo -e "${RUN} Git Clone - MkTool"

	cd ${HOME}/blackbox
	git clone https://github.com/so686so/MkTool.git
	cd MkTool

	\mv -f .bash_aliases ${HOME}/
	\mv -f .bash_completion ${HOME}/

	if [ $? -gt 0 ]
	then
		echo -e "${ERROR} Update Failed. Rollback .bash_aliases file."
		mv ~/.bash_aliases_backUp ~/.bash_aliases
		return
	fi

	echo -e "${SET} Applies the temporary saved local storage variable to the newly received file."

	for (( i=0; i<${opt_len}; i++ ));
	do
		temp_line=$(get_line_option ${BACKUP_FLAG[$i]})
		BACKUP_OPTION_LINE+=(${temp_line})
	done

	for (( i=0; i<${opt_len}; i++ ));
	do
		sed -i "${BACKUP_OPTION_LINE[$i]}s/.*/${BACKUP_FLAG[$i]}=${BACKUP_OPTION_VALUE[$i]}/g" ~/.bash_aliases
	done

	echo -e "${DONE} Applies done."

	cd ~
	echo -e "${RUN} Remove temp MkTool Dir"
	rm -rf ${HOME}/blackbox/MkTool

	echo -e "${RUN} Meld Backup .bash_aliases & .bash_completion"
	meld .bash_aliases .bash_aliases_backUp
	meld .bash_completion .bash_completion_backUp

	echo -e "${RUN} Autocomplete script being applied to root directory"
	source ~/.bashrc

	echo -e "${DONE} Autocomplete script being applied done."
	echo -e "${DONE} mk Tool Update Complete\n"

	cd ${pre_dir}
}

function check_root_pw() {
	if [ "${ROOT_PW}" == "" ]
	then
		printf "* Please input your root password : "
		read -s
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

	echo -e "${DONE} Upload Done : <${MK_VERSION}> ${patch_log_comment}"
}

function update_package_version() {
	echo -e "\n${RUN} Package Update "

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

	echo -e "\n${DONE} Package Update Done\n"
}

function setting_nfs() {
	echo -e "\n${RUN} NFS Setting ( ${TIBET_PROJECT} )\n"
	check_installed_package fzf
	if [ $? -gt 0 ]
	then
		show_how_install_fzf
		return
	fi

	local PROJECT_NAME=$(project_version_name)
	local NFS_DIR=""
	local SELECT_VALUE=""

	# Set Dir
	NFS_DIR=$(get_install_dir ${PROJECT_NAME})

	cd ${NFS_DIR}/pack
	SELECT_FILE=`find . -maxdepth 1 -type d | \
				fzf --cycle --height 30% --reverse --border \
				--header "[ Select Model to apply oem.ini ]"`

	if [ "${SELECT_FILE}" == "" ]
	then
		echo -e "${NOTICE} setting nfs cancel"
		return
	fi

	cd ${SELECT_FILE}
	cp -a * ../..
	echo -e "${SET} ${cSky}oem.ini${cReset} ( ${cLine}${SELECT_FILE}${cReset} ) copy"

	cd ${NFS_DIR}/skin
	SELECT_FILE=`find . -maxdepth 1 -type d | \
				fzf --cycle --height 30% --reverse --border \
				--header "[ Select Model to apply skin ]"`

	if [ "${SELECT_FILE}" == "" ]
	then
		echo -e "${NOTICE} setting nfs cancel"
		return
	fi

	cd ${SELECT_FILE}
	cp -a * ./..
	echo -e "${SET} ${cSky}Model Skin${cReset} ( ${cLine}${SELECT_FILE}${cReset} ) copy"

	if [ "${PROJECT_NAME}" == "v3" ]
	then
		cd ${NFS_DIR}/language/gnet/
		cp -a * ./..
		echo -e "${SET} ${cSky}Language${cReset} ( ${cLine}${SELECT_FILE}${cReset} ) copy"
	fi

	echo -e "\n${DONE} NFS Setting Done\n"
}

function sd_copy_file() {
	check_installed_package fzf
	if [ $? -gt 0 ]
	then
		show_how_install_fzf
		return
	fi

	echo -e "\n${RUN} Copy file to SD card\n"

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
	echo -e "${RUN} SD card Path - ${SD_PATH}"

	local INS_DIR=""
	local CUR_DATE=`date +%Y%m%d`
	local PROJECT_NAME=$(project_version_name)
	local SELECT_FILE=""

	INS_DIR=$(get_fw_install_dir ${PROJECT_NAME})
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
		echo -e "\n${NOTICE} Cancel File Copy to SD disk"
		return
	fi

	if [ ! -d "${SD_PATH}/update" ]
	then
		mkdir "${SD_PATH}/update"
	fi

	echo -e "${RUN} Copying..."
	cp -av ${SELECT_FILE} "${SD_PATH}/update"

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Copy file to SD card FAILED.\n"
		return
	fi

	echo -e "\n${RUN} Unmount SD card : ${SD_PATH}"
	umount ${SD_PATH}
	echo -e "${DONE} Unmount SD card Done"

	if [ $? -gt 0 ]
	then
		echo -e "\n${ERROR} Unmount SD card FAILED.\n"
		return
	fi
	
	echo -e "\n${DONE} Copy file ${cGreen}${SELECT_FILE}${cReset} to SD card Done"
	echo -e "${NOTICE} Please Uncheck Vbox Menu - USB\n"
}

function kill_all_terminal() {
	local PID_LIST=()
	local PPID_LIST=()
	local RUN_LIST=()
	local count=0

	PID_LIST+=($(ps -efc | grep "bash$" | awk '{print $2}'))
	PPID_LIST+=($(ps -efc | grep "bash$" | awk '{print $3}'))

	echo -e "\n${RUN} Kill all Terminal\n"

	if [ ! "$1" == "all" ]
	then
		echo -e "${NOTICE} Safe Mode : The terminal where the process is running is not killed."
		echo -e "${NOTICE} If you want to kill all terminal, use '${cYellow}mk kill all${cReset}'\n"
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

	echo -e
	killall nautilus

    echo -e "\n${DONE} Kill all Terminal & Folder\n"
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

	show_git_log_all
}

function check_inDir_size() {
	local SELECT_DIR=""
	local pre_dir=`pwd`

	echo -e "\n${RUN} check_inDir_size"

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

	local CUR_PROJECT=${TIBET_PROJECT}
	local PROJECT_NAME=$(project_version_name)
	local rootDir=`echo -e ${HOME}/blackbox/${PROJECT_NAME}`

	echo -e "\n${RUN} solve_gitPull_conflict"
	echo -e "${NOTICE} You Need Match Project to SolveConflict [ Cur : ${cYellow}${CUR_PROJECT}${cReset} ]"
	echo -e "( Tab : Choose File / Enter : Finish Choose File / Esc : Exit )"

	if [ ! -d "${TEMP_BACKUP_CONFILICT_FILES}" ]
	then
		echo -e "${NOTICE} TEMP_BACKUP_CONFILICT_FILES dir not exist. make dir."
		mkdir ${TEMP_BACKUP_CONFILICT_FILES}
	fi

	if [ ! -d "${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}" ]
	then
		echo -e "${SET} Create BackupDir : ${cGreen}${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}${cReset}"
		mkdir ${TEMP_BACKUP_CONFILICT_FILES}/${CUR_BACKUP_DATE}
	fi

	cd ${rootDir}
	selectFile=$(fzf ${FZF_SETTING} \
			--preview "cat -n {}" \
			--header "[ Select the file to Move ]")

	moveList+=(${selectFile})

	echo -e "\n${RUN} Move ${#moveList[@]} Files"

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

	echo -e "\n${DONE} solve_gitPull_conflict\n"
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

	echo -e "${RUN} open_git_cola [ ${cYellow}$SELECT_PROJECT${cReset} ]"
	
	git-cola -r ${HOME}/blackbox/${SELECT_PROJECT}
}

function show_git_log() {
	local PROJECT_NAME=$1
	local LOWER_PJ_NAME=`echo -e ${PROJECT_NAME} | tr [A-Z] [a-z]`
	local PDIR="${HOME}/blackbox/${LOWER_PJ_NAME}"

	local check_day=$2
	test x"$check_day" == x && check_day=1

	echo -e " ===== ${cBold}${cGreen}${PROJECT_NAME}${cReset} Project Git Log Until ${cBold}$check_day Days${cReset} ============================================================"

	cd ${PDIR}
	git log --color --pretty=format:'%<(2)%C(bold blue)[%>(9) %cr ]%C(reset) - %<(9)%s %C(bold green)/ %an %C(reset)' --since=$check_day.Days
	echo -e " =================================================================================================="

	echo	
}

function show_git_log_all() {
	local pre_dir=$(pwd)
	resize -s 40 150 >/dev/null
	local check_day=1

	local input_val=$1
	local check_val=${input_val//[0-9]/}

	if [ -z "$check_val" ]
	then
		check_day=$input_val
	else
		echo -e "${ERROR} '$input_val' is not number."
		return
	fi

	echo

	for each in ${PROJECT_LIST[@]}
	do
		show_git_log $each $check_day
	done

	cd $pre_dir
}

function search_tree() {

	check_installed_package python3
	if [ "$?" -gt 0 ]
	then
		echo -e "${NOTICE} : Sorry. that function need ${cGreen}python3${cReset} Package"
		echo -e "- sudo apt-get install python3"
		return
	fi

	if [ ! -e ${EXT_SEARCH_TREE} ]
	then
		echo -e "${NOTICE} There are no files to support that feature - ${cYellow}${EXT_SEARCH_TREE}${cReset}"
		return
	fi

	/bin/python3 ${EXT_SEARCH_TREE} $1

	if [ -e ${EXTENSIONS_DIR}/${SEARCH_TREE_LOG} ]
	then
		local openDir=`cat ${EXTENSIONS_DIR}/${SEARCH_TREE_LOG}`
		echo -e ${SET} "Oepn Dir : ${cGreen}$openDir${cReset}\n"
		nautilus $openDir
	fi
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
				git_stash_save_backup_file
				;;
			load)
				git_stash_apply_backup_file
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
			log)
				show_git_log_all $2
				;;
			tree)
				search_tree $2
				;;
			*)
				make_update_file $1 $2
				;;
		esac
	fi 

	cd ${CUR_DIR}
}

alias mk='make_update_file_tool'


# ================================================================= #
#                          Global Aliases                           #
# ================================================================= #

alias sc='f() {
			source ~/.bashrc;
			echo -e "${DONE} Source ~/.bashrc Complete "; }; f'

alias x='exit'
alias t='gnome-terminal'

alias cds='cd ~/blackbox/source'
alias cdss='cd ~/blackbox/system'
alias cdk='cd ~/blackbox/system/kernel'
alias cdu='cd ~/blackbox/util'
alias Vim='vim -O'

# alias st='strip_file'
alias get_idf='. $HOME/ESP/esp-idf/export.sh'
alias get_42_if='. $HOME/ESP/esp_4_2/esp-idf/export.sh'
alias mm='make clean; make; make install;'

function show_alias() {
	echo -e " =============================="
	cat $1 | grep -n ^alias | awk -F 'alias ' '{print $2}' | awk -F '=' '{print " - " $1}'
	echo -e " ==============================\n"
}

# show alias list
alias al='f() {
			echo -e "\n "`HEAD .bashrc`;
			show_alias ~/.bashrc;
			echo -e "\n "`HEAD .bash_aliases`;
			show_alias ~/.bash_aliases; }; f'

# Personal Function
function strip_file() {
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