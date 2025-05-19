#!/bin/bash

echo "[*] Zombi (defunct) süreçler taranıyor..."

# Zombi süreçleri listele
zombies=$(ps -eo pid,ppid,state,cmd --no-headers | awk '$3 == "Z" { print $1, $2 }')

if [ -z "$zombies" ]; then
    echo "[✓] Aktif zombi süreç bulunamadı."
    exit 0
fi

echo "[!] Zombi süreçler bulundu:"
echo "$zombies" | while read -r pid ppid; do
    echo "    → PID: $pid (defunct), PPID: $ppid (ebeveyn)"
done

# Kullanıcıdan onay al
echo
read -p "[?] Bu zombi süreçlerin ebeveynlerini (PPID) öldürmek istiyor musun? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "[✗] İşlem iptal edildi."
    exit 1
fi

# Ebeveyn süreçleri öldür
echo "[*] Ebeveyn süreçler SIGTERM ile öldürülüyor..."
echo "$zombies" | awk '{print $2}' | sort -u | while read -r ppid; do
    if ps -p "$ppid" > /dev/null 2>&1; then
        echo "    → kill -15 $ppid"
        kill -15 "$ppid"
    fi
done

echo "[✓] Zombi süreçlerin ebeveynlerine SIGTERM gönderildi. 2-3 saniye bekleniyor..."
sleep 3

# Kalanlar varsa SIGKILL ile zorla öldür
still_zombies=$(ps -eo pid,ppid,state --no-headers | awk '$3 == "Z" { print $2 }' | sort -u)
if [ -n "$still_zombies" ]; then
    echo "[!] Bazı zombiler hâlâ aktif. Ebeveynlere SIGKILL gönderiliyor..."
    echo "$still_zombies" | while read -r ppid; do
        if ps -p "$ppid" > /dev/null 2>&1; then
            echo "    → kill -9 $ppid"
            kill -9 "$ppid"
        fi
    done
else
    echo "[✓] Zombi süreçler başarıyla temizlendi."
fi
