import 'package:flutter/material.dart';
import '../app_colors.dart';

class DummyPushService {
  static final DummyPushService _instance = DummyPushService._internal();
  factory DummyPushService() => _instance;
  DummyPushService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    _initialized = true;
    debugPrint('[DummyPushService] Initialized push notification dummy service');
  }

  Future<void> showNotification({
    required String title,
    required String body,
    BuildContext? context,
  }) async {
    debugPrint('[DummyPushService] Notification dispatched: "$title" - "$body"');

    if (context != null && context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
          backgroundColor: AppColors.darkPill,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.primaryRed, width: 1.5),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
