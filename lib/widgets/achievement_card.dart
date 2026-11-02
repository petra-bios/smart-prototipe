import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';

class AchievementCard extends StatelessWidget {
  final VoidCallback? onRewardTap;

  const AchievementCard({super.key, this.onRewardTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  DummyData.achievementTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onRewardTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Membuka detail hadiah (dummy)'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                child: const Text(
                  DummyData.achievementLink,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.linkBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            DummyData.achievementSubtext,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: DummyData.achievementProgress,
              minHeight: 8,
              backgroundColor: Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '0%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Target: Rp100.000.000',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(
                Icons.stars_rounded,
                size: 16,
                color: Color(0xFFFFB300),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  DummyData.achievementBonus,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
