import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../../product/presentation/screens/product_list_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;
  int _selectedCategory = 0;
  int _selectedNav = 0;

  final List<_PromoData> _promos = [
    _PromoData(
      title: 'Harbolnas 12.12',
      subtitle: 'Diskon hingga 80% semua kategori!',
      gradient: [Color(0xFF1565C0), Color(0xFF42A5F5)],
      icon: Icons.local_fire_department_rounded,
      tag: 'TERBATAS',
    ),
    _PromoData(
      title: 'Flash Sale Elektronik',
      subtitle: 'HP & Laptop mulai Rp999rb',
      gradient: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
      icon: Icons.bolt_rounded,
      tag: 'FLASH SALE',
    ),
    _PromoData(
      title: 'Gratis Ongkir Seluruh ID',
      subtitle: 'Minimum belanja Rp50.000 saja',
      gradient: [Color(0xFF00796B), Color(0xFF4DB6AC)],
      icon: Icons.local_shipping_rounded,
      tag: 'GRATIS ONGKIR',
    ),
  ];

  final List<_Category> _categories = [
    _Category(Icons.phone_android_rounded, 'Elektronik'),
    _Category(Icons.checkroom_rounded, 'Fashion'),
    _Category(Icons.blender_rounded, 'Dapur'),
    _Category(Icons.sports_soccer_rounded, 'Olahraga'),
    _Category(Icons.face_rounded, 'Kecantikan'),
    _Category(Icons.toys_rounded, 'Mainan'),
    _Category(Icons.book_rounded, 'Buku'),
    _Category(Icons.more_horiz_rounded, 'Lainnya'),
  ];

  final List<_Product> _featuredProducts = [
    _Product(
      'Earbuds Pro X1',
      'Rp 299.000',
      'Rp 499.000',
      4.8,
      1240,
      Icons.headphones_rounded,
      AppColors.primaryBlue,
    ),
    _Product(
      'Smart Watch S3',
      'Rp 599.000',
      'Rp 899.000',
      4.6,
      876,
      Icons.watch_rounded,
      Color(0xFF6A1B9A),
    ),
    _Product(
      'Kamera Mirrorless',
      'Rp 5.299.000',
      'Rp 7.000.000',
      4.9,
      320,
      Icons.camera_alt_rounded,
      Color(0xFF00796B),
    ),
    _Product(
      'Laptop UltraSlim',
      'Rp 7.499.000',
      'Rp 9.999.000',
      4.7,
      512,
      Icons.laptop_rounded,
      Color(0xFFE65100),
    ),
  ];

  final List<_Product> _promoProducts = [
    _Product(
      'Sepatu Running',
      'Rp 249.000',
      'Rp 450.000',
      4.5,
      2100,
      Icons.directions_run_rounded,
      Color(0xFF1976D2),
    ),
    _Product(
      'Blouse Premium',
      'Rp 129.000',
      'Rp 250.000',
      4.3,
      3400,
      Icons.checkroom_rounded,
      Color(0xFFC2185B),
    ),
    _Product(
      'Tas Kantor',
      'Rp 189.000',
      'Rp 350.000',
      4.6,
      980,
      Icons.work_rounded,
      Color(0xFF5D4037),
    ),
    _Product(
      'Skincare Set',
      'Rp 159.000',
      'Rp 299.000',
      4.7,
      1560,
      Icons.face_rounded,
      Color(0xFF7B1FA2),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_bannerController.hasClients) {
        final next = (_currentBanner + 1) % _promos.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _openProduct(_Product p) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, _) => ProductDetailScreen(
          product: ProductData(
            name: p.name,
            price: p.price,
            originalPrice: p.originalPrice,
            rating: p.rating,
            sold: p.sold,
            icon: p.icon,
            color: p.color,
          ),
        ),
        transitionsBuilder: (ctx, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: IndexedStack(
          index: _selectedNav == 4 ? 1 : 0,
          children: [
            // Tab 0: Home content
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildSearchBar()),
                SliverToBoxAdapter(child: _buildPromoBanner()),
                SliverToBoxAdapter(child: _buildCategories()),
                SliverToBoxAdapter(
                  child: _buildSectionTitle(
                    '🔥 Produk Unggulan',
                    'Lihat Semua',
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildProductHorizontal(_featuredProducts),
                ),
                SliverToBoxAdapter(child: _buildSpecialBanner()),
                SliverToBoxAdapter(
                  child: _buildSectionTitle(
                    '🏷️ Promo Hari Ini',
                    'Lihat Semua',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProductCard(
                        _promoProducts[index % _promoProducts.length],
                      ),
                      childCount: _promoProducts.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),

            // Tab 1: Profile
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.80),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mau belanja apa hari ini?',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Cart
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5722),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '3',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.40),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SEARCH BAR ──
  Widget _buildSearchBar() {
    return Transform.translate(
      offset: const Offset(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search_rounded,
                color: AppColors.primaryBlue,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari produk, brand, kategori...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.midGrey,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12, // 👈 ini bikin teks tidak mepet kiri
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── PROMO BANNER ──
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _promos.length,
              onPageChanged: (i) => setState(() => _currentBanner = i),
              itemBuilder: (_, i) => _buildBannerItem(_promos[i]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _promos.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentBanner == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentBanner == i
                      ? AppColors.primaryBlue
                      : AppColors.paleSky,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(_PromoData promo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: promo.gradient,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Dekorasi lingkaran
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Konten
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          promo.tag,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        promo.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.88),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Belanja Sekarang',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: promo.gradient[0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  promo.icon,
                  size: 70,
                  color: Colors.white.withOpacity(0.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── KATEGORI ──
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
          child: Text(
            'Kategori',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
        ),
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final selected = _selectedCategory == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = i),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: selected
                                  ? AppColors.primaryBlue.withOpacity(0.30)
                                  : Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _categories[i].icon,
                          color: selected
                              ? Colors.white
                              : AppColors.primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _categories[i].label,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  // ── SECTION TITLE ──
  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (ctx, anim, _) => const ProductListScreen(),
                transitionsBuilder: (ctx, anim, _, child) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                  child: child,
                ),
                transitionDuration: const Duration(milliseconds: 320),
              ),
            ),
            child: Text(
              action,
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

  // ── PRODUK HORIZONTAL ──
  Widget _buildProductHorizontal(List<_Product> products) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (_, i) => _buildProductCardHorizontal(products[i]),
      ),
    );
  }

  Widget _buildProductCardHorizontal(_Product p) {
    final discount =
        ((1 -
                    (double.parse(p.price.replaceAll(RegExp(r'[^0-9]'), '')) /
                        double.parse(
                          p.originalPrice.replaceAll(RegExp(r'[^0-9]'), ''),
                        ))) *
                100)
            .round();
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
        width: 155,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk (placeholder warna)
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: p.color.withOpacity(0.10),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    p.icon,
                    size: 52,
                    color: p.color.withOpacity(0.70),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$discount%',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  p.price,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  p.originalPrice,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.midGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: Color(0xFFFFC107),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${p.rating}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    Text(
                      ' (${p.sold})',
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
    ),
    );
  }


  // ── SPECIAL BANNER ──
  Widget _buildSpecialBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Undang Teman, Dapat Reward!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kode referal kamu bisa hemat Rp50.000',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Bagikan',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PRODUCT CARD (GRID) ──
  Widget _buildProductCard(_Product p) {
    final discount =
        ((1 -
                    (double.parse(p.price.replaceAll(RegExp(r'[^0-9]'), '')) /
                        double.parse(
                          p.originalPrice.replaceAll(RegExp(r'[^0-9]'), ''),
                        ))) *
                100)
            .round();
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: p.color.withOpacity(0.10),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      p.icon,
                      size: 60,
                      color: p.color.withOpacity(0.65),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$discount%',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  p.price,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      p.originalPrice,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.midGrey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star_rounded,
                      size: 11,
                      color: Color(0xFFFFC107),
                    ),
                    Text(
                      ' ${p.rating}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${p.sold} terjual',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.midGrey,
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

  // ── BOTTOM NAVIGATION ──
  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Beranda'),
      (Icons.explore_rounded, Icons.explore_outlined, 'Kategori'),
      (Icons.local_offer_rounded, Icons.local_offer_outlined, 'Promo'),
      (Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, 'Chat'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Akun'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final selected = _selectedNav == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedNav = i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 56,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryBlue.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          selected ? item.$1 : item.$2,
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.midGrey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$3,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.midGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ── Data Models ──
class _PromoData {
  final String title, subtitle, tag;
  final List<Color> gradient;
  final IconData icon;
  const _PromoData({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.gradient,
    required this.icon,
  });
}

class _Category {
  final IconData icon;
  final String label;
  const _Category(this.icon, this.label);
}

class _Product {
  final String name, price, originalPrice;
  final double rating;
  final int sold;
  final IconData icon;
  final Color color;
  const _Product(
    this.name,
    this.price,
    this.originalPrice,
    this.rating,
    this.sold,
    this.icon,
    this.color,
  );
}
