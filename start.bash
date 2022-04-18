#!/bin/bash

set -e

KUBESPRAY_FOLDER="$HOME/git/kubespray6"
GIT_URL="https://github.com/kubernetes-sigs/kubespray.git"
ORANGE=$(tput setaf 3)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)
ECHO_KUBESPRAY_FOLDER="${ORANGE}$KUBESPRAY_FOLDER${RESET}"
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

echo  -n "[Download ping.yml]..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/ping.yml" -P $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"


echo  -n "[Download phase-II.yml]..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/phase-II.yml" -P $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"


echo  -n "[Download python poetry config files]..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/poetry/pyproject.toml" -P $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/poetry/poetry.lock" -P $KUBESPRAY_FOLDER && echo -e "$ECHO_SUCCESS"


echo  -n "[Install python poetry package manager]..."
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -  && echo -e "$ECHO_SUCCESS"


echo  -n "[Change current directory to $KUBESPRAY_FOLDER]..."
cd  $KUBESPRAY_FOLDER  && echo -e "$ECHO_SUCCESS"

echo  -n "[Install python packages via poetry]..."
poetry install  && echo -e "$ECHO_SUCCESS"

echo  -n "[Show ansible version]..."
poetry run ansible --version  && echo -e "$ECHO_SUCCESS"


echo -n "[Launch vagrant up]..."
poetry run  vagrant up  && echo -e "$ECHO_SUCCESS"

echo  -n "[provision cluster.yml]..."
poetry run ansible-playbook -i ./.vagrant/provisioners/ansible/inventory ./cluster.yml  && echo -e "$ECHO_SUCCESS"

echo  -n "[provision phase-II.yml]..."
poetry run ansible-playbook -i ./.vagrant/provisioners/ansible/inventory ./phase-II.yml  && echo -e "$ECHO_SUCCESS"










