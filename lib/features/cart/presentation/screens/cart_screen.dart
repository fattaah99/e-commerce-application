import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Cart Item Model
// ─────────────────────────────────────────────────────────────────────────────
class CartItem {
  final String id;
  final String name;
  final String variant;
  final String price;
  final int priceNum;
  final IconData icon;
  final Color color;
  int qty;
  bool selected;

  CartItem({
    required this.id,
    required this.name,
    required this.variant,
    required this.price,
    required this.priceNum,
    required this.icon,
    required this.color,
    this.qty = 1,
    this.selected = true,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Cart Screen
// ─────────────────────────────────────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final TextEditingController _couponCtrl = TextEditingController();
  bool _couponApplied = false;
  int _couponDiscount = 0;

  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Earbuds Pro X1',
      variant: 'Standard • Biru',
      price: 'Rp 299.000',
      priceNum: 299000,
      icon: Icons.headphones_rounded,
      color: Color(0xFF1565C0),
      qty: 2,
    ),
    CartItem(
      id: '2',
      name: 'Smart Watch S3',
      variant: 'Pro • Hitam',
      price: 'Rp 599.000',
      priceNum: 599000,
      icon: Icons.watch_rounded,
      color: Color(0xFF6A1B9A),
      qty: 1,
    ),
    CartItem(
      id: '3',
      name: 'Skincare Set',
      variant: 'Standard',
      price: 'Rp 159.000',
      priceNum: 159000,
      icon: Icons.face_rounded,
      color: Color(0xFF7B1FA2),
      qty: 1,
    ),
    CartItem(
      id: '4',
      name: 'Speaker Bluetooth',
      variant: 'Pro Max • Abu',
      price: 'Rp 389.000',
      priceNum: 389000,
      icon: Icons.speaker_rounded,
      color: Color(0xFF37474F),
      qty: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _couponCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  bool get _allSelected => _items.isNotEmpty && _items.every((e) => e.selected);

  List<CartItem> get _selectedItems => _items.where((e) => e.selected).toList();

  int get _subtotal =>
      _selectedItems.fold(0, (sum, e) => sum + e.priceNum * e.qty);

  int get _shipping => _selectedItems.isEmpty ? 0 : 15000;

  int get _total => _subtotal + _shipping - _couponDiscount;

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer('Rp ');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _toggleAll(bool? v) {
    setState(() {
      for (final item in _items) {
        item.selected = v ?? false;
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() => _items.removeWhere((e) => e.id == item.id));
  }

  void _removeSelected() {
    setState(() => _items.removeWhere((e) => e.selected));
  }

  void _applyCoupon() {
    final code = _couponCtrl.text.trim().toUpperCase();
    if (code == 'HEMAT50') {
      setState(() {
        _couponApplied = true;
        _couponDiscount = 50000;
      });
      _showSnack('Kupon berhasil! Hemat Rp 50.000 🎉', isSuccess: true);
    } else {
      _showSnack('Kode kupon tidak valid', isSuccess: false);
    }
  }

  void _showSnack(String msg, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: isSuccess
            ? const Color(0xFF2E7D32)
            : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
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
        appBar: _buildAppBar(),
        body: _items.isEmpty
            ? _buildEmptyState()
            : FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    // ── Scrollable content ──
                    Expanded(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // Select all row
                          SliverToBoxAdapter(child: _buildSelectAllRow()),
                          // Cart items
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) => _buildCartItem(_items[i]),
                              childCount: _items.length,
                            ),
                          ),
                          // Coupon
                          SliverToBoxAdapter(child: _buildCouponSection()),
                          // Price summary
                          SliverToBoxAdapter(child: _buildPriceSummary()),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 120),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        // ── Sticky bottom checkout bar ──
        bottomNavigationBar: _items.isEmpty ? null : _buildCheckoutBar(),
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    final hasSelected = _selectedItems.isNotEmpty;
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x301565C0),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Keranjang Belanja',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_items.length} produk',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasSelected)
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Hapus Produk',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          content: Text(
                            'Hapus ${_selectedItems.length} produk yang dipilih?',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Batal',
                                style: GoogleFonts.poppins(
                                  color: AppColors.midGrey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _removeSelected();
                              },
                              child: Text(
                                'Hapus',
                                style: GoogleFonts.poppins(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'Hapus',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── SELECT ALL ROW ──────────────────────────────────────────────────────
  Widget _buildSelectAllRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCheckbox(value: _allSelected, onChanged: _toggleAll),
          const SizedBox(width: 10),
          Text(
            'Pilih Semua',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal,
            ),
          ),
          const Spacer(),
          Text(
            '${_selectedItems.length} dari ${_items.length} dipilih',
            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.midGrey),
          ),
        ],
      ),
    );
  }

  // ─── CART ITEM ───────────────────────────────────────────────────────────
  Widget _buildCartItem(CartItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              'Hapus',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => _removeItem(item),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Checkbox
              _buildCheckbox(
                value: item.selected,
                onChanged: (v) => setState(() => item.selected = v ?? false),
              ),
              const SizedBox(width: 10),
              // Product icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  size: 36,
                  color: item.color.withOpacity(0.80),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.variant,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          item.price,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const Spacer(),
                        // Qty stepper
                        _buildQtyStepper(item),
                      ],
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

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? AppColors.primaryBlue : AppColors.paleSky,
            width: 2,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.30),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: value
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
            : null,
      ),
    );
  }

  Widget _buildQtyStepper(CartItem item) {
    return Row(
      children: [
        _qtyBtn(
          icon: Icons.remove_rounded,
          onTap: () {
            if (item.qty > 1) {
              setState(() => item.qty--);
            } else {
              _removeItem(item);
            }
          },
          isRemove: item.qty == 1,
        ),
        Container(
          width: 32,
          alignment: Alignment.center,
          child: Text(
            '${item.qty}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
        ),
        _qtyBtn(
          icon: Icons.add_rounded,
          onTap: () => setState(() => item.qty++),
        ),
      ],
    );
  }

  Widget _qtyBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool isRemove = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isRemove
              ? Colors.red.shade50
              : AppColors.primaryBlue.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isRemove ? Colors.red.shade600 : AppColors.primaryBlue,
        ),
      ),
    );
  }

  // ─── COUPON SECTION ──────────────────────────────────────────────────────
  Widget _buildCouponSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_offer_rounded,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Kode Promo',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              if (_couponApplied) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Aktif',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.paleSky),
                  ),
                  child: TextField(
                    controller: _couponCtrl,
                    enabled: !_couponApplied,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode promo...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.midGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _couponApplied
                    ? () => setState(() {
                        _couponApplied = false;
                        _couponDiscount = 0;
                        _couponCtrl.clear();
                      })
                    : _applyCoupon,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: _couponApplied
                        ? Colors.red.shade50
                        : AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _couponApplied ? 'Hapus' : 'Pakai',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _couponApplied
                            ? Colors.red.shade600
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!_couponApplied)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '💡 Coba kode HEMAT50 untuk diskon Rp 50.000',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.midGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── PRICE SUMMARY ───────────────────────────────────────────────────────
  Widget _buildPriceSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Belanja',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow(
            'Subtotal (${_selectedItems.length} produk)',
            _fmt(_subtotal),
          ),
          const SizedBox(height: 8),
          _summaryRow('Ongkos Kirim', _shipping == 0 ? '-' : _fmt(_shipping)),
          if (_couponApplied) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Diskon Promo',
              '- ${_fmt(_couponDiscount)}',
              valueColor: const Color(0xFF2E7D32),
            ),
          ],
          const SizedBox(height: 14),
          Divider(height: 1, color: AppColors.paleSky),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Total Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              const Spacer(),
              Text(
                _fmt(_total),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.midGrey),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  // ─── CHECKOUT BAR ────────────────────────────────────────────────────────
  Widget _buildCheckoutBar() {
    final canCheckout = _selectedItems.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // Total mini
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Bayar',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.midGrey,
                    ),
                  ),
                  Text(
                    _fmt(_total),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Checkout button
              Expanded(
                child: GestureDetector(
                  onTap: canCheckout
                      ? () => _showSnack(
                          'Menuju halaman pembayaran... 🚀',
                          isSuccess: true,
                        )
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: canCheckout
                          ? const LinearGradient(
                              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                            )
                          : null,
                      color: canCheckout ? null : AppColors.paleSky,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: canCheckout
                          ? [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            canCheckout
                                ? 'Beli Sekarang (${_selectedItems.length})'
                                : 'Pilih produk dulu',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: canCheckout
                                  ? Colors.white
                                  : AppColors.midGrey,
                            ),
                          ),
                          if (canCheckout) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── EMPTY STATE ─────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Keranjang Kosong',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yuk tambahkan produk ke keranjang\ndan mulai belanja!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.midGrey,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Mulai Belanja',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
