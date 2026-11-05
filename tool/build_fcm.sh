#!/usr/bin/env bash
# Build web + APK dengan konfigurasi FCM dari .fcm.env.
#
# Catatan penting: JANGAN merakit flag "--dart-define=..." ke dalam satu variabel
# lalu memakainya tanpa tanda kutip — di zsh variabel tidak dipecah jadi kata,
# sehingga seluruh string masuk sebagai nilai define PERTAMA dan define
# berikutnya hilang (gejalanya: "push belum diisi (2/6)"). Di sini kita pakai
# --dart-define-from-file supaya tidak bergantung pada perilaku shell.
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ! -f .fcm.env ]]; then
  echo "GAGAL: .fcm.env tidak ada — isi dulu nilai FCM (lihat README-PUSH.md)" >&2
  exit 1
fi

TAG="rev-$(date +%Y%m%d-%H%M)"
TMP_DEFINE="$(mktemp -t fcm-defines.XXXXXX)"
trap 'rm -f "$TMP_DEFINE"' EXIT

grep -v '^[[:space:]]*#' .fcm.env | grep -v '^[[:space:]]*$' > "$TMP_DEFINE"
printf 'BUILD_TAG=%s\n' "$TAG" >> "$TMP_DEFINE"

echo "== BUILD_TAG: $TAG =="
echo "== nilai define yang dipakai =="
sed 's/=.*/=<diisi>/' "$TMP_DEFINE"

flutter analyze
flutter test

# Service worker HARUS digenerasi ulang setiap build — kalau tidak, versi lama
# tertinggal di web/ dan ikut terpaket (pernah bikin notifikasi dobel).
python3 tool/siapkan_web_push.py

flutter build web --release --dart-define-from-file="$TMP_DEFINE"
flutter build apk --release --target-platform android-arm64 \
  --dart-define-from-file="$TMP_DEFINE"

ZIP="/tmp/smart-web-$TAG.zip"
( cd build/web && rm -f "$ZIP" && zip -qr "$ZIP" . )

echo "== hasil =="
ls -lh build/app/outputs/flutter-apk/app-release.apk "$ZIP"
echo "ZIP=$ZIP"
echo "TAG=$TAG"

# Bukti konfigurasi benar-benar masuk: apiKey harus pendek (~39 char) dan
# senderId harus muncul sebagai nilai tersendiri, bukan tercampur flag.
python3 - "$TMP_DEFINE" <<'PY'
import sys
env = dict(
    line.strip().split('=', 1)
    for line in open(sys.argv[1])
    if '=' in line
)
for k in ('FCM_API_KEY', 'FCM_PROJECT_ID', 'FCM_SENDER_ID', 'FCM_WEB_APP_ID', 'FCM_VAPID_KEY'):
    v = env.get(k, '')
    print(f'{k:20s} panjang={len(v)}')
    if '--dart-define' in v or ' ' in v:
        print('  !! NILAI RUSAK — berisi spasi/flag')
        sys.exit(1)
PY
