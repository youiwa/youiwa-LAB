#!/usr/bin/bash

# デバッグ表示を有効にする（実行されるコマンドを標準出力に表示）
set -x

# -------------------------------
# エラーハンドリング設定
# - -e: コマンドが非ゼロ終了ステータスを返したら直ちに終了
# - -u: 未定義変数の参照をエラーにする
# - -o pipefail: パイプ内のどれかのコマンドが失敗したら全体を失敗にする
# - IFS: フィールド分割を安全に設定
# - ERR トラップ: どのコマンド／行で失敗したかを出力して終了コードを返す
# -------------------------------
set -euo pipefail
IFS=$'\n\t'

trap 'rc=$?; echo "Error: command \"${BASH_COMMAND}\" failed with exit code ${rc} at line ${BASH_LINENO[0]}" >&2; exit ${rc}' ERR

log "WebサーバとPHPの設定を開始します"

# Update & Upgrade
sudo apt update -y
sudo apt upgrade -y

# Webサーバ（Aparche2）のインストール
log "apache2 をインストールします"
sudo apt install apache2 -y
sudo systemctl start apache2

# ユーザディレクトリの有効化（Web）
log "Apache の userdir モジュールを有効にします"
sudo a2enmod userdir
sudo systemctl restart apache2

# public_htmlの作成とパーミッション設定
log "public_htmlの作成とパーミッションの設定を行います"
cd
mkdir public_html
chmod 755 public_html
chmod 711 $HOME

# PHPのインストール
log "PHPをインストールします"
sudo apt install php -y
# sudo apt install php-fpm

# ユーザディレクトリでPHPを有効化
log "ユーザディレクトリでPHPを有効化します。"
## phpのバージョンを抽出（例：8.4）
buff=$(php -v | head -n 1 | awk -F' ' '{print $2}' | cut -d'.' -f1-2)
## 設定ファイル(php8.4.conf)のバックアップ
sudo cp /etc/apache2/mods-available/php$buff.conf /etc/apache2/mods-available/php$buff.conf.$(date +%Y%m%d)
## 設定ファイルの修正
sudo sed -i 's/php_admin_flag engine Off/# php_admin_flag engine Off/g' /etc/apache2/mods-available/php$buff.conf

# Webサーバ再起動
log "Webサーバを再起動します"
sudo systemctl restart apache2

log "不要パッケージの削除とキャッシュのクリーンアップを行います"
sudo apt autoremove -y
sudo apt autoclean -y

set +x

log "WebサーバとPHPの設定が終了しました"
