import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';
import '../services/dummy_push_service.dart';
import '../widgets/achievement_card.dart';
import '../widgets/clock_in_card.dart';
import '../widgets/promo_cards_section.dart';
import '../widgets/survey_banner.dart';
import 'application_screen.dart';
import 'inbox_screen.dart';
import 'product_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  final DummyPushService _pushService = DummyPushService();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pushService.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pushService.showNotification(
        title: 'Survey menunggu kamu',
        body: 'Yuk isi Survey untuk meningkatkan kualitas layanan!',
        context: context,
      );
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openApplicationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ApplicationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBerandaTab(),
          const InboxScreen(),
          const ProductScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined),
              activeIcon: Icon(Icons.inbox),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBerandaTab() {
    return SafeArea(
      child: Column(
        children: [
          // Header putih
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo SMART.DEV merah
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'SMART',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryRed,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '.DEV',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // Pill abu-abu gelap kanan: Clock-In 11:00 | Clock-Out 20:00
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.darkPill,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Clock-In 11:00',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 1,
                          color: Colors.white38,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        const Text(
                          'Clock-Out 20:00',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sapaan "Hi, Becky"
                  const Text(
                    DummyData.greeting,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Banner biru muda "Yuk isi Survey!"
                  const SurveyBanner(),
                  const SizedBox(height: 16),
                  // Kartu putih "Pencapaianmu Bulan Ini"
                  const AchievementCard(),
                  const SizedBox(height: 20),
                  // Section "Clock-In"
                  const ClockInCard(),
                  const SizedBox(height: 20),
                  // Dua kartu promosi merah bersebelahan
                  PromoCardsSection(
                    onCheckLimitTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cek Limit Calon Pelanggan (dummy)'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    // ONLY entrypoint to ApplicationScreen is "Buat Kontrak"
                    onCreateContractTap: _openApplicationScreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
