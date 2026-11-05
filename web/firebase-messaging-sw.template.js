// Service worker FCM untuk build web.
// Berkas ini DIGENERASI oleh tool/siapkan_web_push.py dari .fcm.env —
// jangan diisi manual, dan jangan commit nilai rahasia ke repo publik.
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: '__FCM_API_KEY__',
  projectId: '__FCM_PROJECT_ID__',
  messagingSenderId: '__FCM_SENDER_ID__',
  appId: '__FCM_WEB_APP_ID__',
});

const messaging = firebase.messaging();

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
  event.waitUntil(clients.openWindow('/'));
});
