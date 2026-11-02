import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';
import '../services/api_service.dart';

class NewApplicationScreen extends StatefulWidget {
  const NewApplicationScreen({super.key});

  @override
  State<NewApplicationScreen> createState() => _NewApplicationScreenState();
}

class _NewApplicationScreenState extends State<NewApplicationScreen> {
  final ApiService _apiService = ApiService();
  String? _selectedPos = DummyData.posList.first;
  String? _selectedCategory = DummyData.itemCategories.first;
  final TextEditingController _priceController =
      TextEditingController(text: '15.000.000');
  String _selectedTenor = '12 Bulan';
  bool _isLoading = false;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.submitApplication(
        posName: _selectedPos ?? '',
        category: _selectedCategory ?? '',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Simulasi pengajuan berhasil dibuat (dummy)'),
          duration: Duration(seconds: 2),
        ),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat pengajuan dummy')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Pengajuan Baru - Simulasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section "Informasi pengajuan"
                    const Text(
                      'Informasi pengajuan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Form Card
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown "Nama POS"
                          const Text(
                            'Nama POS',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedPos,
                                isExpanded: true,
                                hint: const Text('Pilih Nama POS'),
                                items: DummyData.posList
                                    .map(
                                      (pos) => DropdownMenuItem(
                                        value: pos,
                                        child: Text(
                                          pos,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedPos = val);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Dropdown "Kategori Barang"
                          const Text(
                            'Kategori Barang',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                hint: const Text('Pilih Kategori Barang'),
                                items: DummyData.itemCategories
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(
                                          cat,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCategory = val);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Price estimate
                          const Text(
                            'Estimasi Harga Barang (Rp)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: 'Rp ',
                              prefixStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              filled: true,
                              fillColor: AppColors.backgroundLight,
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
                          const SizedBox(height: 18),
                          // Tenor selection
                          const Text(
                            'Pilihan Tenor Cicilan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ['6 Bulan', '12 Bulan', '18 Bulan', '24 Bulan']
                                .map((tenor) {
                              final isSelected = _selectedTenor == tenor;
                              return ChoiceChip(
                                label: Text(tenor),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedTenor = tenor);
                                  }
                                },
                                selectedColor: AppColors.primaryRed,
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                                backgroundColor: AppColors.backgroundLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primaryRed
                                        : AppColors.cardBorder,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Action Container with "Lanjut" pill button
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
                  onPressed: _isLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Lanjut',
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
      ),
    );
  }
}
