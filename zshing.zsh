#!/bin/zsh

ZSHING_DIR="$HOME/.zshing"
ZSHING_LIST="$(dirname $0)/.list"

#---------------#
# Enable option #
#---------------#
setopt nonomatch # enable retuen null if command not working

#-------------#
# Help Dialog #
#-------------#
zshing_help () {
echo "
    ZSHING ( 0.1 )
    Write by Zakaria Gatter (zakaria.gatter@gmail.com)

    Zsh Plugin to manage Plugin semiler to VundleVim

    OPTS : 
        zshing_install  [Install Plugin direct from source]
        zshing_update   [Update exist Plugins in youe system]
        zshing_clean    [Clean and Remove unwanted Plugins]
        zshing_search   [Search for Plugins Themes and Completions]
        zshing_help     [Show this help Dialog]
"
exit 0
}

#------------------#
# Install Function #
#------------------#
_GIT_INSTALL_ () {
echo -en "[?] -: $1 :- Is Installing ... \r"

# git clone the repo with out show output
git clone https://github.com/$1 $2 >> /dev/null

# show msg if the command is seccus or not 
[ "$?" = 0 ] && {
    echo -en "[+] -: $1 :- Install Seccusfuly "
} || {
    echo -en "[X] -: $1 :- There is Unknown Error it maybe connection or reponame "
}
}

#-----------------#
# Update Function #
#-----------------#
_GIT_UPDATE_ () {
echo -en "[?] -: $1 :- Is Updating ... \r"

# git pull the repo with out show output
git pull >> /dev/null

# show msg if the command is seccus or not 
[ "$?" = 0 ] && {
    echo -en "[^] -: $1 :- Update Seccusfuly "
} || {
    echo -en "[X] -: $1 :- There is Unknown Error it maybe connection or reponame "
}
}

#-----------------#
# Remove Function #
#-----------------#
_GIT_REMOVED_ () {
echo -en "[?] -: $1 :- Is Removing ... \r"

# Remove the repo with out show output
rm -rf "$ZSHING_DIR/$1" >> /dev/null

# show msg if the command is seccus or not 
[ "$?" = 0 ] && {
    echo -en "[-] -: $1 :- Removed Seccusfuly "
} || {
    echo -en "[X] -: $1 :- There is Unknown Error "
}
}

#------------------------#
# ZShing Install Command #
#------------------------#
zshing_install () {
for ZI in ${ZSHING_PLUGINS[@]} ; do 

# get repo name 
ZI_NAME=$(echo "$ZI" | cut -d / -f2-)

# check if repo allready exist 
[ -d "$ZSHING_DIR/$ZI_NAME" ] || {
    _GIT_INSTALL_ "$ZI" "$ZSHING_DIR/$ZI_NAME"
}

done 

# source the zshrc 
source ~/.zshrc

unset ZI ZI_NAME
}

#-----------------------#
# Zshing Update Command #
#-----------------------#
zshing_update () {

# get current directory 
CD="$PWD"

for ZU in ${ZSHING_PLUGINS[@]} ; do 

# get repo name 
ZU_NAME=$(echo "$ZU" | cut -d / -f2-)

# go to repo 
cd "$ZSHING_DIR/$ZU_NAME"

# update the repo 
_GIT_UPDATE_ "$ZU"

done 

# back to current directory
cd $CD

# source the zshrc 
source ~/.zshrc

unset ZU CD ZU_NAME
}

#----------------------#
# Zshing Clean Command #
#----------------------#
zshing_clean () {
LIST_PLUGINS=$(ls -d $ZSHING_DIR/*/ | cut -d / -f1)

for ZC in ${ZSHING_PLUGINS[@]}; do 
ZC_NAME=$(echo "$ZC" | cut -d / -f2-)

LIST_PLUGINS=$(echo "$LIST_PLUGINS" | sed "s:$ZC_NAME::")

done 

for DZC in $(echo $LIST_PLUGINS) ; do 
    _GIT_REMOVED_ "$DZC"
done 

source ~/.zshrc

unset DZC LIST_PLUGINS ZC_NAME 
}

#-----------------------#
# Zshing search Command #
#-----------------------#
zshing_search () {
grep -i --color=auto "$1" $ZSHING_LIST
}

#------------------------------#
# Source All Plugins u Install #
#------------------------------#
N_SZ=0

for SZ in ${ZSHING_PLUGINS[@]}; do 
SZ_NAME=$(echo $SZ | cut -d / -f2-)

[ -d "$ZSHING_DIR/$SZ_NAME" ] && {
    if [ -n "$(ls $ZSHING_DIR/$SZ_NAME/*.zsh*)" ];then 
        source $ZSHING_DIR/$SZ_NAME/*.zsh*
    elif [ -n "$(ls $ZSHING_DIR/$SZ_NAME/*.sh*)" ];then 
        source $ZSHING_DIR/$SZ_NAME/*.sh*
    else
        echo -e "[X] -: $SZ :- Zshing can't source This Plugin there is no [zsh/sh] extantion "
        N_SZ=$(($N_SZ+1))
    fi
}

done 

[ "$N_SZ" -eq 0 ] || exit 1

unset SZ N_SZ
