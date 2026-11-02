import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/contract_bottom_sheet.dart';
import 'new_application_screen.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onShowBottomSheet() {
    ContractBottomSheet.show(
      context: context,
      onScanQrTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scanner dummy'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      onSimulationTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NewApplicationScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(115),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header with back button and search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryRed,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari No. Aplikasi atau Kontr...',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textLight,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppColors.backgroundLight,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.cardBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.cardBorder),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab bar: "Aplikasi Pengajuan" & "Instruksi Penyerahan"
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryRed,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primaryRed,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'Aplikasi Pengajuan'),
                    Tab(text: 'Instruksi Penyerahan'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Aplikasi Pengajuan (Empty state)
                _buildEmptyState(
                  icon: Icons.assignment_outlined,
                  message: 'Tidak ada aplikasi yang tersedia',
                ),
                // Tab 2: Instruksi Penyerahan (Empty state)
                _buildEmptyState(
                  icon: Icons.local_shipping_outlined,
                  message: 'Tidak ada instruksi penyerahan',
                ),
              ],
            ),
          ),
          // Tombol merah memanjang bawah "Buat Aplikasi Pengajuan Baru"
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onShowBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Buat Aplikasi Pengajuan Baru',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.primaryRed.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
