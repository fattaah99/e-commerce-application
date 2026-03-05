import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DikemasScreen extends StatefulWidget {
  const DikemasScreen({super.key});

  @override
  State<DikemasScreen> createState() => _DikemasScreenState();
}

class _DikemasScreenState extends State<DikemasScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<_PackingOrder> _orders = [
    _PackingOrder(
      id: 'BLJ-2024010',
      productName: 'Tas Ransel Laptop Premium 15"',
      productImage: Icons.backpack_outlined,
      price: 'Rp 378.000',
      qty: 1,
      shop: 'Bag World Store',
      status: 'Sedang dikemas',
      date: '25 Feb 2026',
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
      backgroundColor: const Color(0xFF7B1FA2),
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
            'Dikemas',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '${_orders.length} pesanan sedang diproses',
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
              colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFAB47BC)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(_PackingOrder order) {
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
                    color: const Color(0xFFF8F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    order.productImage,
                    color: const Color(0xFF7B1FA2),
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
                          color: const Color(0xFF7B1FA2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress steps
          _buildProgressSteps(),
          // Footer info
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 15,
                  color: Color(0xFF7B1FA2),
                ),
                const SizedBox(width: 6),
                Text(
                  'Status: ',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.midGrey,
                  ),
                ),
                Text(
                  order.status,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7B1FA2),
                  ),
                ),
                const Spacer(),
                Text(
                  order.date,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.midGrey,
                  ),
                ),
              ],
            ),
          ),
          // Action
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7B1FA2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'Lihat Detail Pesanan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7B1FA2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    final steps = ['Pembayaran', 'Dikemas', 'Dikirim', 'Diterima'];
    const activeIndex = 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepIndex < activeIndex
                    ? const Color(0xFF7B1FA2)
                    : const Color(0xFFE8EAF6),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isDone = stepIndex < activeIndex;
          final isActive = stepIndex == activeIndex;
          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone || isActive
                      ? const Color(0xFF7B1FA2)
                      : Colors.white,
                  border: Border.all(
                    color: isDone || isActive
                        ? const Color(0xFF7B1FA2)
                        : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : isActive
                    ? const Icon(Icons.circle, color: Colors.white, size: 8)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex],
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isDone || isActive
                      ? const Color(0xFF7B1FA2)
                      : AppColors.midGrey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 72,
            color: AppColors.midGrey.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada pesanan yang sedang dikemas',
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

class _PackingOrder {
  final String id;
  final String productName;
  final IconData productImage;
  final String price;
  final int qty;
  final String shop;
  final String status;
  final String date;

  const _PackingOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.qty,
    required this.shop,
    required this.status,
    required this.date,
  });
}
