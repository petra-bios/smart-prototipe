import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';

class PromoCardsSection extends StatelessWidget {
  final VoidCallback onCheckLimitTap;
  final VoidCallback onCreateContractTap;

  const PromoCardsSection({
    super.key,
    required this.onCheckLimitTap,
    required this.onCreateContractTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Card: Cek Limit
        Expanded(
          child: _buildPromoCard(
            context: context,
            title: DummyData.promo1Text,
            buttonText: DummyData.promo1Button,
            icon: Icons.speed_rounded,
            onTap: onCheckLimitTap,
          ),
        ),
        const SizedBox(width: 12),
        // Right Card: Buat Kontrak
        Expanded(
          child: _buildPromoCard(
            context: context,
            title: DummyData.promo2Text,
            buttonText: DummyData.promo2Button,
            icon: Icons.assignment_turned_in_outlined,
            onTap: onCreateContractTap,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard({
    required BuildContext context,
    required String title,
    required String buttonText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryRed,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
