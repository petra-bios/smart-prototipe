import 'package:flutter/material.dart';
import '../app_colors.dart';

class ContractBottomSheet extends StatelessWidget {
  final VoidCallback onScanQrTap;
  final VoidCallback onSimulationTap;

  const ContractBottomSheet({
    super.key,
    required this.onScanQrTap,
    required this.onSimulationTap,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onScanQrTap,
    required VoidCallback onSimulationTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ContractBottomSheet(
        onScanQrTap: onScanQrTap,
        onSimulationTap: onSimulationTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag indicator handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Header with title and close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Buat Pengajuan Kontrak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih metode yang diinginkan pelanggan untuk lanjutkan proses pengajuan.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            // Option 1: Scan Kode QR
            _buildOptionTile(
              context: context,
              icon: Icons.qr_code_scanner,
              title: 'Scan Kode QR',
              subtitle: 'Pindai QR code pelanggan untuk memproses aplikasi',
              onTap: () {
                Navigator.pop(context);
                onScanQrTap();
              },
            ),
            const SizedBox(height: 12),
            // Option 2: Simulasi Cicilan
            _buildOptionTile(
              context: context,
              icon: Icons.calculate_outlined,
              title: 'Simulasi Cicilan',
              subtitle: 'Hitung estimasi angsuran dan ajukan aplikasi',
              onTap: () {
                Navigator.pop(context);
                onSimulationTap();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
