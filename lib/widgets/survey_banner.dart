import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';

class SurveyBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const SurveyBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Membuka survey (dummy)'),
                duration: Duration(seconds: 2),
              ),
            );
          },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surveyBannerBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surveyBannerBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surveyBannerBorder),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: AppColors.surveyBannerText,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    DummyData.surveyTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.surveyBannerText,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DummyData.surveyDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.surveyBannerText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
