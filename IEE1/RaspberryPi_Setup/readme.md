# RaspberryPiの環境（情報工学実験Ⅰ）構築

情報工学実験Ⅰで実施する環境が実際にRaspberryPiで構築できるかどうかを試すためのスクリプトなどをまとめてあります。

## セットアップ確認環境の構築

### WSL版

Debian13(Trixie)をWSLでインストール

```powershell
wsl --install -d Debian
# 初期設定のユーザー名・パスワードを適宜設定してください
```

セットアップした仮想環境を起動

```powershell
wsl -d Debian
```

仮想環境内で以下を実行

```bash
# 設定ファイルのバックアップ
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 参照先を bookworm(12) から trixie(13) に置換
sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

sudo apt update
sudo apt full-upgrade -y

cat /etc/debian_version
# 「13.x」と表示されれば成功です
```

## Webサーバ

- Webサーバのインストール・有効化
- PHPの有効化
- ユーザディレクトリの有効化
　- ユーザディレクトリでのPHP有効化
- セキュリティ対策

### ユーザディレクトリとPHPの有効化

## DNSサーバ

## ファイアウォール

## PHP

