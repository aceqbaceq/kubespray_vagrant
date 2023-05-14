#!/bin/bash

set -e

KUBESPRAY_FOLDER="./kubespray"
POETRY_VERSION="1.1.15"
GIT_URL="https://github.com/kubernetes-sigs/kubespray.git"
GIT_COMMIT="4ffe138dfaf400637acaf334d9e88528971fa372"
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


echo  -n "[Change current directory to $KUBESPRAY_FOLDER]..."
cd  $KUBESPRAY_FOLDER  && echo -e "$ECHO_SUCCESS"


echo  -n  "[Checkout kubespray repo to a particular commit]..."
git checkout $GIT_COMMIT 2>/dev/null
echo -e "$ECHO_SUCCESS"




echo  -n "[Download ping.yml]..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/ping.yml"  && echo -e "$ECHO_SUCCESS"



echo  -n "[Download python poetry config files]...pyproject.toml..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/poetry/pyproject.toml" && echo -e "$ECHO_SUCCESS"
echo  -n "[Download python poetry config files]...poetry.lock..."
wget -q -nv "https://raw.githubusercontent.com/aceqbaceq/kubespray_vagrant/master/poetry/poetry.lock" && echo -e "$ECHO_SUCCESS"


echo  -n "[Install python poetry package manager]..."
curl -sSL https://install.python-poetry.org | python3 - --version $POETRY_VERSION  1>/dev/null  && echo -e "$ECHO_SUCCESS"


echo  -n "[Install python packages via poetry]..."
~/.local/bin/poetry install  && echo -e "$ECHO_SUCCESS"

echo  -n "[Show ansible version]..."
~/.local/bin/poetry run ansible --version  && echo -e "$ECHO_SUCCESS"

echo  -n "[disable cows in ansible]..."
export ANSIBLE_NOCOWS=1

echo  -n "[provision cluster.yml]..."
~/.local/bin/poetry run ansible-playbook -b -i ../inventory ./cluster.yml  && echo -e "$ECHO_SUCCESS"



