class InboxItem {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final String date;
  final bool isRead;

  const InboxItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.date,
    this.isRead = false,
  });
}

class ProductItem {
  final String id;
  final String name;
  final String category;
  final String tenor;
  final String interest;
  final String minDownPayment;

  const ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.tenor,
    required this.interest,
    required this.minDownPayment,
  });
}

class DummyData {
  static const String defaultUsername = 'becky';
  static const String greeting = 'Hi, Becky';
  static const String clockInOutPill = 'Clock-In 11:00 | Clock-Out 20:00';

  // Survey
  static const String surveyTitle = 'Yuk isi Survey!';
  static const String surveyDescription =
      'Bantu kami meningkatkan kualitas layanan dengan mengisi survey singkat ini.';

  // Achievement
  static const String achievementTitle = 'Pencapaianmu Bulan Ini';
  static const String achievementSubtext =
      'Volume Rp0 / Rp100.000.000 untuk Naik Level';
  static const double achievementProgress = 0.0;
  static const String achievementBonus =
      'Dapatkan bonus menarik setelah mencapai target bulananmu!';
  static const String achievementLink = 'Lihat Hadiah';

  // Clock-in
  static const String clockInTitle = 'Clock-In';
  static const String clockInDistance =
      'Kamu bisa clock-in sejauh 150 m dari POSmu';
  static const String clockInButton = 'Clock-In';

  // Promo cards
  static const String promo1Text =
      'Ayo, ajak calon pelanggan cek limit pembiayaan mereka!';
  static const String promo1Button = 'Cek Limit';

  static const String promo2Text =
      'Ada calon pelanggan yang tertarik? Yuk, bantu ajukan pembiayaan!';
  static const String promo2Button = 'Buat Kontrak';

  // Bottom nav labels
  static const List<String> bottomNavLabels = [
    'Beranda',
    'Inbox',
    'Produk',
    'Profil',
  ];

  // Inbox categories
  static const List<String> inboxCategories = [
    'Semua Kategori',
    'SUSPEND',
    'BUSINESS PERFORMANCE',
    'Sistem SMART',
  ];

  // Inbox items (7 items)
  static const List<InboxItem> inboxItems = [
    InboxItem(
      id: '1',
      title: 'Test Reactivation',
      subtitle: 'Akun anda memerlukan reaktivasi segera',
      tag: 'SUSPEND',
      date: '07 Oct',
    ),
    InboxItem(
      id: '2',
      title: 'ewfewgreghtrj',
      subtitle: 'Update performa mingguan mitra penjualan',
      tag: 'BUSINESS PERFORMANCE',
      date: '05 Oct',
    ),
    InboxItem(
      id: '3',
      title: 'koknklnbj',
      subtitle: 'Pemberitahuan pemeliharaan sistem berkala SMART',
      tag: 'Sistem SMART',
      date: '02 Oct',
    ),
    InboxItem(
      id: '4',
      title: 'Target Q4 Telah Dibuka',
      subtitle: 'Cek pencapaian dan target bonus kuartal ini',
      tag: 'BUSINESS PERFORMANCE',
      date: '28 Sep',
    ),
    InboxItem(
      id: '5',
      title: 'Verifikasi Data POS',
      subtitle: 'Mohon lengkapi verifikasi lokasi dan jam operasional POS',
      tag: 'Sistem SMART',
      date: '25 Sep',
    ),
    InboxItem(
      id: '6',
      title: 'Pemberitahuan Akun Ditangguhkan',
      subtitle: 'Peringatan batas aktivitas penjualan mitra',
      tag: 'SUSPEND',
      date: '20 Sep',
    ),
    InboxItem(
      id: '7',
      title: 'Fitur Baru Pengajuan Kontrak',
      subtitle: 'Pengajuan kontrak kini lebih praktis dan instan',
      tag: 'Sistem SMART',
      date: '15 Sep',
    ),
  ];

  // Products
  static const List<ProductItem> products = [
    ProductItem(
      id: 'p1',
      name: 'Pembiayaan Smartphone & Gadget',
      category: 'Gadget',
      tenor: '3, 6, 9, 12 Bulan',
      interest: 'Mulai dari 1.99%/bln',
      minDownPayment: 'DP mulai 0%',
    ),
    ProductItem(
      id: 'p2',
      name: 'Pembiayaan Elektronik Rumah',
      category: 'Elektronik',
      tenor: '6, 12, 18, 24 Bulan',
      interest: 'Mulai dari 1.85%/bln',
      minDownPayment: 'DP mulai 10%',
    ),
    ProductItem(
      id: 'p3',
      name: 'Pembiayaan Furnitur & Living',
      category: 'Furnitur',
      tenor: '6, 12, 18 Bulan',
      interest: 'Mulai dari 2.10%/bln',
      minDownPayment: 'DP mulai 0%',
    ),
    ProductItem(
      id: 'p4',
      name: 'Pembiayaan Multiguna Mitra',
      category: 'Multiguna',
      tenor: '12, 24, 36 Bulan',
      interest: 'Mulai dari 1.50%/bln',
      minDownPayment: 'Bebas DP',
    ),
  ];

  // POS dropdown
  static const List<String> posList = [
    'POS Jakarta Pusat - Mall Grand Indonesia',
    'POS Jakarta Selatan - Pondok Indah Mall',
    'POS Jakarta Barat - Central Park',
    'POS Surabaya - Tunjungan Plaza',
    'POS Bandung - Paris Van Java',
  ];

  // Kategori Barang dropdown
  static const List<String> itemCategories = [
    'Smartphone',
    'Laptop & Komputer',
    'Elektronik Rumah Tangga',
    'Furnitur',
    'Sepeda Motor',
  ];
}
