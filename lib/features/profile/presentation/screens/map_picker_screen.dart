import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import 'address_data.dart';

class MapPickerScreen extends StatefulWidget {
  final AddressData? existing;
  const MapPickerScreen({super.key, this.existing});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();

  LatLng _pickedLocation = const LatLng(-6.2088, 106.8456);
  bool _isLocating = false;
  bool _isSaving = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _provinceCtrl;
  late TextEditingController _postalCtrl;

  String _selectedLabel = 'Rumah';
  final List<Map<String, dynamic>> _labelOptions = [
    {'label': 'Rumah', 'icon': Icons.home_rounded},
    {'label': 'Kantor', 'icon': Icons.business_rounded},
    {'label': 'Kos', 'icon': Icons.apartment_rounded},
    {'label': 'Lainnya', 'icon': Icons.location_on_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _phoneCtrl = TextEditingController(text: e?.phone ?? '');
    _addressCtrl = TextEditingController(text: e?.address ?? '');
    _cityCtrl = TextEditingController(text: e?.city ?? '');
    _provinceCtrl = TextEditingController(text: e?.province ?? '');
    _postalCtrl = TextEditingController(text: e?.postalCode ?? '');
    if (e != null) {
      _pickedLocation = LatLng(e.lat, e.lng);
      _selectedLabel = e.label;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  Future<void> _getMyLocation() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Layanan lokasi tidak aktif. Aktifkan GPS terlebih dahulu.');
        setState(() => _isLocating = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Izin lokasi ditolak.');
          setState(() => _isLocating = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showSnack('Izin lokasi ditolak permanen. Ubah di pengaturan.');
        setState(() => _isLocating = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));

      setState(() {
        _pickedLocation = LatLng(pos.latitude, pos.longitude);
        _isLocating = false;
      });
      _mapController.move(_pickedLocation, 16.0);
    } on TimeoutException {
      _showSnack('Gagal mendapatkan lokasi, coba lagi.');
      setState(() => _isLocating = false);
    } catch (e) {
      _showSnack('Error: $e');
      setState(() => _isLocating = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 12)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final labelData = _labelOptions.firstWhere(
      (l) => l['label'] == _selectedLabel,
      orElse: () => _labelOptions.first,
    );

    final result = AddressData(
      id:
          widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      label: _selectedLabel,
      icon: labelData['icon'] as IconData,
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      province: _provinceCtrl.text.trim(),
      postalCode: _postalCtrl.text.trim(),
      lat: _pickedLocation.latitude,
      lng: _pickedLocation.longitude,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [
          _buildMapSection(),
          Expanded(child: _buildFormSection()),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation,
              initialZoom: 15.0,
              onTap: (tapPos, latLng) {
                setState(() => _pickedLocation = latLng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.flutter_application_ecommerce',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 44,
                    height: 50,
                    child: _buildPin(),
                  ),
                ],
              ),
            ],
          ),

          // Back + title overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
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
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.charcoal,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.existing != null
                            ? 'Edit Lokasi Alamat'
                            : 'Pilih Lokasi di Peta',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Coordinate chip
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  '${_pickedLocation.latitude.toStringAsFixed(5)}, '
                  '${_pickedLocation.longitude.toStringAsFixed(5)}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Tap hint
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Ketuk peta untuk pilih lokasi',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ),

          // My location button
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: _getMyLocation,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _isLocating
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primaryBlue,
                        ),
                      )
                    : const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primaryBlue,
                        size: 22,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        CustomPaint(
          size: const Size(12, 6),
          painter: _TrianglePainter(AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _sectionLabel('Label Alamat'),
          _buildLabelSelector(),
          const SizedBox(height: 16),

          _sectionLabel('Informasi Penerima'),
          _buildCard([
            _buildField(
              controller: _nameCtrl,
              label: 'Nama Penerima',
              icon: Icons.person_outline_rounded,
              hint: 'Nama lengkap penerima',
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            _divider(),
            _buildField(
              controller: _phoneCtrl,
              label: 'Nomor HP',
              icon: Icons.phone_outlined,
              hint: '+62 8xx-xxxx-xxxx',
              keyboardType: TextInputType.phone,
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
          ]),
          const SizedBox(height: 14),

          _sectionLabel('Detail Alamat'),
          _buildCard([
            _buildField(
              controller: _addressCtrl,
              label: 'Jalan / Nama Jalan',
              icon: Icons.signpost_outlined,
              hint: 'Jl. Nama Jalan, No. Rumah',
              maxLines: 2,
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            _divider(),
            _buildField(
              controller: _cityCtrl,
              label: 'Kota / Kabupaten',
              icon: Icons.location_city_outlined,
              hint: 'Contoh: Jakarta Selatan',
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            _divider(),
            _buildField(
              controller: _provinceCtrl,
              label: 'Provinsi',
              icon: Icons.map_outlined,
              hint: 'Contoh: DKI Jakarta',
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            _divider(),
            _buildField(
              controller: _postalCtrl,
              label: 'Kode Pos',
              icon: Icons.markunread_mailbox_outlined,
              hint: '12345',
              keyboardType: TextInputType.number,
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
          ]),
          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSaving
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
                        const Icon(Icons.save_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Simpan Alamat',
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
    );
  }

  Widget _buildLabelSelector() {
    return Row(
      children: _labelOptions.map((opt) {
        final selected = _selectedLabel == opt['label'];
        return Expanded(
          child: GestureDetector(
            onTap: () =>
                setState(() => _selectedLabel = opt['label'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primaryBlue : AppColors.paleSky,
                  width: 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(
                    opt['icon'] as IconData,
                    color: selected ? Colors.white : AppColors.primaryBlue,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.midGrey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _divider() =>
      Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.paleSky);

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.charcoal,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.midGrey,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.midGrey.withOpacity(0.6),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 52,
            minHeight: 0,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          errorStyle: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.errorRed,
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
