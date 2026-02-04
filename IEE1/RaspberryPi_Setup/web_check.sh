#!/usr/bin/bash

set -x

# サーバ確認用のファイルをコピー
wget https://raw.githubusercontent.com/youiwa/youiwa-LAB/refs/heads/master/IEE1/RaspberryPi_Setup/index.html
sudo cp index.html /var/www/html

# ユーザディレクトリ確認用のファイルをコピー
sudo cp index.html $HOME/public_html/
sed -i 's/Server/Server-UserDir/g' $HOME/public_html/index.html

# 確認
curl localhost
curl localhost/~$USER/

set +x
