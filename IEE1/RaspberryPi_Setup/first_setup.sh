#!/bin/bash

set -x # コンソールにコマンドを表示

sudo apt update
sudo apt upgrade -y

sudo apt install vim curl wget
sudo apt autoremove
sudo apt autoclean

set +x # コマンド表示を解除
