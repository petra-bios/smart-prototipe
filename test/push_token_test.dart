import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_prototipe/services/push_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('token tersimpan dipulihkan saat aplikasi dibuka lagi', () async {
    SharedPreferences.setMockInitialValues({
      'fcm_token': 'token-lama-123',
      'fcm_token_waktu': 1700000000000,
    });

    PushService.instance.setelUlang();
    await PushService.instance.pulihkanToken();

    expect(PushService.instance.token, 'token-lama-123');
    expect(PushService.instance.waktuToken, isNotNull);
  });

  test('tanpa token tersimpan, token tetap kosong (bukan string palsu)',
      () async {
    SharedPreferences.setMockInitialValues({});

    PushService.instance.setelUlang();
    await PushService.instance.pulihkanToken();

    expect(PushService.instance.token, isNull);
    expect(PushService.instance.waktuToken, isNull);
  });

  test('bootstrap web tidak memuat service worker Flutter', () {
    final isi = File('web/flutter_bootstrap.js').readAsStringSync();
    expect(isi, isNot(contains('serviceWorkerSettings:')));
    expect(isi, contains('_flutter.loader.load()'));
  });
}
