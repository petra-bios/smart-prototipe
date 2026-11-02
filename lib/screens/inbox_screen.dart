import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../data/dummy_data.dart';

class InboxScreen extends StatefulWidget {
  final bool isStandalone;

  const InboxScreen({super.key, this.isStandalone = false});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';
  List<InboxItem> _filteredItems = DummyData.inboxItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(DummyData.inboxItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredItems = DummyData.inboxItems.where((item) {
        final matchesQuery = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query) ||
            item.tag.toLowerCase().contains(query);

        final matchesCategory = _selectedCategory == 'Semua Kategori' ||
            item.tag.toLowerCase() == _selectedCategory.toLowerCase();

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _resetFilter() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'Semua Kategori';
      _filteredItems = List.from(DummyData.inboxItems);
    });
  }

  Color _getTagBgColor(String tag) {
    switch (tag) {
      case 'SUSPEND':
        return AppColors.tagSuspendBg;
      case 'BUSINESS PERFORMANCE':
        return AppColors.tagPerformanceBg;
      case 'Sistem SMART':
        return AppColors.tagSystemBg;
      default:
        return const Color(0xFFF0F0F0);
    }
  }

  Color _getTagTextColor(String tag) {
    switch (tag) {
      case 'SUSPEND':
        return AppColors.tagSuspendText;
      case 'BUSINESS PERFORMANCE':
        return AppColors.tagPerformanceText;
      case 'Sistem SMART':
        return AppColors.tagSystemText;
      default:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: widget.isStandalone,
        title: const Text(
          'Inbox',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // Search bar "Cari"
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilter(),
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilter();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Dropdown "Pilih kategori" + tombol "RESET"
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            hint: const Text('Pilih kategori'),
                            items: DummyData.inboxCategories
                                .map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(
                                        cat,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCategory = val;
                                });
                                _applyFilter();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _resetFilter,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                        side: const BorderSide(color: AppColors.primaryRed),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'RESET',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Inbox list
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada pesan',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _buildInboxCard(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxCard(BuildContext context, InboxItem item) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesan: ${item.title}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Generic avatar icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.primaryRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            item.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tag Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getTagBgColor(item.tag),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.tag,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _getTagTextColor(item.tag),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
