#!/usr/bin/env python3
"""Siapkan konfigurasi FCM untuk build web + cetak flag --dart-define.

Dua sumber nilai, dipakai berurutan:

1. `android/app/google-services.json` (kalau ada) — dipakai untuk apiKey,
   projectId, messagingSenderId, dan androidAppId. Ini jalur praktis: cukup
   taruh berkas dari Firebase Console, Android langsung siap.
2. `.fcm.env` (tidak di-commit) — untuk nilai yang TIDAK ada di
   google-services.json, yaitu:

       FCM_WEB_APP_ID=1:123:web:def      # wajib untuk web
       FCM_VAPID_KEY=BD...               # wajib untuk web

   Nilai lain boleh ditulis di sini juga untuk menimpa hasil parsing.

Lalu:
    python3 tool/siapkan_web_push.py           # tulis web/firebase-messaging-sw.js
    python3 tool/siapkan_web_push.py --flags   # cetak flag --dart-define

Tanpa konfigurasi lengkap, script keluar dengan pesan jelas dan build tetap
jalan (push berstatus "belum dikonfigurasi").
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

AKAR = Path(__file__).resolve().parent.parent
SUMBER_ENV = AKAR / ".fcm.env"
GOOGLE_SERVICES = AKAR / "android" / "app" / "google-services.json"
TEMPLATE = AKAR / "web" / "firebase-messaging-sw.template.js"
KELUARAN = AKAR / "web" / "firebase-messaging-sw.js"

WAJIB = [
    "FCM_API_KEY",
    "FCM_PROJECT_ID",
    "FCM_SENDER_ID",
    "FCM_WEB_APP_ID",
    "FCM_VAPID_KEY",
]

OPSIONAL = ["FCM_ANDROID_APP_ID", "FCM_STORAGE_BUCKET"]


def baca_env() -> dict[str, str]:
    if not SUMBER_ENV.exists():
        return {}

    nilai: dict[str, str] = {}
    for baris in SUMBER_ENV.read_text(encoding="utf-8").splitlines():
        baris = baris.strip()
        if not baris or baris.startswith("#") or "=" not in baris:
            continue
        kunci, _, isi = baris.partition("=")
        nilai[kunci.strip()] = isi.strip().strip('"').strip("'")
    return nilai


def baca_google_services() -> dict[str, str]:
    if not GOOGLE_SERVICES.exists():
        return {}

    try:
        data = json.loads(GOOGLE_SERVICES.read_text(encoding="utf-8"))
    except json.JSONDecodeError as galat:
        print(f"google-services.json tidak bisa dibaca: {galat}")
        sys.exit(1)

    informasi = data.get("project_info", {})
    klien = (data.get("client") or [{}])[0]
    api_key = ((klien.get("api_key") or [{}])[0]).get("current_key", "")

    return {
        "FCM_API_KEY": api_key,
        "FCM_PROJECT_ID": informasi.get("project_id", ""),
        "FCM_SENDER_ID": str(informasi.get("project_number", "")),
        "FCM_ANDROID_APP_ID": (klien.get("client_info") or {}).get(
            "mobilesdk_app_id", ""
        ),
        "FCM_STORAGE_BUCKET": informasi.get("storage_bucket", ""),
    }


def gabung() -> dict[str, str]:
    nilai = baca_google_services()
    nilai.update({k: v for k, v in baca_env().items() if v})
    return nilai


def tulis_sw(nilai: dict[str, str]) -> None:
    isi = TEMPLATE.read_text(encoding="utf-8")
    for kunci in WAJIB + OPSIONAL:
        isi = isi.replace(f"__{kunci}__", nilai.get(kunci, ""))
    KELUARAN.write_text(isi, encoding="utf-8")
    print(f"Ditulis: {KELUARAN.relative_to(AKAR)}")


def cetak_flags(nilai: dict[str, str]) -> None:
    bagian = " ".join(
        f"--dart-define={k}={v}" for k, v in nilai.items() if v
    )
    print("\nPakai untuk build:\n")
    print(f"flutter build web --release {bagian}")
    print(f"\nflutter build apk --release {bagian}\n")


if __name__ == "__main__":
    konfigurasi = gabung()

    hilang = [k for k in WAJIB if not konfigurasi.get(k)]
    if hilang:
        print("Konfigurasi belum lengkap. Yang kurang: " + ", ".join(hilang))
        if not GOOGLE_SERVICES.exists():
            print(
                "  - taruh android/app/google-services.json untuk nilai dasar, atau"
            )
        print("  - isi .fcm.env (lihat README-PUSH.md).")
        print("\nAndroid tetap bisa jalan hanya dengan google-services.json.")
        print("Web butuh FCM_WEB_APP_ID dan FCM_VAPID_KEY.")
        sys.exit(1)

    tulis_sw(konfigurasi)
    if "--flags" in sys.argv:
        cetak_flags(konfigurasi)
