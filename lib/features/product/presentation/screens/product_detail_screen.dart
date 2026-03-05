import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared ProductData model (also imported by home_screen)
// ─────────────────────────────────────────────────────────────────────────────
class ProductData {
  final String name;
  final String price;
  final String originalPrice;
  final double rating;
  final int sold;
  final IconData icon;
  final Color color;

  const ProductData({
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.sold,
    required this.icon,
    required this.color,
  });

  int get discount {
    final p = double.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    final o =
        double.tryParse(originalPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    return ((1 - p / o) * 100).round();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Product Detail Screen
// ─────────────────────────────────────────────────────────────────────────────
class ProductDetailScreen extends StatefulWidget {
  final ProductData product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _isFav = false;
  int _qty = 1;
  int _selectedVariant = 0;
  int _selectedColor = 0;
  int _selectedTab = 0;

  final List<String> _variants = ['Standard', 'Pro', 'Pro Max'];
  final List<Color> _colorOptions = [
    const Color(0xFF1565C0),
    const Color(0xFF212121),
    const Color(0xFFE53935),
    const Color(0xFF2E7D32),
  ];

  final List<_Review> _reviews = [
    _Review(
      id: '1',
      name: 'Budi S.',
      stars: 5,
      text:
          'Produk sangat bagus, sesuai ekspektasi! Pengiriman cepat dan aman. Seller responsif banget. Recommended!',
      date: '2 hari lalu',
      helpful: 24,
      verified: true,
      tags: ['Kualitas', 'Pengiriman Cepat'],
    ),
    _Review(
      id: '2',
      name: 'Ani R.',
      stars: 4,
      text:
          'Kualitas oke, tapi box pengiriman sedikit penyok. Produknya sendiri mulus, tidak ada cacat. Puas overall.',
      date: '5 hari lalu',
      helpful: 11,
      verified: true,
      tags: ['Kualitas'],
    ),
    _Review(
      id: '3',
      name: 'Citra D.',
      stars: 5,
      text:
          'Recommended banget! Udah order 2x dan selalu puas. Sesuai deskripsi, harga terjangkau.',
      date: '1 minggu lalu',
      helpful: 8,
      verified: false,
      tags: ['Nilai Harga'],
    ),
    _Review(
      id: '4',
      name: 'Dodi P.',
      stars: 3,
      text:
          'Produknya lumayan, tapi ada sedikit kecacatan di bagian sudut. Seller sudah merespons untuk proses klaim.',
      date: '2 minggu lalu',
      helpful: 5,
      verified: true,
      tags: ['Kualitas'],
    ),
    _Review(
      id: '5',
      name: 'Eka W.',
      stars: 5,
      text:
          'Mantap banget! Persis seperti foto, kualitas premium. Kemasan sangat rapi dan aman.',
      date: '3 minggu lalu',
      helpful: 19,
      verified: true,
      tags: ['Kemasan', 'Kualitas'],
    ),
  ];

  int _reviewFilter = 0; // 0 = semua, 1-5 = star filter
  final Set<String> _helpedReviews = {}; // ids that user marked as helpful

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ─── build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHero()),
                      SliverToBoxAdapter(child: _buildTitleSection()),
                      SliverToBoxAdapter(child: _buildVariants()),
                      SliverToBoxAdapter(child: _buildColorPicker()),
                      SliverToBoxAdapter(child: _buildQtyRow()),
                      SliverToBoxAdapter(child: _buildInfoTabs()),
                      SliverToBoxAdapter(child: _buildSellerCard()),
                      SliverToBoxAdapter(child: _buildRelatedSection()),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── IMAGE HERO ──────────────────────────────────────────────────────────
  Widget _buildHero() {
    final p = widget.product;
    return Container(
      height: 320,
      color: Colors.white,
      child: Stack(
        children: [
          // Tinted gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [p.color.withOpacity(0.09), Colors.white],
                ),
              ),
            ),
          ),

          // Decorative circle
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.color.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.color.withOpacity(0.04),
              ),
            ),
          ),

          // Product icon (Hero widget for transition)
          Center(
            child: Hero(
              tag: 'product_icon_${p.name}',
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: p.color.withOpacity(0.10),
                ),
                child: Icon(p.icon, size: 88, color: p.color.withOpacity(0.80)),
              ),
            ),
          ),

          // Discount badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 58,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'HEMAT ${p.discount}%',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Top action bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _circleBtn(
                    Icons.arrow_back_ios_new_rounded,
                    () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  _circleBtn(Icons.share_outlined, () {}),
                  const SizedBox(width: 8),
                  _circleBtn(
                    _isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    () => setState(() => _isFav = !_isFav),
                    iconColor: _isFav
                        ? Colors.red.shade400
                        : AppColors.charcoal,
                  ),
                ],
              ),
            ),
          ),

          // Thumbnail strip
          Positioned(
            right: 12,
            bottom: 16,
            child: Column(
              children: List.generate(3, (i) {
                return GestureDetector(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: i == 0
                          ? p.color.withOpacity(0.15)
                          : Colors.grey.shade100,
                      border: Border.all(
                        color: i == 0 ? p.color : Colors.grey.shade300,
                        width: i == 0 ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      p.icon,
                      size: 22,
                      color: p.color.withOpacity(0.70),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap, {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: iconColor ?? AppColors.charcoal),
      ),
    );
  }

  // ─── TITLE + PRICE ───────────────────────────────────────────────────────
  Widget _buildTitleSection() {
    final p = widget.product;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _chip('Elektronik', AppColors.primaryBlue),
              const SizedBox(width: 8),
              _chip('Bestseller', const Color(0xFFFF7043)),
              const Spacer(),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC107),
                size: 16,
              ),
              Text(
                ' ${p.rating}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              Text(
                '  (${p.sold} terjual)',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.midGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            p.name,
            style: GoogleFonts.poppins(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                p.price,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  p.originalPrice,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.midGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─── VARIANTS ────────────────────────────────────────────────────────────
  Widget _buildVariants() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Pilih Varian'),
          const SizedBox(height: 10),
          Row(
            children: _variants.asMap().entries.map((e) {
              final sel = _selectedVariant == e.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedVariant = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: sel ? AppColors.primaryBlue : AppColors.paleSky,
                      width: 1.5,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    e.value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : AppColors.charcoal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── COLOR PICKER ────────────────────────────────────────────────────────
  Widget _buildColorPicker() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Pilih Warna'),
          const SizedBox(height: 10),
          Row(
            children: _colorOptions.asMap().entries.map((e) {
              final sel = _selectedColor == e.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 12),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: e.value,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: sel ? Colors.white : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: e.value.withOpacity(sel ? 0.60 : 0.30),
                        blurRadius: sel ? 10 : 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: sel
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── QTY ROW ─────────────────────────────────────────────────────────────
  Widget _buildQtyRow() {
    return _card(
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Jumlah'),
              const SizedBox(height: 3),
              Text(
                'Stok: 128 tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.midGrey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _qtyBtn(Icons.remove_rounded, () {
                if (_qty > 1) setState(() => _qty--);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  '$_qty',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
              _qtyBtn(Icons.add_rounded, () => setState(() => _qty++)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.primaryBlue),
      ),
    );
  }

  // ─── INFO TABS ───────────────────────────────────────────────────────────
  Widget _buildInfoTabs() {
    final tabs = ['Deskripsi', 'Spesifikasi', 'Ulasan (${_reviews.length})'];
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tabs.asMap().entries.map((e) {
                final sel = _selectedTab == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = e.key),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            e.value,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: sel
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: sel
                                  ? AppColors.primaryBlue
                                  : AppColors.midGrey,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2.5,
                          width: sel ? (e.value.length * 7.5) : 0,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          if (_selectedTab == 0) _buildDescription(),
          if (_selectedTab == 1) _buildSpecs(),
          if (_selectedTab == 2) _buildReviews(),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final p = widget.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${p.name} hadir dengan teknologi terkini yang menghadirkan pengalaman penggunaan luar biasa. Dirancang untuk memenuhi kebutuhan sehari-hari dengan performa tinggi dan desain premium yang elegan.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.darkGrey,
            height: 1.75,
          ),
        ),
        const SizedBox(height: 12),
        ...[
          '✅ Garansi resmi 1 tahun',
          '✅ Bahan premium berkualitas tinggi',
          '✅ Desain ergonomis dan ringan',
          '✅ Layanan purna jual tersedia',
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              e,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.darkGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecs() {
    final p = widget.product;
    final specs = [
      ['Merek', 'BelanjaId Official'],
      ['Model', '${p.name} 2024'],
      ['Berat', '320 gram'],
      ['Dimensi', '15 × 8 × 3 cm'],
      ['Garansi', '12 bulan resmi'],
      ['Kondisi', 'Baru (New)'],
      ['Stok', '128 unit'],
    ];
    return Column(
      children: specs.asMap().entries.map((e) {
        final isLast = e.key == specs.length - 1;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      e.value[0],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.midGrey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value[1],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast) Divider(height: 1, color: AppColors.paleSky),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReviews() {
    final p = widget.product;
    final filtered = _reviewFilter == 0
        ? _reviews
        : _reviews.where((r) => r.stars == _reviewFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Rating summary ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.iceBlue, const Color(0xFFF0F7FF)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Big rating number
              Column(
                children: [
                  Text(
                    '${p.rating}',
                    style: GoogleFonts.poppins(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: AppColors.charcoal,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < p.rating.floor()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: const Color(0xFFFFC107),
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_reviews.length} ulasan',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.midGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              // Rating bars
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = _reviews.where((r) => r.stars == star).length;
                    final pct = _reviews.isEmpty
                        ? 0.0
                        : count / _reviews.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.midGrey,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 7,
                                backgroundColor: AppColors.paleSky,
                                color: pct > 0
                                    ? const Color(0xFFFFC107)
                                    : AppColors.paleSky,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$count',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.midGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── Tulis Ulasan button ──
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showWriteReviewSheet,
            icon: const Icon(
              Icons.rate_review_rounded,
              color: AppColors.primaryBlue,
              size: 18,
            ),
            label: Text(
              'Tulis Ulasan Anda',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.iceBlue,
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Filter chips ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('Semua', 0),
              _filterChip('⭐ 5', 5),
              _filterChip('⭐ 4', 4),
              _filterChip('⭐ 3', 3),
              _filterChip('⭐ 1-2', -1),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Review cards ──
        if (filtered.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.reviews_outlined,
                    color: AppColors.midGrey,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada ulasan untuk filter ini',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.midGrey,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...filtered.map(_buildReviewCard),
      ],
    );
  }

  Widget _filterChip(String label, int value) {
    // value -1 = stars 1 & 2
    final isSelected = value == -1
        ? (_reviewFilter == 1 || _reviewFilter == 2)
        : _reviewFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (value == -1) {
            _reviewFilter = _reviewFilter == 1 ? 2 : 1;
          } else {
            _reviewFilter = isSelected ? 0 : value;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.paleSky,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.charcoal,
          ),
        ),
      ),
    );
  }

  void _showWriteReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WriteReviewSheet(
        productName: widget.product.name,
        onSubmit: (review) {
          setState(() => _reviews.insert(0, review));
        },
      ),
    );
  }

  Widget _buildReviewCard(_Review r) {
    final helped = _helpedReviews.contains(r.id);
    final helpCount = r.helpful + (helped ? 1 : 0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.paleSky),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.15),
                  child: Text(
                    r.name[0],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            r.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.charcoal,
                            ),
                          ),
                          if (r.verified) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 10,
                                    color: AppColors.successGreen,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Terverifikasi',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: AppColors.successGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < r.stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 13,
                              color: const Color(0xFFFFC107),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            r.date,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.midGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Review text
            Text(
              r.text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.darkGrey,
                height: 1.5,
              ),
            ),

            // Tags
            if (r.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: r.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.iceBlue,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.paleSky),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],

            const SizedBox(height: 10),

            // Helpful button
            Row(
              children: [
                Text(
                  'Apakah ulasan ini membantu?',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.midGrey,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (helped) {
                        _helpedReviews.remove(r.id);
                      } else {
                        _helpedReviews.add(r.id);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: helped
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: helped
                            ? AppColors.primaryBlue
                            : AppColors.paleSky,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_rounded,
                          size: 12,
                          color: helped ? Colors.white : AppColors.midGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Membantu ($helpCount)',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: helped ? Colors.white : AppColors.midGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── SELLER CARD ─────────────────────────────────────────────────────────
  Widget _buildSellerCard() {
    return _card(
      Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.store_rounded,
              color: AppColors.primaryBlue,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BelanjaId Official Store',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFC107),
                      size: 13,
                    ),
                    Text(
                      ' 4.9  •  1.2rb produk  •  Jakarta',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.midGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              'Kunjungi',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── RELATED SECTION ─────────────────────────────────────────────────────
  Widget _buildRelatedSection() {
    final relColors = [
      const Color(0xFF6A1B9A),
      const Color(0xFF00796B),
      const Color(0xFFE65100),
      const Color(0xFF1565C0),
    ];
    final relIcons = [
      Icons.watch_rounded,
      Icons.camera_alt_rounded,
      Icons.laptop_rounded,
      Icons.headphones_rounded,
    ];
    final relNames = [
      'Smart Watch S3',
      'Kamera Mirrorless',
      'Laptop UltraSlim',
      'Earbuds Pro X1',
    ];
    final relPrices = [
      'Rp 599.000',
      'Rp 5.299.000',
      'Rp 7.499.000',
      'Rp 299.000',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
          child: Text(
            '🛍️ Produk Serupa',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (_, i) {
              final c = relColors[i % relColors.length];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (ctx, anim, _) => ProductDetailScreen(
                        product: ProductData(
                          name: relNames[i % relNames.length],
                          price: relPrices[i % relPrices.length],
                          originalPrice:
                              'Rp ${(int.parse(relPrices[i % relPrices.length].replaceAll(RegExp(r'[^0-9]'), '')) * 1.4).toInt()}',
                          rating: 4.5 + (i % 2) * 0.3,
                          sold: 300 + i * 150,
                          icon: relIcons[i % relIcons.length],
                          color: c,
                        ),
                      ),
                      transitionsBuilder: (ctx, anim, _, child) =>
                          SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                            child: child,
                          ),
                      transitionDuration: const Duration(milliseconds: 320),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: c.withOpacity(0.10),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            relIcons[i % relIcons.length],
                            size: 52,
                            color: c.withOpacity(0.70),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              relNames[i % relNames.length],
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.charcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              relPrices[i % relPrices.length],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── BOTTOM BAR ──────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _bottomIconBtn(Icons.chat_bubble_outline_rounded, () {}),
          const SizedBox(width: 8),
          _bottomIconBtn(Icons.shopping_cart_outlined, () {}),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Ditambahkan ke keranjang! 🛒',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    backgroundColor: AppColors.primaryBlue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Beli Sekarang',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.paleSky, width: 1.5),
        ),
        child: Icon(icon, color: AppColors.charcoal, size: 22),
      ),
    );
  }

  // ─── Shared helpers ───────────────────────────────────────────────────────
  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
      ),
    );
  }
}

// ─── Review model ────────────────────────────────────────────────────────────
class _Review {
  final String id;
  final String name;
  final String text;
  final String date;
  final int stars;
  final int helpful;
  final bool verified;
  final List<String> tags;

  _Review({
    required this.id,
    required this.name,
    required this.stars,
    required this.text,
    required this.date,
    required this.helpful,
    required this.verified,
    required this.tags,
  });
}

// ─── Write Review Bottom Sheet ────────────────────────────────────────────────
class _WriteReviewSheet extends StatefulWidget {
  final String productName;
  final void Function(_Review review) onSubmit;

  const _WriteReviewSheet({required this.productName, required this.onSubmit});

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  int _selectedStar = 0;
  final _textCtrl = TextEditingController();
  final List<String> _allTags = [
    'Kualitas',
    'Pengiriman Cepat',
    'Kemasan',
    'Nilai Harga',
    'Sesuai Deskripsi',
  ];
  final Set<String> _selectedTags = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedStar == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pilih rating bintang terlebih dahulu',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }
    if (_textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tulis ulasan terlebih dahulu',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final review = _Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Anda',
      stars: _selectedStar,
      text: _textCtrl.text.trim(),
      date: 'Baru saja',
      helpful: 0,
      verified: true,
      tags: _selectedTags.toList(),
    );

    widget.onSubmit(review);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.midGrey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.rate_review_rounded,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tulis Ulasan',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                        Text(
                          widget.productName,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.midGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.midGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  // Star selector
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _selectedStar == 0
                              ? 'Berikan penilaian Anda'
                              : [
                                  '',
                                  'Sangat Buruk 😞',
                                  'Buruk 😕',
                                  'Cukup 😐',
                                  'Bagus 😊',
                                  'Sangat Bagus 🤩',
                                ][_selectedStar],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final star = i + 1;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedStar = star),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    star <= _selectedStar
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    key: ValueKey(
                                      '$star-${star <= _selectedStar}',
                                    ),
                                    size: 44,
                                    color: star <= _selectedStar
                                        ? const Color(0xFFFFC107)
                                        : AppColors.midGrey,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tag selector
                  Text(
                    'Aspek yang Menonjol',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allTags.map((tag) {
                      final sel = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (sel) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primaryBlue
                                : AppColors.iceBlue,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primaryBlue
                                  : AppColors.paleSky,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: sel ? Colors.white : AppColors.charcoal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Text field
                  Text(
                    'Ulasan Anda',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _textCtrl,
                    maxLines: 5,
                    maxLength: 500,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.charcoal,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Bagikan pengalaman Anda menggunakan produk ini...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.midGrey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.paleSky,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.paleSky,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                      counterStyle: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.midGrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Kirim Ulasan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
