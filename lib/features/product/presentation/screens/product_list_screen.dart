import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'product_detail_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Store model
// ─────────────────────────────────────────────────────────────────────────────
class _StoreData {
  final String name, location, category;
  final double rating;
  final int products;
  final Color color;
  final IconData icon;
  const _StoreData({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.products,
    required this.color,
    required this.icon,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Product List Screen
// ─────────────────────────────────────────────────────────────────────────────
class ProductListScreen extends StatefulWidget {
  final String? initialCategory;
  const ProductListScreen({super.key, this.initialCategory});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  // ── Controllers ──
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  // ── State ──
  String _query = '';
  int _selectedFilter = 0; // 0=Semua 1=Elektronik 2=Fashion 3=Dapur ...
  int _sortIndex = 0; // 0=Relevan 1=Termurah 2=Termahal 3=Rating
  bool _isGrid = true;
  bool _showStores = true;

  // ── Price filter ──
  static const double _priceMin = 0;
  static const double _priceMax = 10000000;
  RangeValues _priceRange = const RangeValues(_priceMin, _priceMax);
  bool get _isPriceFiltered =>
      _priceRange.start > _priceMin || _priceRange.end < _priceMax;

  // ── Filters ──
  final List<String> _filters = [
    'Semua',
    'Elektronik',
    'Fashion',
    'Dapur',
    'Olahraga',
    'Kecantikan',
  ];
  final List<String> _sortOptions = [
    'Relevan',
    'Termurah',
    'Termahal',
    'Rating Tertinggi',
  ];

  // ── Master product list ──
  final List<ProductData> _allProducts = [
    ProductData(
      name: 'Earbuds Pro X1',
      price: 'Rp 299.000',
      originalPrice: 'Rp 499.000',
      rating: 4.8,
      sold: 1240,
      icon: Icons.headphones_rounded,
      color: Color(0xFF1565C0),
    ),
    ProductData(
      name: 'Smart Watch S3',
      price: 'Rp 599.000',
      originalPrice: 'Rp 899.000',
      rating: 4.6,
      sold: 876,
      icon: Icons.watch_rounded,
      color: Color(0xFF6A1B9A),
    ),
    ProductData(
      name: 'Kamera Mirrorless',
      price: 'Rp 5.299.000',
      originalPrice: 'Rp 7.000.000',
      rating: 4.9,
      sold: 320,
      icon: Icons.camera_alt_rounded,
      color: Color(0xFF00796B),
    ),
    ProductData(
      name: 'Laptop UltraSlim',
      price: 'Rp 7.499.000',
      originalPrice: 'Rp 9.999.000',
      rating: 4.7,
      sold: 512,
      icon: Icons.laptop_rounded,
      color: Color(0xFFE65100),
    ),
    ProductData(
      name: 'Sepatu Running',
      price: 'Rp 249.000',
      originalPrice: 'Rp 450.000',
      rating: 4.5,
      sold: 2100,
      icon: Icons.directions_run_rounded,
      color: Color(0xFF1976D2),
    ),
    ProductData(
      name: 'Blouse Premium',
      price: 'Rp 129.000',
      originalPrice: 'Rp 250.000',
      rating: 4.3,
      sold: 3400,
      icon: Icons.checkroom_rounded,
      color: Color(0xFFC2185B),
    ),
    ProductData(
      name: 'Tas Kantor',
      price: 'Rp 189.000',
      originalPrice: 'Rp 350.000',
      rating: 4.6,
      sold: 980,
      icon: Icons.work_rounded,
      color: Color(0xFF5D4037),
    ),
    ProductData(
      name: 'Skincare Set',
      price: 'Rp 159.000',
      originalPrice: 'Rp 299.000',
      rating: 4.7,
      sold: 1560,
      icon: Icons.face_rounded,
      color: Color(0xFF7B1FA2),
    ),
    ProductData(
      name: 'Meja Belajar Lipat',
      price: 'Rp 349.000',
      originalPrice: 'Rp 550.000',
      rating: 4.4,
      sold: 670,
      icon: Icons.table_bar_rounded,
      color: Color(0xFF558B2F),
    ),
    ProductData(
      name: 'Rice Cooker Digital',
      price: 'Rp 449.000',
      originalPrice: 'Rp 699.000',
      rating: 4.5,
      sold: 890,
      icon: Icons.blender_rounded,
      color: Color(0xFFEF6C00),
    ),
    ProductData(
      name: 'Drone Mini Pro',
      price: 'Rp 1.299.000',
      originalPrice: 'Rp 1.899.000',
      rating: 4.6,
      sold: 234,
      icon: Icons.airplanemode_active_rounded,
      color: Color(0xFF0277BD),
    ),
    ProductData(
      name: 'Sepeda Lipat',
      price: 'Rp 2.199.000',
      originalPrice: 'Rp 3.200.000',
      rating: 4.8,
      sold: 145,
      icon: Icons.pedal_bike_rounded,
      color: Color(0xFF2E7D32),
    ),
    ProductData(
      name: 'Parfum Elegan',
      price: 'Rp 219.000',
      originalPrice: 'Rp 380.000',
      rating: 4.7,
      sold: 2200,
      icon: Icons.local_florist_rounded,
      color: Color(0xFF880E4F),
    ),
    ProductData(
      name: 'Speaker Bluetooth',
      price: 'Rp 389.000',
      originalPrice: 'Rp 599.000',
      rating: 4.5,
      sold: 1100,
      icon: Icons.speaker_rounded,
      color: Color(0xFF37474F),
    ),
    ProductData(
      name: 'Raket Badminton Pro',
      price: 'Rp 279.000',
      originalPrice: 'Rp 450.000',
      rating: 4.3,
      sold: 560,
      icon: Icons.sports_tennis_rounded,
      color: Color(0xFF1B5E20),
    ),
    ProductData(
      name: 'Power Bank 20000mAh',
      price: 'Rp 199.000',
      originalPrice: 'Rp 349.000',
      rating: 4.6,
      sold: 3800,
      icon: Icons.battery_charging_full_rounded,
      color: Color(0xFF4527A0),
    ),
  ];

  // ── Stores ──
  final List<_StoreData> _stores = [
    _StoreData(
      name: 'TeknoPedia',
      location: 'Jakarta',
      category: 'Elektronik',
      rating: 4.9,
      products: 1240,
      color: Color(0xFF1565C0),
      icon: Icons.laptop_rounded,
    ),
    _StoreData(
      name: 'FashionKu',
      location: 'Bandung',
      category: 'Fashion',
      rating: 4.7,
      products: 560,
      color: Color(0xFFC2185B),
      icon: Icons.checkroom_rounded,
    ),
    _StoreData(
      name: 'DapurMakmur',
      location: 'Surabaya',
      category: 'Dapur',
      rating: 4.8,
      products: 340,
      color: Color(0xFFEF6C00),
      icon: Icons.blender_rounded,
    ),
    _StoreData(
      name: 'SportZone',
      location: 'Medan',
      category: 'Olahraga',
      rating: 4.6,
      products: 780,
      color: Color(0xFF2E7D32),
      icon: Icons.sports_tennis_rounded,
    ),
    _StoreData(
      name: 'GlowBeauty',
      location: 'Bali',
      category: 'Kecantikan',
      rating: 4.8,
      products: 430,
      color: Color(0xFF7B1FA2),
      icon: Icons.face_rounded,
    ),
    _StoreData(
      name: 'GadgetHub',
      location: 'Yogyakarta',
      category: 'Elektronik',
      rating: 4.7,
      products: 920,
      color: Color(0xFF37474F),
      icon: Icons.phone_android_rounded,
    ),
  ];

  List<ProductData> get _filtered {
    List<ProductData> list = List.from(_allProducts);

    if (_query.isNotEmpty) {
      list = list
          .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }

    // Price range filter
    if (_isPriceFiltered) {
      list = list.where((p) {
        final price =
            int.tryParse(p.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return price >= _priceRange.start && price <= _priceRange.end;
      }).toList();
    }

    // Sort
    switch (_sortIndex) {
      case 1: // Termurah
        list.sort((a, b) {
          final pa =
              int.tryParse(a.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          final pb =
              int.tryParse(b.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return pa.compareTo(pb);
        });
        break;
      case 2: // Termahal
        list.sort((a, b) {
          final pa =
              int.tryParse(a.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          final pb =
              int.tryParse(b.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return pb.compareTo(pa);
        });
        break;
      case 3: // Rating
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _openProduct(ProductData p) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => ProductDetailScreen(product: p),
        transitionsBuilder: (ctx, anim, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        // ── Sticky header: gradient bar with search + category chips ──────────
        appBar: _buildStickyHeader(),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Store section ──
              if (_showStores && _query.isEmpty)
                SliverToBoxAdapter(child: _buildStoreSection()),

              // ── Filter + Sort row ──
              SliverToBoxAdapter(child: _buildFilterRow()),

              // ── Product count ──
              SliverToBoxAdapter(child: _buildResultHeader()),

              // ── Products ──
              if (_isGrid) _buildProductGrid() else _buildProductList(),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── STICKY HEADER (always pinned — search + category chips) ────────────
  PreferredSizeWidget _buildStickyHeader() {
    // Total height = statusBar + top-row (58) + category chips (48)
    final statusH = MediaQuery.of(context).padding.top;
    return PreferredSize(
      preferredSize: Size.fromHeight(statusH + 106),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x281565C0),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Row: back button + search bar + cart ──
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Row(
                  children: [
                    // Back
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    // Search bar (expands to fill space)
                    Expanded(child: _buildSearchBar()),
                    // Cart icon
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      ),
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
              // ── Category filter chips ──
              _buildCategoryBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(
            Icons.search_rounded,
            color: AppColors.primaryBlue,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.charcoal,
              ),
              decoration: InputDecoration(
                hintText: 'Cari produk, toko, brand...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.midGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
              ),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () => _searchCtrl.clear(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.cancel_rounded,
                  color: AppColors.midGrey,
                  size: 18,
                ),
              ),
            ),
          // Tune icon → price filter
          GestureDetector(
            onTap: _showPriceFilterSheet,
            child: Container(
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _isPriceFiltered
                    ? AppColors.successGreen
                    : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                  if (_isPriceFiltered) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 48,
      color: AppColors.primaryBlue,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final sel = _selectedFilter == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: sel ? Colors.white : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? Colors.white : Colors.white.withOpacity(0.30),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _filters[i],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? AppColors.primaryBlue : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── STORE SECTION (single featured store) ─────────────────────────────
  Widget _buildStoreSection() {
    final s = _stores.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.storefront_rounded,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Toko Pilihan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Store avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: s.color.withOpacity(0.12),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        s.icon,
                        size: 44,
                        color: s.color.withOpacity(0.85),
                      ),
                    ),
                  ),
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                s.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.charcoal,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(
                                    0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Official',
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 12,
                                color: AppColors.midGrey,
                              ),
                              Text(
                                ' ${s.location}  •  ${s.category}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.midGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 13,
                                color: Color(0xFFFFC107),
                              ),
                              Text(
                                ' ${s.rating}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.charcoal,
                                ),
                              ),
                              Text(
                                '  •  ${s.products} produk',
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
                  ),
                  // Visit button
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Kunjungi',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FILTER / SORT ROW ──────────────────────────────────────────────────
  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          // Sort dropdown
          GestureDetector(
            onTap: _showSortSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _sortOptions[_sortIndex],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: AppColors.midGrey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Price filter button
          GestureDetector(
            onTap: _showPriceFilterSheet,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isPriceFiltered ? AppColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isPriceFiltered
                      ? AppColors.primaryBlue
                      : AppColors.paleSky,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 15,
                    color: _isPriceFiltered
                        ? Colors.white
                        : AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _isPriceFiltered
                        ? '${_formatPrice(_priceRange.start.toInt())} – ${_formatPrice(_priceRange.end.toInt())}'
                        : 'Filter Harga',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _isPriceFiltered
                          ? Colors.white
                          : AppColors.charcoal,
                    ),
                  ),
                  if (_isPriceFiltered) ...[
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(
                        () => _priceRange = const RangeValues(
                          _priceMin,
                          _priceMax,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 15,
                      color: AppColors.midGrey,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          // Toggle grid/list
          GestureDetector(
            onTap: () => setState(() => _isGrid = !_isGrid),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.paleSky,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Urutkan Berdasarkan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 12),
            ..._sortOptions.asMap().entries.map((e) {
              final sel = _sortIndex == e.key;
              return GestureDetector(
                onTap: () {
                  setState(() => _sortIndex = e.key);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primaryBlue.withOpacity(0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel ? AppColors.primaryBlue : AppColors.paleSky,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        e.value,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel
                              ? AppColors.primaryBlue
                              : AppColors.charcoal,
                        ),
                      ),
                      const Spacer(),
                      if (sel)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── PRICE FILTER ─────────────────────────────────────────────────────────
  String _formatPrice(int value) {
    if (value >= 1000000) {
      final m = value / 1000000;
      return 'Rp ${m % 1 == 0 ? m.toInt() : m.toStringAsFixed(1)}jt';
    } else if (value >= 1000) {
      return 'Rp ${(value / 1000).toInt()}rb';
    }
    return 'Rp $value';
  }

  void _showPriceFilterSheet() {
    // Local state inside the sheet — use StatefulBuilder
    RangeValues tempRange = _priceRange;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.paleSky,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filter Harga',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const Spacer(),
                    if (tempRange.start > _priceMin ||
                        tempRange.end < _priceMax)
                      TextButton(
                        onPressed: () {
                          setSheet(
                            () => tempRange = const RangeValues(
                              _priceMin,
                              _priceMax,
                            ),
                          );
                        },
                        child: Text(
                          'Reset',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.errorRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display selected range
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryBlue.withOpacity(0.07),
                            AppColors.iceBlue,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.paleSky),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harga Minimum',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.midGrey,
                                  ),
                                ),
                                Text(
                                  _formatPrice(tempRange.start.toInt()),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            color: AppColors.paleSky,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Harga Maksimum',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.midGrey,
                                  ),
                                ),
                                Text(
                                  _formatPrice(tempRange.end.toInt()),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
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

                    const SizedBox(height: 16),

                    // Range slider
                    SliderTheme(
                      data: SliderTheme.of(ctx).copyWith(
                        activeTrackColor: AppColors.primaryBlue,
                        inactiveTrackColor: AppColors.paleSky,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                          elevation: 4,
                        ),
                        overlayColor: AppColors.primaryBlue.withOpacity(0.15),
                        trackHeight: 5,
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 12,
                          elevation: 4,
                        ),
                      ),
                      child: RangeSlider(
                        values: tempRange,
                        min: _priceMin,
                        max: _priceMax,
                        divisions: 100,
                        onChanged: (v) => setSheet(() => tempRange = v),
                      ),
                    ),

                    // Min/Max labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatPrice(_priceMin.toInt()),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.midGrey,
                          ),
                        ),
                        Text(
                          _formatPrice(_priceMax.toInt()),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.midGrey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quick-pick preset chips
                    Text(
                      'Pilihan Cepat',
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
                      children: [
                        _pricePreset(
                          ctx,
                          setSheet,
                          tempRange,
                          'Di bawah 200rb',
                          0,
                          200000,
                          onSelect: (v) => tempRange = v,
                        ),
                        _pricePreset(
                          ctx,
                          setSheet,
                          tempRange,
                          '200rb – 500rb',
                          200000,
                          500000,
                          onSelect: (v) => tempRange = v,
                        ),
                        _pricePreset(
                          ctx,
                          setSheet,
                          tempRange,
                          '500rb – 1jt',
                          500000,
                          1000000,
                          onSelect: (v) => tempRange = v,
                        ),
                        _pricePreset(
                          ctx,
                          setSheet,
                          tempRange,
                          '1jt – 3jt',
                          1000000,
                          3000000,
                          onSelect: (v) => tempRange = v,
                        ),
                        _pricePreset(
                          ctx,
                          setSheet,
                          tempRange,
                          'Di atas 3jt',
                          3000000,
                          _priceMax,
                          onSelect: (v) => tempRange = v,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _priceRange = tempRange);
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Terapkan Filter',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _pricePreset(
    BuildContext ctx,
    StateSetter setSheet,
    RangeValues current,
    String label,
    double min,
    double max, {
    required void Function(RangeValues) onSelect,
  }) {
    final isSelected =
        (current.start - min).abs() < 1 && (current.end - max).abs() < 1;
    return GestureDetector(
      onTap: () => setSheet(() => onSelect(RangeValues(min, max))),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.iceBlue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.paleSky,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ─── RESULT HEADER ───────────────────────────────────────────────────────
  Widget _buildResultHeader() {
    final count = _filtered.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.midGrey),
          children: [
            TextSpan(
              text: '$count',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
            const TextSpan(text: ' produk ditemukan'),
          ],
        ),
      ),
    );
  }

  // ─── PRODUCT GRID ─────────────────────────────────────────────────────────
  Widget _buildProductGrid() {
    final products = _filtered;
    if (products.isEmpty) return _buildEmpty();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => _buildGridCard(products[i]),
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildGridCard(ProductData p) {
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                        size: 64,
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
                          '${p.discount}%',
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
                      Text(
                        ' ${p.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        '  •  ${_formatSold(p.sold)} terjual',
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

  // ─── PRODUCT LIST (toggle view) ──────────────────────────────────────────
  Widget _buildProductList() {
    final products = _filtered;
    if (products.isEmpty) return _buildEmpty();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => _buildListCard(products[i]),
        childCount: products.length,
      ),
    );
  }

  Widget _buildListCard(ProductData p) {
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: p.color.withOpacity(0.10),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(p.icon, size: 52, color: p.color.withOpacity(0.75)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Color(0xFFFFC107),
                        ),
                        Text(
                          ' ${p.rating}  •  ${_formatSold(p.sold)} terjual',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.midGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.price,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          p.originalPrice,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.midGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Hemat ${p.discount}%',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                      size: 16,
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

  // ─── EMPTY STATE ─────────────────────────────────────────────────────────
  SliverToBoxAdapter _buildEmpty() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 72, color: AppColors.paleSky),
            const SizedBox(height: 12),
            Text(
              'Produk tidak ditemukan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.midGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba kata kunci lain',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.midGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────
  String _formatSold(int sold) {
    if (sold >= 1000) return '${(sold / 1000).toStringAsFixed(1)}rb';
    return '$sold';
  }
}
