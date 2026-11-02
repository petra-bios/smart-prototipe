import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isStandalone;

  const ProfileScreen({super.key, this.isStandalone = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: isStandalone,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryRed.withValues(alpha: 0.1),
                  child: const Text(
                    'B',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        DummyData.defaultUsername,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mitra Penjualan (ID: MTR-99210)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'POS: Mall Grand Indonesia',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Menu Items Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                // Buka Google (In-app WebView)
                _buildMenuItem(
                  icon: Icons.language,
                  iconColor: AppColors.linkBlue,
                  title: 'Buka Google',
                  subtitle: 'Tampilkan halaman Google in-app webview',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoogleWebViewScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56, color: AppColors.divider),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  iconColor: AppColors.textPrimary,
                  title: 'Pengaturan Akun',
                  subtitle: 'Ubah sandi dan data pribadi',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengaturan Akun (dummy)'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56, color: AppColors.divider),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  iconColor: AppColors.textPrimary,
                  title: 'Bantuan & FAQ',
                  subtitle: 'Panduan penggunaan aplikasi SMART',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bantuan & FAQ (dummy)'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56, color: AppColors.divider),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  iconColor: AppColors.textPrimary,
                  title: 'Tentang Aplikasi',
                  subtitle: 'SMART.DEV Versi 5.7.0 prototipe',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('SMART.DEV v5.7.0 prototipe'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Keluar button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.primaryRed, size: 20),
              label: const Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
      onTap: onTap,
    );
  }
}

class GoogleWebViewScreen extends StatefulWidget {
  const GoogleWebViewScreen({super.key});

  @override
  State<GoogleWebViewScreen> createState() => _GoogleWebViewScreenState();
}

class _GoogleWebViewScreenState extends State<GoogleWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) setState(() => _isLoading = true);
            },
            onPageFinished: (String url) {
              if (mounted) setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse('https://www.google.com'));
    } catch (_) {
      // In non-mobile testing environments (e.g. desktop widget test), WebViewController might throw
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Google',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null)
            WebViewWidget(controller: _controller!)
          else
            const Center(
              child: Text(
                'https://www.google.com',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
              ),
            ),
        ],
      ),
    );
  }
}
