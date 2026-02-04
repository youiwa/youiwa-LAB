#!/usr/bin/bash

set -x

wget https://raw.githubusercontent.com/youiwa/youiwa-LAB/refs/heads/master/IEE1/RaspberryPi_Setup/index.html
sudo cp index.html /var/www/html
curl localhost

sudo cp index.html $HOME/public_html/
sed -i 's/Server/Server-UserDir/g' ~/public_html/index.html
curl localhost/~$USER/

set +x
