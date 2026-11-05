#!/usr/bin/env python3
"""Siapkan konfigurasi FCM untuk build web + cetak flag --dart-define.

Baca `.fcm.env` (tidak di-commit) berisi:

    FCM_API_KEY=...
    FCM_PROJECT_ID=...
    FCM_SENDER_ID=...
    FCM_ANDROID_APP_ID=1:123:android:abc
    FCM_WEB_APP_ID=1:123:web:def
    FCM_VAPID_KEY=BD...

Lalu:
    python3 tool/siapkan_web_push.py           # tulis web/firebase-messaging-sw.js
    python3 tool/siapkan_web_push.py --flags   # cetak --dart-define untuk build

Tanpa berkas itu, script keluar dengan pesan jelas dan build tetap jalan
(push berstatus "belum dikonfigurasi").
"""

from __future__ import annotations

import sys
from pathlib import Path

AKAR = Path(__file__).resolve().parent.parent
SUMBER = AKAR / ".fcm.env"
TEMPLATE = AKAR / "web" / "firebase-messaging-sw.template.js"
KELUARAN = AKAR / "web" / "firebase-messaging-sw.js"

WAJIB = [
    "FCM_API_KEY",
    "FCM_PROJECT_ID",
    "FCM_SENDER_ID",
    "FCM_WEB_APP_ID",
    "FCM_VAPID_KEY",
]

OPSIONAL = ["FCM_ANDROID_APP_ID"]


def baca_env() -> dict[str, str]:
    if not SUMBER.exists():
        print(f"Tidak ada {SUMBER.name}. Push akan berstatus 'belum dikonfigurasi'.")
        print("Buat berkas itu dulu (lihat README-PUSH.md), lalu jalankan lagi.")
        sys.exit(1)

    nilai: dict[str, str] = {}
    for baris in SUMBER.read_text(encoding="utf-8").splitlines():
        baris = baris.strip()
        if not baris or baris.startswith("#") or "=" not in baris:
            continue
        kunci, _, isi = baris.partition("=")
        nilai[kunci.strip()] = isi.strip().strip('"').strip("'")

    hilang = [k for k in WAJIB if not nilai.get(k)]
    if hilang:
        print("Nilai wajib belum diisi: " + ", ".join(hilang))
        sys.exit(1)
    return nilai


def tulis_sw(nilai: dict[str, str]) -> None:
    isi = TEMPLATE.read_text(encoding="utf-8")
    for kunci in WAJIB + OPSIONAL:
        isi = isi.replace(f"__{kunci}__", nilai.get(kunci, ""))
    KELUARAN.write_text(isi, encoding="utf-8")
    print(f"Ditulis: {KELUARAN.relative_to(AKAR)}")


def cetak_flags(nilai: dict[str, str]) -> None:
    bagian = " ".join(f"--dart-define={k}={v}" for k, v in nilai.items() if v)
    print("\nPakai untuk build:\n")
    print(f"flutter build web --release {bagian}")
    print(f"\nflutter build apk --release {bagian}\n")


if __name__ == "__main__":
    konfigurasi = baca_env()
    tulis_sw(konfigurasi)
    if "--flags" in sys.argv:
        cetak_flags(konfigurasi)
