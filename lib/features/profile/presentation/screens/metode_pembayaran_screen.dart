import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

// ─── Data models ────────────────────────────────────────────────────────────

class _SavedCard {
  final String id;
  final String holder;
  final String number; // last-4 only stored for display
  final String expiry;
  final String network; // 'visa' | 'mastercard' | 'jcb'
  final List<Color> gradient;

  const _SavedCard({
    required this.id,
    required this.holder,
    required this.number,
    required this.expiry,
    required this.network,
    required this.gradient,
  });
}

class _Wallet {
  final String name;
  final IconData icon;
  final Color color;
  String balance;
  bool linked;

  _Wallet({
    required this.name,
    required this.icon,
    required this.color,
    required this.balance,
    required this.linked,
  });
}

class _BankOption {
  final String name;
  final String accountNo;
  final Color color;
  final IconData icon;

  const _BankOption({
    required this.name,
    required this.accountNo,
    required this.color,
    required this.icon,
  });
}

// ─── Screen ─────────────────────────────────────────────────────────────────

class MetodePembayaranScreen extends StatefulWidget {
  const MetodePembayaranScreen({super.key});

  @override
  State<MetodePembayaranScreen> createState() => _MetodePembayaranScreenState();
}

class _MetodePembayaranScreenState extends State<MetodePembayaranScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  String _selectedPaymentId = 'card_1'; // currently selected method id

  final List<_SavedCard> _cards = [
    _SavedCard(
      id: 'card_1',
      holder: 'Budi Santoso',
      number: '4521',
      expiry: '08/27',
      network: 'visa',
      gradient: const [Color(0xFF1565C0), Color(0xFF0D47A1)],
    ),
    _SavedCard(
      id: 'card_2',
      holder: 'Budi Santoso',
      number: '5890',
      expiry: '12/26',
      network: 'mastercard',
      gradient: const [Color(0xFF6A1B9A), Color(0xFF4527A0)],
    ),
  ];

  final List<_Wallet> _wallets = [
    _Wallet(
      name: 'GoPay',
      icon: Icons.electric_rickshaw_rounded,
      color: const Color(0xFF00AED6),
      balance: 'Rp 250.000',
      linked: true,
    ),
    _Wallet(
      name: 'OVO',
      icon: Icons.account_balance_wallet_rounded,
      color: const Color(0xFF4C3494),
      balance: 'Rp 100.000',
      linked: true,
    ),
    _Wallet(
      name: 'Dana',
      icon: Icons.wallet_rounded,
      color: const Color(0xFF118EEA),
      balance: 'Belum terhubung',
      linked: false,
    ),
    _Wallet(
      name: 'ShopeePay',
      icon: Icons.shopping_bag_rounded,
      color: const Color(0xFFEE4D2D),
      balance: 'Belum terhubung',
      linked: false,
    ),
  ];

  final List<_BankOption> _banks = const [
    _BankOption(
      name: 'BCA Virtual Account',
      accountNo: '8277-xxxx-xxxx',
      color: Color(0xFF006CB7),
      icon: Icons.account_balance_rounded,
    ),
    _BankOption(
      name: 'Mandiri Virtual Account',
      accountNo: '8879-xxxx-xxxx',
      color: Color(0xFF003D8F),
      icon: Icons.account_balance_rounded,
    ),
    _BankOption(
      name: 'BRI Virtual Account',
      accountNo: '2698-xxxx-xxxx',
      color: Color(0xFF00529B),
      icon: Icons.account_balance_rounded,
    ),
    _BankOption(
      name: 'BNI Virtual Account',
      accountNo: '9888-xxxx-xxxx',
      color: Color(0xFF006F51),
      icon: Icons.account_balance_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddCardSheet(
        onAdd: (card) {
          setState(() => _cards.add(card));
        },
      ),
    );
  }

  void _deleteCard(_SavedCard card) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Kartu',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          'Hapus kartu **** ${card.number} dari akun Anda?',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: AppColors.midGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _cards.removeWhere((c) => c.id == card.id);
                if (_selectedPaymentId == card.id) {
                  _selectedPaymentId = _cards.isNotEmpty ? _cards.first.id : '';
                }
              });
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: AppColors.errorRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

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
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cards section
                    _sectionHeader(
                      'Kartu Kredit / Debit',
                      Icons.credit_card_rounded,
                    ),
                    _buildCardCarousel(),
                    _buildAddCardButton(),

                    const SizedBox(height: 8),

                    // Wallet section
                    _sectionHeader('Dompet Digital', Icons.wallet_rounded),
                    _buildWalletSection(),

                    const SizedBox(height: 8),

                    // Bank transfer section
                    _sectionHeader(
                      'Transfer Bank',
                      Icons.account_balance_rounded,
                    ),
                    _buildBankSection(),

                    const SizedBox(height: 32),

                    // Save button
                    _buildSaveButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 75,
      centerTitle: false,
      backgroundColor: AppColors.primaryBlue,
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
            'Metode Pembayaran',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            'Kelola metode pembayaran Anda',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withOpacity(0.80),
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

  // ── Section header ───────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.iceBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  // ── Credit card carousel ──────────────────────────────────────────────────

  Widget _buildCardCarousel() {
    if (_cards.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.paleSky, width: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.credit_card_off_rounded,
                color: AppColors.midGrey,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                'Belum ada kartu tersimpan',
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
    return SizedBox(
      height: 185,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _cards.length,
        itemBuilder: (_, i) => _buildCreditCard(_cards[i]),
      ),
    );
  }

  Widget _buildCreditCard(_SavedCard card) {
    final selected = _selectedPaymentId == card.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentId = card.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 260,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: card.gradient,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: card.gradient.first.withOpacity(selected ? 0.5 : 0.3),
              blurRadius: selected ? 18 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Chip icon
                      Container(
                        width: 34,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: CustomPaint(painter: _ChipPainter()),
                      ),
                      // Network logo
                      _buildNetworkBadge(card.network),
                    ],
                  ),
                  const Spacer(),
                  // Card number masked
                  Text(
                    '**** **** **** ${card.number}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pemegang Kartu',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            card.holder,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Berlaku Hingga',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            card.expiry,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Delete button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _deleteCard(card),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Selected checkmark
            if (selected)
              Positioned(
                bottom: 12,
                right: 14,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryBlue,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkBadge(String network) {
    switch (network) {
      case 'mastercard':
        return Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB001B),
              ),
            ),
            Transform.translate(
              offset: const Offset(-8, 0),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF79E1B).withOpacity(0.85),
                ),
              ),
            ),
          ],
        );
      case 'jcb':
        return Text(
          'JCB',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        );
      default: // visa
        return Text(
          'VISA',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        );
    }
  }

  // ── Add card button ──────────────────────────────────────────────────────

  Widget _buildAddCardButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: OutlinedButton.icon(
        onPressed: _showAddCardSheet,
        icon: const Icon(
          Icons.add_card_rounded,
          color: AppColors.primaryBlue,
          size: 20,
        ),
        label: Text(
          'Tambah Kartu Baru',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: AppColors.iceBlue,
        ),
      ),
    );
  }

  // ── Wallets ──────────────────────────────────────────────────────────────

  Widget _buildWalletSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: _wallets.asMap().entries.map((e) {
          final i = e.key;
          final w = e.value;
          return Column(
            children: [
              _buildWalletTile(w),
              if (i < _wallets.length - 1)
                Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 16,
                  color: AppColors.paleSky,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWalletTile(_Wallet wallet) {
    final selected = _selectedPaymentId == 'wallet_${wallet.name}';
    return InkWell(
      onTap: () {
        if (!wallet.linked) {
          _showLinkWalletDialog(wallet);
          return;
        }
        setState(() => _selectedPaymentId = 'wallet_${wallet.name}');
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: wallet.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(wallet.icon, color: wallet.color, size: 22),
            ),
            const SizedBox(width: 14),
            // Name + balance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  Text(
                    wallet.linked
                        ? wallet.balance
                        : 'Ketuk untuk menghubungkan',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: wallet.linked
                          ? AppColors.successGreen
                          : AppColors.midGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Status badge / radio
            if (!wallet.linked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.iceBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Hubungkan',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.primaryBlue : AppColors.midGrey,
                    width: 2,
                  ),
                  color: selected ? AppColors.primaryBlue : Colors.white,
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  void _showLinkWalletDialog(_Wallet wallet) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hubungkan ${wallet.name}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          'Fitur menghubungkan ${wallet.name} akan tersedia setelah integrasi API.\nMau coba demo?',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: AppColors.midGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                wallet.linked = true;
                wallet.balance = 'Rp 0';
                _selectedPaymentId = 'wallet_${wallet.name}';
              });
            },
            child: Text(
              'Hubungkan',
              style: GoogleFonts.poppins(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bank transfer ────────────────────────────────────────────────────────

  Widget _buildBankSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: _banks.asMap().entries.map((e) {
          final i = e.key;
          final b = e.value;
          return Column(
            children: [
              _buildBankTile(b),
              if (i < _banks.length - 1)
                Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 16,
                  color: AppColors.paleSky,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBankTile(_BankOption bank) {
    final id = 'bank_${bank.name}';
    final selected = _selectedPaymentId == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentId = id),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bank.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(bank.icon, color: bank.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  Text(
                    bank.accountNo,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.midGrey,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primaryBlue : AppColors.midGrey,
                  width: 2,
                ),
                color: selected ? AppColors.primaryBlue : Colors.white,
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ── Save/Confirm button ──────────────────────────────────────────────────

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedPaymentId.isEmpty
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Metode pembayaran berhasil disimpan!',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      backgroundColor: AppColors.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                'Simpan Metode Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add Card Bottom Sheet ────────────────────────────────────────────────────

class _AddCardSheet extends StatefulWidget {
  final void Function(_SavedCard card) onAdd;
  const _AddCardSheet({required this.onAdd});

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _obscureCvv = true;
  String _network = 'visa';

  final List<Map<String, dynamic>> _gradientOptions = [
    {
      'colors': [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
      'label': 'Biru',
    },
    {
      'colors': [const Color(0xFF6A1B9A), const Color(0xFF4527A0)],
      'label': 'Ungu',
    },
    {
      'colors': [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
      'label': 'Hijau',
    },
    {
      'colors': [const Color(0xFFB71C1C), const Color(0xFF880E4F)],
      'label': 'Merah',
    },
    {
      'colors': [const Color(0xFF37474F), const Color(0xFF212121)],
      'label': 'Gelap',
    },
  ];
  int _selectedGradient = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  String _detectNetwork(String num) {
    if (num.startsWith('4')) return 'visa';
    if (num.startsWith('5') || num.startsWith('2')) return 'mastercard';
    if (num.startsWith('35')) return 'jcb';
    return 'visa';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final rawNum = _numberCtrl.text.replaceAll(' ', '');
    final last4 = rawNum.length >= 4
        ? rawNum.substring(rawNum.length - 4)
        : rawNum;
    final card = _SavedCard(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      holder: _nameCtrl.text.trim(),
      number: last4,
      expiry: _expiryCtrl.text.trim(),
      network: _network,
      gradient: List<Color>.from(
        _gradientOptions[_selectedGradient]['colors'] as List,
      ),
    );
    widget.onAdd(card);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F6FB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.midGrey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Tambah Kartu Baru',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const Spacer(),
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
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  // Card preview
                  _buildCardPreview(),
                  const SizedBox(height: 20),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sheetLabel('Pilih Warna Kartu'),
                        const SizedBox(height: 8),
                        _buildGradientPicker(),
                        const SizedBox(height: 16),

                        _sheetLabel('Nama Pemegang Kartu'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _nameCtrl,
                          hint: 'Sesuai nama di kartu',
                          icon: Icons.person_outline_rounded,
                          validator: (v) =>
                              v!.trim().isEmpty ? 'Wajib diisi' : null,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),

                        _sheetLabel('Nomor Kartu'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _numberCtrl,
                          hint: '0000 0000 0000 0000',
                          icon: Icons.credit_card_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _CardNumberFormatter(),
                          ],
                          validator: (v) {
                            final clean = v!.replaceAll(' ', '');
                            if (clean.length < 13)
                              return 'Nomor kartu tidak valid';
                            return null;
                          },
                          onChanged: (v) {
                            setState(() {
                              _network = _detectNetwork(v.replaceAll(' ', ''));
                            });
                          },
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sheetLabel('Masa Berlaku'),
                                  const SizedBox(height: 8),
                                  _buildField(
                                    controller: _expiryCtrl,
                                    hint: 'MM/YY',
                                    icon: Icons.calendar_today_outlined,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _ExpiryFormatter(),
                                    ],
                                    validator: (v) {
                                      if (v!.length < 5) return 'Format MM/YY';
                                      return null;
                                    },
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sheetLabel('CVV'),
                                  const SizedBox(height: 8),
                                  _buildField(
                                    controller: _cvvCtrl,
                                    hint: '•••',
                                    icon: Icons.lock_outline_rounded,
                                    keyboardType: TextInputType.number,
                                    obscureText: _obscureCvv,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureCvv
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColors.midGrey,
                                        size: 18,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscureCvv = !_obscureCvv,
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v!.length < 3) return 'Min 3 digit';
                                      return null;
                                    },
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_card_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Simpan Kartu',
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
          ],
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    final colors = _gradientOptions[_selectedGradient]['colors'] as List<Color>;
    final name = _nameCtrl.text.trim().isEmpty
        ? 'NAMA PEMEGANG'
        : _nameCtrl.text.trim().toUpperCase();
    final raw = _numberCtrl.text.replaceAll(' ', '');
    final last4 = raw.length >= 4 ? raw.substring(raw.length - 4) : '****';
    final expiry = _expiryCtrl.text.isEmpty ? 'MM/YY' : _expiryCtrl.text;

    return Container(
      height: 175,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 34,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomPaint(painter: _ChipPainter()),
                    ),
                    Text(
                      _network.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontStyle: _network == 'visa'
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '**** **** **** $last4',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pemegang Kartu',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Berlaku Hingga',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          expiry,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientPicker() {
    return Row(
      children: _gradientOptions.asMap().entries.map((e) {
        final selected = _selectedGradient == e.key;
        final colors = e.value['colors'] as List<Color>;
        return GestureDetector(
          onTap: () => setState(() => _selectedGradient = e.key),
          child: Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.charcoal : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: selected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _sheetLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.charcoal,
    ),
  );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.charcoal),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.midGrey),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.paleSky, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.paleSky, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 11,
          color: AppColors.errorRed,
        ),
      ),
    );
  }
}

// ─── Chip painter ─────────────────────────────────────────────────────────────

class _ChipPainter extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = Colors.amber.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
      const Radius.circular(4),
    );
    canvas.drawRRect(rRect, paint);
    // horizontal lines
    canvas.drawLine(
      Offset(2, size.height / 2),
      Offset(size.width - 2, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2, 2),
      Offset(size.width / 2, size.height - 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ChipPainter old) => false;
}

// ─── Input formatters ────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final limited = digits.length > 16 ? digits.substring(0, 16) : digits;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(limited[i]);
    }
    final str = buffer.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    final limited = digits.length > 4 ? digits.substring(0, 4) : digits;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(limited[i]);
    }
    final str = buffer.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}
