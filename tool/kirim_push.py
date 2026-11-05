#!/usr/bin/env python3
"""Kirim satu pesan FCM ke SATU token saja (tanpa topik, tanpa broadcast).

Dipakai untuk membuktikan push web benar-benar sampai. Hanya menargetkan
`token` yang diberikan; tidak menyentuh perangkat/topik lain.
"""
import json
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


def main() -> int:
    device = sys.argv[1]
    title = sys.argv[2] if len(sys.argv) > 2 else "Tes push SMART"
    body = (
        sys.argv[3]
        if len(sys.argv) > 3
        else "Kalau notifikasi ini muncul, push web sudah jalan."
    )
    project = json.load(open(KEY))["project_id"]
    url = f"https://fcm.googleapis.com/v1/projects/{project}/messages:send"
    payload = {
        "message": {
            "token": device,
            "notification": {"title": title, "body": body},
            "data": {"sumber": "uji-manual", "aplikasi": "SMART"},
            "webpush": {
                "headers": {"Urgency": "high"},
                "notification": {"title": title, "body": body, "requireInteraction": True},
            },
            "android": {"priority": "HIGH"},
        }
    }
    resp = requests.post(
        url,
        headers={
            "Authorization": f"Bearer {access_token()}",
            "Content-Type": "application/json",
        },
        json=payload,
        timeout=30,
    )
    print("HTTP", resp.status_code)
    print(resp.text[:1200])
    return 0 if resp.status_code == 200 else 1


if __name__ == "__main__":
    raise SystemExit(main())
