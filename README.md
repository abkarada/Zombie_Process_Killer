# 🧟 Zombie Killer - Zombi Süreç Temizleyici

Bu Bash betiği, Linux sistemlerinde aktif olan **zombi süreçleri (`defunct`)** tespit eder ve bunlara neden olan **ebeveyn süreçleri**ni (PPID) sonlandırarak sisteminizi temizler. Zombi süreçler sistem belleğinde boşa yer kaplar ve kaynak tüketimine yol açabilir. Bu araçla sisteminizi rahatlatın.

---

## 🚀 Özellikler

- 🔍 Aktif `defunct` (zombi) süreçleri tarar.
- 🧠 Hangi PID’lerin ebeveynlerinin sorun çıkardığını listeler.
- ✅ Kullanıcıdan onay alarak ebeveyn süreçleri önce **nazikçe (SIGTERM)** öldürür.
- ❗ Zombi süreci hâlâ temizlenemediyse **zorla (SIGKILL)** müdahale eder.
- 📦 Herhangi bir GNU/Linux dağıtımında çalışır (`ps`, `awk`, `kill` araçlarını kullanır).

---

## 🔧 Kurulum

```bash
git clone https://github.com/kullanici/zombie-killer.git
cd zombie-killer
chmod +x kill_zombies.sh

## Kullanım

./kill_zombies.sh
