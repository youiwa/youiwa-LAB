# RaspberryPiの環境（情報工学実験Ⅰ）構築

情報工学実験Ⅰで実施する環境が実際にRaspberryPiで構築できるかどうかを試すためのスクリプトなどをまとめてあります。

## セットアップ確認環境の構築

### WSL版

#### Debian13(Trixie)をWSLでインストール

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

#### Debian13(Trixie)をWSLでアンインストール

```powershell
wsl --unregister 仮想環境名
# ↓ Debianの場合
wsl --unregister Debian

# 正確な仮想環境の名前は、wsl -l -vで確認できる
```

#### WSLでhostnameを変更する

WSL2のホスト名は、通常のLinuxの手順（hostnameコマンドなど）だけでは再起動時にWindows側の名前へ戻ってしまいます。永続的に変更するには /etc/wsl.conf を使用する。

```bash
sudo nano /etc/wsl.conf

# 以下3行を追記
[network]
hostname = 好きなホスト名
generateHosts = false
```

ホスト名の解決を正しく行うため、/etc/hosts の内容も新しい名前に書き換える。

```bash
sudo nano /etc/hosts
# 127.0.1.1（または旧ホスト名が書かれた行）を新しいホスト名に変更して保存
```

WSLを再起動する。

```powershell
wsl --shutdown
```

## 作業環境の準備

```bash
wget https://raw.githubusercontent.com/youiwa/youiwa-LAB/refs/heads/master/IEE1/RaspberryPi_Setup/first_setup.sh
chmod +x first_setup.sh
./first_setup.sh
```

- ソフトウェアのインストール
  - vim, curl

## Webサーバ ← web_setup.sh

- Webサーバのインストール・有効化
- PHPの有効化
- ユーザディレクトリの有効化
　- ユーザディレクトリでのPHP有効化
- セキュリティ対策

```bash
wget https://raw.githubusercontent.com/youiwa/youiwa-LAB/refs/heads/master/IEE1/RaspberryPi_Setup/web_check.sh
chmod +x web_check.sh
./web_check.sh
```

### ユーザディレクトリとPHPの有効化

## DNSサーバ

## ファイアウォール

## PHP

