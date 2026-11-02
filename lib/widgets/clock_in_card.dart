import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';

class ClockInCard extends StatelessWidget {
  final VoidCallback? onClockInTap;

  const ClockInCard({super.key, this.onClockInTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          DummyData.clockInTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
          child: Row(
            children: [
              // Composite icon illustration
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.storefront_outlined,
                      size: 32,
                      color: AppColors.primaryRed,
                    ),
                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DummyData.clockInDistance,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onClockInTap ??
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Berhasil Clock-In (dummy)'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          DummyData.clockInButton,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
