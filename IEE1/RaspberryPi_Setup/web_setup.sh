#!/usr/bin/bash

set -x

# Update & Upgrade
sudo apt update -y
sudo apt upgrade -y

# Webサーバ（Aparche2）のインストール
sudo apt install apache2 -y
sudo systemctl start apache2

# ユーザディレクトリの有効化（Web）
sudo a2enmod userdir
sudo systemctl restart apache2

# public_htmlの作成とパーミッション設定
cd
mkdir public_html
chmod 755 public_html
chmod 711 $HOME

# PHPのインストール
sudo apt install php -y
# sudo apt install php-fpm

# ユーザディレクトリでPHPを有効化
## phpのバージョンを抽出（例：8.4）
buff=$(php -v | head -n 1 | awk -F' ' '{print $2}' | cut -d'.' -f1-2)
## 設定ファイル(php8.4.conf)のバックアップ
sudo cp /etc/apache2/mods-available/php$buff.conf /etc/apache2/mods-available/php$buff.conf.$(date +%Y%m%d)
## 設定ファイルの修正
sudo sed -i 's/php_admin_flag engine Off/# php_admin_flag engine Off/g' /etc/apache2/mods-available/php$buff.conf

# Webサーバ再起動
sudo systemctl restart apache2

sudo apt autoremove -y
sudo apt autoclean -y

set +x
