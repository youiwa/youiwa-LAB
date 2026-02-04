#!/bin/bash

set -x # コンソールにコマンドを表示

sudo apt update
sudo apt upgrade -y

sudo apt install vim curl
sudo apt autoremove
sudo apt autoclean

set +x # コマンド表示を解除
