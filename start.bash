#!/bin/bash


KUBESPRAY_FOLDER="$HOME/git/kubespray6"
ANSIBLE_FOLDER="$KUBESPRAY_FOLDER/python3/ansible"
GIT_URL="https://github.com/kubernetes-sigs/kubespray.git"
ORANGE=$(tput setaf 3)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)
ECHO_KUBESPRAY_FOLDER="${ORANGE}$KUBESPRAY_FOLDER${RESET}"
ECHO_ANSIBLE_FOLDER="${ORANGE}$ANSIBLE_FOLDER${RESET}"
ECHO_NO="${BLUE}[NO]\n ${RESET} ---> "
ECHO_SUCCESS="${GREEN}[SUCCESS]\n${RESET}"


echo -e "\n"
echo -n "[Check if folder $ECHO_KUBESPRAY_FOLDER exists]..."
if [ ! -d "$KUBESPRAY_FOLDER" ]; then
  echo -en "$ECHO_NO"
  echo -n "Creating folder $ECHO_KUBESPRAY_FOLDER..."
  mkdir -p $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"
else echo -e "$ECHO_SUCCESS"
fi


echo -n "[Check if folder $ECHO_KUBESPRAY_FOLDER is empty]..."
if [ "$(ls -A1 $KUBESPRAY_FOLDER | wc -l)" -ne 0 ]; then
   echo -en "$ECHO_NO"
   echo -n "[Delete all files in folder $ECHO_KUBESPRAY_FOLDER]..."
   rm -rf $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"
else
   echo -e "$ECHO_YES"
fi



echo  -n  "[Clone kubespray in folder $ECHO_KUBESPRAY_FOLDER]..."
git clone --quiet $GIT_URL  $KUBESPRAY_FOLDER
echo -e "$ECHO_SUCCESS"


echo -n "[Check if Vagrantfile does not exists]..."
if [ ! -f "$KUBESPRAY_FOLDER/Vagrantfile" ]; then
  echo -en "$ECHO_SUCCESS"
else 
  echo -en "$ECHO_NO"
  echo -n "[Delete file $ECHO_KUBESPRAY_FOLDER/Vagrantfile]..."
  rm -f $KUBESPRAY_FOLDER/Vagrantfile && echo -e "$ECHO_SUCCESS"

fi



echo  -n "[Download Vagrantfile]..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/Vagrantfile" -P $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"


echo  -n "[Download phase-II.yml]..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/phase-II.yml" -P $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"



echo -n "[Install apt python3-venv]..."
sudo apt-get -qq -y install python3-venv && echo -e "$ECHO_SUCCESS"



echo -n "[Check if folder $ECHO_ANSIBLE_FOLDER exists]..."
if [ ! -d "$ANSIBLE_FOLDER" ]; then
  echo -en "$ECHO_NO"
  echo -n "Creating folder $ECHO_ANSIBLE_FOLDER..."
  mkdir -p $ANSIBLE_FOLDER && echo -e "$ECHO_SUCCESS"
else 
  echo -n "[Check if folder $ECHO_ANSIBLE_FOLDER is empty]..."
  if [ "$(ls -A1 $ANSIBLE_FOLDER | wc -l)" -ne 0 ]; then
      echo -en "$ECHO_NO"
      echo -n "[Delete all files in folder $ECHO_ANSIBLE_FOLDER]..."
      rm -rf $ANSIBLE_FOLDER && echo -e "$ECHO_SUCCESS"
  else
      echo -e "$ECHO_YES"
  fi

fi


echo -n "[Install python3 venv in folder $ECHO_ANSIBLE_FOLDER]..."
/usr/bin/python3 -m venv --system-site-packages $ANSIBLE_FOLDER/env && echo -e "$ECHO_SUCCESS"


echo -n "[Activate python3 venv]..."
source $ANSIBLE_FOLDER/env/bin/activate && echo -e "$ECHO_SUCCESS"


echo -n "[Install local Ansible in folder $ECHO_ANSIBLE_FOLDER]..."
python3 -m pip install --quiet -r $KUBESPRAY_FOLDER/requirements.txt && echo -e "$ECHO_SUCCESS"


echo -n "[Launch vagrant up]..."
cd "$KUBESPRAY_FOLDER" && vagrant up && echo -e "$ECHO_SUCCESS"


echo -n "[Deactivate python3 venv]..."
deactivate && echo -e "$ECHO_SUCCESS"




