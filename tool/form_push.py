#!/usr/bin/env python3
"""Form lokal untuk mencoba push web: python3 tool/form_push.py

Browser tidak bisa memanggil FCM langsung karena butuh service account, jadi
skrip ini yang mengirim dan kuncinya tidak pernah sampai ke halaman. Server hanya
mendengar di 127.0.0.1 dan menolak permintaan dari situs lain.
"""
import json
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

try:
    import kirim_push
except ModuleNotFoundError as galat:
    sys.exit(f"Modul {galat.name} belum ada. Jalankan: python3 -m pip install google-auth requests")

PORT = 8787
AKAR = Path(__file__).resolve().parent.parent
HALAMAN = Path(__file__).with_name("form_push.html")
SERVICE_WORKER = AKAR / "web" / "firebase-messaging-sw.js"
HOST_SAH = {f"localhost:{PORT}", f"127.0.0.1:{PORT}"}


def baca_env() -> dict:
    hasil = {}
    for baris in (AKAR / ".fcm.env").read_text().splitlines():
        if "=" in baris and not baris.lstrip().startswith("#"):
            kunci, nilai = baris.split("=", 1)
            hasil[kunci.strip()] = nilai.strip()
    return hasil


def konfigurasi_web(env: dict) -> dict:
    """Hanya nilai web publik; nilai yang sama juga ada di service worker."""
    return {
        "apiKey": env.get("FCM_API_KEY", ""),
        "projectId": env.get("FCM_PROJECT_ID", ""),
        "messagingSenderId": env.get("FCM_SENDER_ID", ""),
        "appId": env.get("FCM_WEB_APP_ID", ""),
        "vapidKey": env.get("FCM_VAPID_KEY", ""),
    }


def periksa_awal(env: dict) -> list:
    """Masalah setelan yang bisa dikenali sebelum mengirim apa pun."""
    masalah = []
    if not SERVICE_WORKER.exists():
        masalah.append("web/firebase-messaging-sw.js belum ada. Jalankan: python3 tool/siapkan_web_push.py")
    try:
        with open(kirim_push.KEY) as berkas:
            project = json.load(berkas).get("project_id")
    except OSError:
        masalah.append(f"Service account tidak ditemukan: {kirim_push.KEY}")
    except ValueError:
        masalah.append(f"Service account bukan JSON yang valid: {kirim_push.KEY}")
    else:
        if project != env.get("FCM_PROJECT_ID"):
            masalah.append(
                f"Project service account ({project}) berbeda dengan .fcm.env "
                f"({env.get('FCM_PROJECT_ID')})."
            )
    return masalah


class Penangan(BaseHTTPRequestHandler):
    def _balas(self, kode, isi, jenis="application/json; charset=utf-8"):
        if not isinstance(isi, bytes):
            isi = json.dumps(isi).encode()
        self.send_response(kode)
        self.send_header("Content-Type", jenis)
        self.send_header("Content-Length", str(len(isi)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(isi)

    def _host_sah(self):
        return self.headers.get("Host") in HOST_SAH

    def do_GET(self):
        if not self._host_sah():
            return self._balas(403, {"galat": "Host tidak diizinkan"})
        jalur = self.path.split("?")[0]
        if jalur == "/":
            return self._balas(200, HALAMAN.read_bytes(), "text/html; charset=utf-8")
        if jalur == "/firebase-messaging-sw.js" and SERVICE_WORKER.exists():
            return self._balas(200, SERVICE_WORKER.read_bytes(), "text/javascript; charset=utf-8")
        if jalur == "/konfigurasi":
            env = baca_env()
            return self._balas(200, {"web": konfigurasi_web(env), "masalah": periksa_awal(env)})
        return self._balas(404, {"galat": "Tidak ditemukan"})

    def do_POST(self):
        asal_sah = {f"http://{host}" for host in HOST_SAH}
        if (
            not self._host_sah()
            or self.headers.get("Origin") not in asal_sah
            or not self.headers.get("Content-Type", "").startswith("application/json")
        ):
            return self._balas(403, {"galat": "Permintaan hanya boleh dari form ini"})
        if self.path != "/kirim":
            return self._balas(404, {"galat": "Tidak ditemukan"})
        try:
            data = json.loads(self.rfile.read(min(int(self.headers.get("Content-Length", 0)), 65536)))
            target = str(data["target"]).strip()
            judul = str(data.get("judul") or "Tes push SMART")
            isi = str(data.get("isi") or "")
            jenis = "data" if data.get("jenis") == "data" else "notification"
        except (ValueError, KeyError, TypeError):
            return self._balas(400, {"galat": "Isian tidak valid"})
        if not target:
            return self._balas(400, {"galat": "ID perangkat masih kosong"})
        try:
            resp = kirim_push.kirim(target, judul, isi, jenis)
        except Exception as galat:  # Ditampilkan apa adanya di form supaya mudah dilacak.
            return self._balas(502, {"galat": f"{type(galat).__name__}: {galat}"})
        return self._balas(
            200,
            {
                "http": resp.status_code,
                "target": kirim_push.jenis_target(target),
                "respons": resp.text[:1200],
                "petunjuk": kirim_push.petunjuk(resp.status_code, resp.text),
            },
        )

    def log_message(self, *_):
        pass


def main():
    for masalah in periksa_awal(baca_env()):
        print("PERINGATAN:", masalah)
    print(f"Buka http://localhost:{PORT}  (Ctrl+C untuk berhenti)")
    ThreadingHTTPServer(("127.0.0.1", PORT), Penangan).serve_forever()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
