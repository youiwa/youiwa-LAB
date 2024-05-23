#!/bin/bash
#
# install.sh
#
# Author:
#     Yohei Iwasaki
#      (National Institute of Technology, Kochi College)
# ============
# Script to install Thonny in Linux environment (Debian)
# 
# Usage:
#     install.sh

cd ~
# Linux Update
sudo apt update
sudo apt upgrade -y

# Install required software
sudo apt install nano vim
sudo apt install gcc make curl
sudo apt install build-essential libssl-dev zlib1g-dev
sudo apt install libbz2-dev libreadline-dev libsqlite3-dev
sudo apt install libncursesw5-dev xz-utils tk-dev
sudo apt install libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install pyenv
curl https://pyenv.run | bash
cp .bashrc .bashrc.orig
sed -i '$a export PYENV_ROOT="$HOME/.pyenv"\n[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"\neval "$(pyenv init -)"

# Python Update
pyenv update
pyenv install 3.12.3
pyenv global 3.12.3

# Install pip
sudo apt install python3-pip
pip3 install --upgrade pip

# Install Thonny
pip3 install thonny

# インストールの確認
python3 -V
pip3 -V
thonny -V
