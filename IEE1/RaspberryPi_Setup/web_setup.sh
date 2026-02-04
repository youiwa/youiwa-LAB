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
sudo apt install php-fpm
sudo systemctl restart apache2
