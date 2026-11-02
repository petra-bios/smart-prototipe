import 'package:dio/dio.dart';
import '../data/dummy_data.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? customDio})
      : dio = customDio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5),
              ),
            );

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'username': username.isEmpty ? DummyData.defaultUsername : username,
      'token': 'dummy_mock_jwt_token_12345',
    };
  }

  Future<List<InboxItem>> getInboxItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.inboxItems;
  }

  Future<List<String>> getPosList() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.posList;
  }

  Future<List<String>> getItemCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.itemCategories;
  }

  Future<Map<String, dynamic>> submitApplication({
    required String posName,
    required String category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'applicationId': 'APP-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'SUBMITTED',
      'pos': posName,
      'category': category,
    };
  }
}
