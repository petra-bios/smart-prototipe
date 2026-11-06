#!/usr/bin/env python3
"""Kirim satu pesan FCM ke SATU target saja (tanpa topik, tanpa broadcast).

Target bisa berupa FID (firebase_messaging 17 / JS SDK register()) atau token
pendaftaran lama. Dipakai untuk membuktikan push web benar-benar sampai.
Tidak menyentuh perangkat/topik lain. tool/form_push.py memakai fungsi yang sama.
"""
import json
import re
import sys

import google.auth.transport.requests
import requests
from google.oauth2 import service_account

KEY = "/Users/mozespetrabios/.petrabios-keys/firebase-smart.json"
SCOPE = ["https://www.googleapis.com/auth/firebase.messaging"]


def access_token() -> str:
    creds = service_account.Credentials.from_service_account_file(KEY, scopes=SCOPE)
    creds.refresh(google.auth.transport.requests.Request())
    return creds.token


def jenis_target(nilai: str) -> str:
    # FID selalu 22 karakter dan diawali c/d/e/f (format Firebase Installations).
    return "fid" if re.fullmatch(r"[cdef][\w-]{21}", nilai) else "token"


def buat_pesan(target: str, judul: str, isi: str, jenis: str = "notification") -> dict:
    """jenis "notification" ditampilkan SDK; "data" ditampilkan handler service worker."""
    pesan = {
        jenis_target(target): target,
        "data": {"sumber": "uji-manual", "aplikasi": "SMART"},
        "webpush": {"headers": {"Urgency": "high"}},
        "android": {"priority": "HIGH"},
    }
    if jenis == "data":
        pesan["data"].update({"judul": judul, "isi": isi})
    else:
        pesan["notification"] = {"title": judul, "body": isi}
        pesan["webpush"]["notification"] = {
            "title": judul,
            "body": isi,
            "requireInteraction": True,
        }
    return pesan


def kirim(target: str, judul: str, isi: str, jenis: str = "notification") -> requests.Response:
    with open(KEY) as berkas:
        project = json.load(berkas)["project_id"]
    return requests.post(
        f"https://fcm.googleapis.com/v1/projects/{project}/messages:send",
        headers={
            "Authorization": f"Bearer {access_token()}",
            "Content-Type": "application/json",
        },
        json={"message": buat_pesan(target, judul, isi, jenis)},
        timeout=30,
    )


def petunjuk(kode: int, teks: str) -> list[str]:
    """Arti respons FCM dalam bahasa sehari-hari."""
    hasil = []
    if kode == 200:
        hasil.append(
            "FCM menerima pesan. Kalau notifikasi tidak muncul, masalahnya ada di "
            "browser/perangkat, bukan di pengiriman."
        )
    if kode == 404 or "UNREGISTERED" in teks:
        hasil.append(
            "ID ini sudah tidak terdaftar. Buka aplikasinya, lalu salin ID terbaru dari "
            "menu Notifikasi."
        )
    if "SENDER_ID_MISMATCH" in teks:
        hasil.append("Service account berasal dari project Firebase yang berbeda dengan aplikasinya.")
    if kode in (401, 403):
        hasil.append(
            "Akses ditolak. Periksa izin service account dan pastikan Firebase Cloud "
            "Messaging API aktif di project ini."
        )
    if kode == 400:
        hasil.append("FCM menolak isi pesan atau format ID. Periksa ID yang ditempel.")
    return hasil


def main() -> int:
    if len(sys.argv) < 2:
        print("Pakai: python3 tool/kirim_push.py <FID-atau-token> [judul] [isi]")
        return 2
    target = sys.argv[1]
    judul = sys.argv[2] if len(sys.argv) > 2 else "Tes push SMART"
    isi = (
        sys.argv[3]
        if len(sys.argv) > 3
        else "Kalau notifikasi ini muncul, push web sudah jalan."
    )
    print(f"Target: {jenis_target(target)}")
    resp = kirim(target, judul, isi)
    print("HTTP", resp.status_code)
    print(resp.text[:1200])
    for baris in petunjuk(resp.status_code, resp.text):
        print(baris)
    return 0 if resp.status_code == 200 else 1


if __name__ == "__main__":
    raise SystemExit(main())
