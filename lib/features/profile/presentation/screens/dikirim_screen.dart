import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DikirimScreen extends StatefulWidget {
  const DikirimScreen({super.key});

  @override
  State<DikirimScreen> createState() => _DikirimScreenState();
}

class _DikirimScreenState extends State<DikirimScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<_ShippingOrder> _orders = [
    _ShippingOrder(
      id: 'BLJ-2024020',
      productName: 'Headphone Bluetooth Noise Cancelling',
      productImage: Icons.headphones_outlined,
      price: 'Rp 899.000',
      qty: 1,
      shop: 'Gadget Hub',
      courier: 'JNE REG',
      trackingNumber: 'JNE2024560123',
      estimatedDate: '27 Feb 2026',
      lastUpdate: 'Paket dalam perjalanan ke kota tujuan',
    ),
    _ShippingOrder(
      id: 'BLJ-2024021',
      productName: 'Buku Produktivitas & Mindset',
      productImage: Icons.menu_book_outlined,
      price: 'Rp 89.000',
      qty: 3,
      shop: 'Gramedia Official',
      courier: 'SiCepat BEST',
      trackingNumber: 'SCP2024987654',
      estimatedDate: '28 Feb 2026',
      lastUpdate: 'Paket telah tiba di gudang penyortiran',
    ),
    _ShippingOrder(
      id: 'BLJ-2024022',
      productName: 'Skincare Set Vitamin C Glow',
      productImage: Icons.spa_outlined,
      price: 'Rp 345.000',
      qty: 1,
      shop: 'Beauty Corner',
      courier: 'Anteraja Reguler',
      trackingNumber: 'ATJ20249876',
      estimatedDate: '1 Mar 2026',
      lastUpdate: 'Kurir sedang dalam perjalanan mengantarkan paket',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
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
                      (_, i) => _buildOrderCard(_orders[i]),
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
      backgroundColor: const Color(0xFF1565C0),
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
            'Dikirim',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '${_orders.length} pesanan dalam pengiriman',
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
              colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(_ShippingOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                Text(
                  order.id,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.midGrey,
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
                    color: const Color(0xFFEBF3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    order.productImage,
                    color: const Color(0xFF1565C0),
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
                        '${order.qty}x barang',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.midGrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order.price,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tracking info
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_rounded,
                      size: 15,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.courier,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      order.trackingNumber,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.midGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: AppColors.midGrey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.lastUpdate,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: AppColors.midGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Estimasi tiba: ',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.midGrey,
                      ),
                    ),
                    Text(
                      order.estimatedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Lacak',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Pesanan Diterima',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
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
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 72,
            color: AppColors.midGrey.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada pesanan yang sedang dikirim',
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

class _ShippingOrder {
  final String id;
  final String productName;
  final IconData productImage;
  final String price;
  final int qty;
  final String shop;
  final String courier;
  final String trackingNumber;
  final String estimatedDate;
  final String lastUpdate;

  const _ShippingOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.qty,
    required this.shop,
    required this.courier,
    required this.trackingNumber,
    required this.estimatedDate,
    required this.lastUpdate,
  });
}
