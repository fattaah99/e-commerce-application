import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'alamat_pengiriman_screen.dart';
import 'belum_bayar_screen.dart';
import 'dikemas_screen.dart';
import 'dikirim_screen.dart';
import 'edit_profile_screen.dart';
import 'metode_pembayaran_screen.dart';
import 'penilaian_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Mock order counts
  final int _belumBayar = 2;
  final int _dikemas = 1;
  final int _dikirim = 3;
  final int _penilaian = 4;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
              // ── Header / Hero Section ──
              SliverToBoxAdapter(child: _buildHero()),

              // ── Order Status Cards ──
              SliverToBoxAdapter(child: _buildOrderStatus()),

              // ── Menu Akun ──
              SliverToBoxAdapter(
                child: _buildMenuSection('Akun Saya', [
                  _MenuItem(
                    Icons.person_outline_rounded,
                    'Edit Profil',
                    'Ubah nama, foto, dan informasi akun',
                    null,
                  ),
                  _MenuItem(
                    Icons.location_on_outlined,
                    'Alamat Pengiriman',
                    'Kelola alamat pengiriman',
                    null,
                  ),
                  _MenuItem(
                    Icons.credit_card_rounded,
                    'Metode Pembayaran',
                    'Kartu, dompet digital & transfer',
                    null,
                  ),
                  _MenuItem(
                    Icons.wallet_rounded,
                    'BelanjaId Pay',
                    'Saldo: Rp 350.000',
                    const Color(0xFF1565C0),
                  ),
                ]),
              ),

              // ── Menu Lainnya ──
              SliverToBoxAdapter(
                child: _buildMenuSection('Lainnya', [
                  _MenuItem(
                    Icons.headset_mic_rounded,
                    'Pusat Bantuan',
                    'Hubungi customer service kami',
                    null,
                  ),
                  _MenuItem(
                    Icons.star_outline_rounded,
                    'Beri Rating Aplikasi',
                    'Bantu kami menjadi lebih baik',
                    null,
                  ),
                  _MenuItem(
                    Icons.shield_outlined,
                    'Privasi & Keamanan',
                    'Kelola data dan keamanan akun',
                    null,
                  ),
                  _MenuItem(
                    Icons.notifications_none_rounded,
                    'Notifikasi',
                    'Atur preferensi notifikasi',
                    null,
                  ),
                ]),
              ),

              // ── Logout ──
              SliverToBoxAdapter(child: _buildLogout()),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  // ── HERO ──
  Widget _buildHero() {
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
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Profil Saya',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatar + Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                  child: Row(
                    children: [
                      // Avatar stack
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.60),
                                width: 2.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 14,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengguna BelanjaId',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_rounded,
                                  color: Colors.white70,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '+62 812-xxxx-xxxx',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.80),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Member badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFC107,
                                ).withOpacity(0.20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFC107,
                                  ).withOpacity(0.60),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.workspace_premium_rounded,
                                    color: Color(0xFFFFC107),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Member Silver',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFFFC107),
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

                // Stats row
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('12', 'Pesanan'),
                      _buildStatDivider(),
                      _buildStat('5', 'Ulasan'),
                      _buildStatDivider(),
                      _buildStat('8', 'Wishlist'),
                      _buildStatDivider(),
                      _buildStat('3', 'Voucher'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white.withOpacity(0.80),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.25),
    );
  }

  // ── ORDER STATUS ──
  Widget _buildOrderStatus() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan Saya',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Lihat Semua',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOrderStep(
                  icon: Icons.receipt_long_rounded,
                  label: 'Belum\nBayar',
                  count: _belumBayar,
                  color: const Color(0xFFFF7043),
                  bgColor: const Color(0xFFFFF3F0),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BelumBayarScreen()),
                  ),
                ),
                _buildOrderArrow(),
                _buildOrderStep(
                  icon: Icons.inventory_2_rounded,
                  label: 'Dikemas',
                  count: _dikemas,
                  color: const Color(0xFF7B1FA2),
                  bgColor: const Color(0xFFF8F0FF),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DikemasScreen()),
                  ),
                ),
                _buildOrderArrow(),
                _buildOrderStep(
                  icon: Icons.local_shipping_rounded,
                  label: 'Dikirim',
                  count: _dikirim,
                  color: const Color(0xFF1976D2),
                  bgColor: const Color(0xFFEBF3FF),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DikirimScreen()),
                  ),
                ),
                _buildOrderArrow(),
                _buildOrderStep(
                  icon: Icons.rate_review_rounded,
                  label: 'Penilaian',
                  count: _penilaian,
                  color: const Color(0xFF388E3C),
                  bgColor: const Color(0xFFEDF7EE),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PenilaianScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStep({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              if (count > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.charcoal,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderArrow() {
    return const Icon(
      Icons.chevron_right_rounded,
      color: Color(0xFFCFD8DC),
      size: 20,
    );
  }

  // ── MENU SECTION ──
  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.midGrey,
                letterSpacing: 0.3,
              ),
            ),
          ),
          ...items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    if (item.title == 'Edit Profil') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    } else if (item.title == 'Alamat Pengiriman') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AlamatPengirimanScreen(),
                        ),
                      );
                    } else if (item.title == 'Metode Pembayaran') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MetodePembayaranScreen(),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (item.accentColor ?? AppColors.primaryBlue)
                                .withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.accentColor ?? AppColors.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.charcoal,
                                ),
                              ),
                              Text(
                                item.subtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.midGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.midGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 18,
                    color: AppColors.paleSky,
                  ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── LOGOUT ──
  Widget _buildLogout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                'Keluar dari Akun',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? accentColor;
  const _MenuItem(this.icon, this.title, this.subtitle, this.accentColor);
}
