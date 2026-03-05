import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class PenilaianScreen extends StatefulWidget {
  const PenilaianScreen({super.key});

  @override
  State<PenilaianScreen> createState() => _PenilaianScreenState();
}

class _PenilaianScreenState extends State<PenilaianScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<_ReviewOrder> _orders = [
    _ReviewOrder(
      id: 'BLJ-2024030',
      productName: 'Celana Jogger Pria Slim Fit',
      productImage: Icons.dry_cleaning_outlined,
      price: 'Rp 189.000',
      qty: 1,
      shop: 'Clothing Co.',
      deliveredDate: '22 Feb 2026',
    ),
    _ReviewOrder(
      id: 'BLJ-2024031',
      productName: 'Charger USB-C 65W GaN Fast Charging',
      productImage: Icons.electrical_services_outlined,
      price: 'Rp 225.000',
      qty: 2,
      shop: 'Tech Accessories',
      deliveredDate: '21 Feb 2026',
    ),
    _ReviewOrder(
      id: 'BLJ-2024032',
      productName: 'Jam Tangan Digital Sport Water Resistant',
      productImage: Icons.watch_outlined,
      price: 'Rp 650.000',
      qty: 1,
      shop: 'Watch Hub ID',
      deliveredDate: '20 Feb 2026',
    ),
    _ReviewOrder(
      id: 'BLJ-2024033',
      productName: 'Kacamata Frame Anti Radiasi Blue Light',
      productImage: Icons.remove_red_eye_outlined,
      price: 'Rp 135.000',
      qty: 1,
      shop: 'Optik Vision',
      deliveredDate: '19 Feb 2026',
    ),
  ];

  final Map<String, int> _ratings = {};
  final Map<String, TextEditingController> _reviewControllers = {};

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    for (final o in _orders) {
      _ratings[o.id] = 0;
      _reviewControllers[o.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    for (final c in _reviewControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              if (_orders.isEmpty)
                SliverFillRemaining(child: _buildEmpty())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _buildReviewCard(_orders[i]),
                      childCount: _orders.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 75,
      centerTitle: false,
      backgroundColor: const Color(0xFF2E7D32),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Penilaian',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '${_orders.length} produk menunggu ulasan Anda',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(_ReviewOrder order) {
    final rating = _ratings[order.id] ?? 0;
    final controller = _reviewControllers[order.id]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.store_outlined,
                  size: 16,
                  color: AppColors.midGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  order.shop,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF7EE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Selesai',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF7EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    order.productImage,
                    color: const Color(0xFF2E7D32),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.qty}x  •  ${order.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.midGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Diterima ${order.deliveredDate}',
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
          // Star rating
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beri Penilaian',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (starIndex) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _ratings[order.id] = starIndex + 1),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          starIndex < rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: starIndex < rating
                              ? const Color(0xFFFFC107)
                              : AppColors.midGrey,
                          size: 34,
                        ),
                      ),
                    );
                  }),
                ),
                if (rating > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      '',
                      'Sangat Buruk',
                      'Buruk',
                      'Cukup',
                      'Bagus',
                      'Sangat Bagus!',
                    ][rating],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFC107),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Review text
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: TextField(
              controller: controller,
              maxLines: 3,
              maxLength: 300,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.charcoal,
              ),
              decoration: InputDecoration(
                hintText: 'Tuliskan ulasan Anda tentang produk ini...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.midGrey,
                ),
                counterStyle: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.midGrey,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.paleSky),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.paleSky),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E7D32),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          // Submit
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: rating == 0
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ulasan berhasil dikirim!',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            backgroundColor: const Color(0xFF2E7D32),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.lightGrey,
                  disabledForegroundColor: AppColors.midGrey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Kirim Ulasan',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 72,
            color: AppColors.midGrey.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada produk yang perlu diulas',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.midGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReviewOrder {
  final String id;
  final String productName;
  final IconData productImage;
  final String price;
  final int qty;
  final String shop;
  final String deliveredDate;

  const _ReviewOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.qty,
    required this.shop,
    required this.deliveredDate,
  });
}
