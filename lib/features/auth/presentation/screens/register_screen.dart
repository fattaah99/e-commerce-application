import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/gradient_button.dart';
import '../widgets/social_login_button.dart';
import 'phone_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _phoneNumber = '';
  String _countryCode = '+62';
  bool _isPhoneValid = false;
  bool _isGoogleLoading = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isGoogleLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isGoogleLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Daftar dengan Google akan terhubung ke Firebase',
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
    }
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Masukkan nomor telepon yang valid',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap setujui Syarat & Ketentuan terlebih dahulu',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, _) =>
            PhoneOtpScreen(phoneNumber: '$_countryCode$_phoneNumber'),
        transitionsBuilder: (ctx, animation, _, child) => SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            // ── Hero biru atas ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.32,
              child: ClipPath(
                clipper: _RoundedBottomClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0D47A1),
                        Color(0xFF1565C0),
                        Color(0xFF1E88E5),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── Inner glow ──
            Positioned(
              top: -size.height * 0.06,
              right: -size.width * 0.1,
              child: Container(
                width: size.width * 0.70,
                height: size.width * 0.70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.06,
              left: -size.width * 0.12,
              child: Container(
                width: size.width * 0.50,
                height: size.width * 0.50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.07),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // ── Decorative bubbles ──
            _bubble(
              top: -28,
              left: -28,
              size: 120,
              border: Colors.white.withOpacity(0.15),
            ),
            _bubble(
              top: -18,
              right: -18,
              size: 100,
              border: Colors.white.withOpacity(0.12),
            ),
            _bubble(
              top: 28,
              left: 18,
              size: 50,
              color: Colors.white.withOpacity(0.08),
            ),
            _bubble(
              top: 45,
              right: 32,
              size: 60,
              border: Colors.white.withOpacity(0.18),
            ),
            _bubble(
              top: 18,
              right: 75,
              size: 16,
              color: Colors.white.withOpacity(0.22),
            ),
            _bubble(
              top: 95,
              left: 55,
              size: 13,
              color: Colors.white.withOpacity(0.18),
            ),
            _bubble(
              top: 135,
              left: 28,
              size: 7,
              color: Colors.white.withOpacity(0.30),
            ),
            _bubble(
              top: 75,
              left: -8,
              size: 45,
              border: Colors.white.withOpacity(0.13),
            ),
            _bubble(
              top: 120,
              right: 46,
              size: 9,
              color: AppColors.skyBlue.withOpacity(0.45),
            ),
            _bubble(
              top: 8,
              left: size.width * 0.4,
              size: 28,
              color: Colors.white.withOpacity(0.09),
            ),
            _bubble(
              top: 55,
              left: size.width * 0.44,
              size: 5,
              color: Colors.white.withOpacity(0.35),
            ),

            // ── Soft glow bawah ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: size.height * 0.25,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.iceBlue, AppColors.white],
                  ),
                ),
              ),
            ),

            // ── Main content ──
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Header section
                        SizedBox(
                          height: size.height * 0.22,
                          child: Stack(
                            children: [
                              // Back button
                              Positioned(
                                top: 4,
                                left: 8,
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Container(
                                    width: 38,
                                    height: 38,
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
                              ),
                              // Logo + title centered
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.18,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.shopping_bag_rounded,
                                        color: AppColors.primaryBlue,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'BelanjaId',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Card section ──
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.10),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Buat Akun Baru 🎉',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Daftar dan mulai belanja sekarang!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.midGrey,
                                  ),
                                ),
                                const SizedBox(height: 22),

                                // Google Register
                                SocialLoginButton(
                                  text: 'Daftar dengan Google',
                                  onPressed: _isGoogleLoading
                                      ? null
                                      : _handleGoogleRegister,
                                  icon: _isGoogleLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primaryBlue,
                                          ),
                                        )
                                      : Image.network(
                                          'https://www.google.com/favicon.ico',
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.g_mobiledata_rounded,
                                                color: AppColors.primaryBlue,
                                                size: 24,
                                              ),
                                        ),
                                ),

                                const SizedBox(height: 18),

                                // Divider
                                _buildDivider(),

                                const SizedBox(height: 18),

                                // Nama Lengkap
                                _fieldLabel('Nama Lengkap'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _nameCtrl,
                                  hint: 'Masukkan nama lengkap Anda',
                                  prefixIcon: Icons.person_outline_rounded,
                                  validator: (v) => v!.trim().isEmpty
                                      ? 'Nama wajib diisi'
                                      : null,
                                ),

                                const SizedBox(height: 14),

                                // Email
                                _fieldLabel('Email'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _emailCtrl,
                                  hint: 'contoh@email.com',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v!.trim().isEmpty)
                                      return 'Email wajib diisi';
                                    if (!RegExp(
                                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$',
                                    ).hasMatch(v.trim())) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                // Nomor Telepon
                                _fieldLabel('Nomor Telepon'),
                                const SizedBox(height: 8),
                                IntlPhoneField(
                                  decoration: InputDecoration(
                                    hintText: '812 3456 7890',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppColors.midGrey,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
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
                                    counterText: '',
                                  ),
                                  initialCountryCode: 'ID',
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.charcoal,
                                  ),
                                  onChanged: (phone) {
                                    setState(() {
                                      _phoneNumber = phone.number;
                                      _countryCode = phone.countryCode;
                                      _isPhoneValid = phone.number.length >= 8;
                                    });
                                  },
                                  onCountryChanged: (country) {
                                    setState(() {
                                      _countryCode = '+${country.dialCode}';
                                    });
                                  },
                                ),

                                const SizedBox(height: 14),

                                // Password
                                _fieldLabel('Kata Sandi'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _passCtrl,
                                  hint: 'Minimal 8 karakter',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePass,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.midGrey,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscurePass = !_obscurePass,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty)
                                      return 'Kata sandi wajib diisi';
                                    if (v.length < 8)
                                      return 'Minimal 8 karakter';
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                // Konfirmasi Password
                                _fieldLabel('Konfirmasi Kata Sandi'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _confirmPassCtrl,
                                  hint: 'Ulangi kata sandi',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscureConfirm,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.midGrey,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty)
                                      return 'Konfirmasi kata sandi wajib diisi';
                                    if (v != _passCtrl.text)
                                      return 'Kata sandi tidak cocok';
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Checkbox Syarat
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _agreeToTerms,
                                        activeColor: AppColors.primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        onChanged: (v) =>
                                            setState(() => _agreeToTerms = v!),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: AppColors.midGrey,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'Saya menyetujui ',
                                            ),
                                            TextSpan(
                                              text: 'Syarat & Ketentuan',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: AppColors.primaryBlue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const TextSpan(text: ' dan '),
                                            TextSpan(
                                              text: 'Kebijakan Privasi',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: AppColors.primaryBlue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // Register button
                                GradientButton(
                                  text: 'Daftar Sekarang',
                                  icon: Icons.person_add_rounded,
                                  onPressed: _isLoading
                                      ? () {}
                                      : _handleRegister,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun? ',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.midGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Masuk',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper widgets ──

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.paleSky)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'atau',
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.midGrey),
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColors.paleSky)),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.charcoal),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.midGrey),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryBlue, size: 20),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
        errorStyle: GoogleFonts.poppins(
          fontSize: 11,
          color: AppColors.errorRed,
        ),
      ),
    );
  }

  // Shorthand bubble helper
  Widget _bubble({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    Color? color,
    Color? border,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: border != null ? Border.all(color: border, width: 1.5) : null,
        ),
      ),
    );
  }
}

class _RoundedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 48);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height + 28,
      size.width,
      size.height - 48,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
