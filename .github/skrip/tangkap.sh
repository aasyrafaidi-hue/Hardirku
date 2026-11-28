#!/usr/bin/env bash
# Tangkap skrin reka bentuk Duitku pada emulator (data contoh, tiada data peribadi).
# Guna: tangkap.sh <apk> <folder-output>
set -u
APK="$1"; OUT="$2"; PKG="${PKG:-com.asyraf.hadirku}"
mkdir -p "$OUT"
adb install -r "$APK"
adb shell pm grant $PKG android.permission.POST_NOTIFICATIONS || true
adb logcat -c || true
tangkap() { adb exec-out screencap -p > "$OUT/$1.png"; echo "skrin $1"; }
buka() { adb shell am start -n $PKG/com.asyraf.hadirku.MainActivity --es buka "$1" > /dev/null; sleep "${2:-4}"; }
leret() { adb shell input swipe 540 1700 540 600 450; sleep 2; }
adb shell am start -W -n $PKG/com.asyraf.hadirku.MainActivity
sleep 10
tangkap 01-utama
leret; tangkap 02-utama-2
leret; tangkap 03-utama-3
buka tab:transaksi; tangkap 04-lejar
buka tab:bayaran; tangkap 05-bayaran
leret; tangkap 06-bayaran-2
buka tab:laporan; tangkap 07-laporan
buka tab:kewangan; tangkap 08-kewangan
buka tab:senarai; tangkap 09-barang-dapur
buka tab:kerja; tangkap 10-kerja
buka tab:tetapan; tangkap 11-tetapan
buka menu 3; tangkap 12-menu
leret; tangkap 12b-menu-2
adb shell input keyevent 4; sleep 2
buka tab:poket 3
# butang + tengah (pixel 6: 1080x2400)
adb shell input tap 540 2135; sleep 3; tangkap 13-tambah
adb shell input keyevent 4; sleep 1; adb shell input keyevent 4; sleep 2
# mod gelap
adb shell cmd uimode night yes; sleep 5
buka tab:poket 5; tangkap 14-utama-gelap
buka tab:transaksi; tangkap 15-lejar-gelap
buka tab:bayaran; tangkap 16-bayaran-gelap
buka menu 3; tangkap 17-menu-gelap
adb shell cmd uimode night no
# ujian tekanan: 2,500 sentuhan/leretan rawak (benih tetap) — cari crash / tergantung
adb shell monkey -p $PKG -s 4242 --throttle 120 --pct-syskeys 0 --pct-appswitch 2 --ignore-security-exceptions -v 2500 > "$OUT/monkey.txt" 2>&1 || true
grep -E "CRASH|ANR|Exception" "$OUT/monkey.txt" | head -50 > "$OUT/monkey-ralat.txt" || true
tail -3 "$OUT/monkey.txt" >> "$OUT/monkey-ralat.txt" || true
adb logcat -d > "$OUT/logcat-penuh.txt" || true
grep -E "AndroidRuntime|FATAL|ANR in" "$OUT/logcat-penuh.txt" | head -200 > "$OUT/logcat-ralat.txt" || true
grep "DuitkuJaga" "$OUT/logcat-penuh.txt" | head -200 > "$OUT/jaga.txt" || true
grep "Choreographer" "$OUT/logcat-penuh.txt" | grep -i "skipped" | head -100 > "$OUT/bingkai.txt" || true
ls -la "$OUT"
