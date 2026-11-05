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
  const judul = payload.notification?.title || 'SMART';
  const opsi = {
    body: payload.notification?.body || '',
    icon: '/icons/Icon-192.png',
  };
  self.registration.showNotification(judul, opsi);
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(clients.openWindow('/'));
});
