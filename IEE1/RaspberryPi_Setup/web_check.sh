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

# ----------------------------------------
# サーバ（DocumentRoot）確認用のファイルをリモートから取得して設置
# - wget: リモートの index.html を取得
# - -N: ローカルに同名ファイルがある場合、リモートの方が新しければ上書きする
# - -O index.html: ダウンロード先ファイル名を index.html に指定
# ----------------------------------------
wget -N -O index.html https://raw.githubusercontent.com/youiwa/youiwa-LAB/refs/heads/master/IEE1/RaspberryPi_Setup/html/index.html
sudo cp index.html /var/www/html

# ----------------------------------------
# ユーザディレクトリ（public_html）確認用のファイルを設置
# - $HOME/public_html/ にコピーすることで、UserDir 機能（http://hostname/~user/）の確認ができる
# ----------------------------------------
sudo cp index.html $HOME/public_html/
# public_html に置いた index.html 内の表示文言を変更（Server -> Server-UserDir）
sed -i 's/Server/Server-UserDir/g' $HOME/public_html/index.html

# ----------------------------------------
# PHP 動作確認用のファイルをリモートから取得して設置
# ----------------------------------------
wget -N -O test.php https://raw.githubusercontent.com/youiwa/youiwa-LAB/refs/heads/master/IEE1/RaspberryPi_Setup/php/test.php
sudo cp test.php /var/www/html
sudo cp test.php $HOME/public_html/

# ----------------------------------------
# Web サーバの動作確認（ローカルからアクセス）
# ----------------------------------------
curl localhost
curl localhost/~$USER/

# ----------------------------------------
# PHP の動作確認（PHP が有効かどうかを確認）
# ----------------------------------------
curl localhost/test.php
curl localhost/~$USER/test.php
