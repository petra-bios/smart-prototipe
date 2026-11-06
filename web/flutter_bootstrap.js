{{flutter_js}}
{{flutter_build_config}}

// Sengaja TANPA serviceWorkerSettings. Service worker bawaan Flutter sudah
// deprecated dan isinya membatalkan registrasinya sendiri; kalau dimuat, ia
// menimpa firebase-messaging-sw.js (scope sama "/") lalu mencabut langganan push.
_flutter.loader.load();
