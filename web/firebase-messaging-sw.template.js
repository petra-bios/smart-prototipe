// Service worker FCM untuk build web.
// Berkas ini DIGENERASI oleh tool/siapkan_web_push.py dari .fcm.env —
// jangan diisi manual, dan jangan commit nilai rahasia ke repo publik.
// Versi harus sama dengan SDK yang dimuat firebase_core_web (lihat pubspec.lock).
importScripts('https://www.gstatic.com/firebasejs/13.1.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/13.1.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: '__FCM_API_KEY__',
  projectId: '__FCM_PROJECT_ID__',
  messagingSenderId: '__FCM_SENDER_ID__',
  appId: '__FCM_WEB_APP_ID__',
});

const messaging = firebase.messaging();

// Versi baru langsung dipakai tanpa menunggu semua tab ditutup.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil(clients.claim()));

// SDK Firebase hanya menampilkan notifikasi kalau semua tab tersembunyi. Tab yang
// masih terlihat tapi tidak fokus (mis. app lain di depan) harus ditangani di sini.
self.addEventListener('push', (event) => {
  event.waitUntil((async () => {
    const tab = await clients.matchAll({ type: 'window', includeUncontrolled: true });
    const terlihat = tab.some((t) => t.visibilityState === 'visible');
    const fokus = tab.some((t) => t.focused);
    if (!terlihat || fokus) return;

    let pesan;
    try {
      pesan = event.data.json();
    } catch (_) {
      return;
    }
    const judul = pesan.notification?.title || pesan.data?.judul;
    if (!judul) return;
    await self.registration.showNotification(judul, {
      body: pesan.notification?.body || pesan.data?.isi || '',
      icon: '/icons/Icon-192.png',
    });
  })());
});

messaging.onBackgroundMessage((payload) => {
  // Pesan bertipe "notification" SUDAH ditampilkan otomatis oleh SDK. Kalau
  // kita panggil showNotification lagi, user menerima notifikasi ganda —
  // jadi handler ini hanya untuk pesan "data-only".
  if (payload.notification?.title || payload.notification?.body) return;

  const judul = payload.data?.judul || 'SMART';
  self.registration.showNotification(judul, {
    body: payload.data?.isi || '',
    icon: '/icons/Icon-192.png',
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil((async () => {
    const tab = await clients.matchAll({ type: 'window', includeUncontrolled: true });
    return tab[0] ? tab[0].focus() : clients.openWindow('/');
  })());
});
