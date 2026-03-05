const fs = require('fs');
const path = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\features\\\\product\\\\presentation\\\\screens\\\\product_list_screen.dart';

let content = fs.readFileSync(path, 'utf8').replace(/\r\n/g, '\n');

// Replace _buildStoreSection with a single featured store card
const OLD = `  // ─── STORE SECTION ───────────────────────────────────────────────────────
  Widget _buildStoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              const Icon(
                Icons.storefront_rounded,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Toko Pilihan',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showStores = !_showStores),
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
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _stores.length,
            itemBuilder: (_, i) => _buildStoreCard(_stores[i]),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildStoreCard(_StoreData s) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: s.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(s.icon, color: s.color, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      s.location,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.midGrey,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 11,
                          color: Color(0xFFFFC107),
                        ),
                        Text(
                          ' \${s.rating}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\${s.products} produk',
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
      ),
    );
  }`;

const NEW = `  // ─── STORE SECTION (single featured store) ─────────────────────────────
  Widget _buildStoreSection() {
    final s = _stores.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_rounded, color: AppColors.primaryBlue, size: 18),
              const SizedBox(width: 6),
              Text('Toko Pilihan',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.charcoal)),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  // Store avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: s.color.withOpacity(0.12),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                    ),
                    child: Center(child: Icon(s.icon, size: 44, color: s.color.withOpacity(0.85))),
                  ),
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(s.name,
                                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.charcoal)),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('Official',
                                    style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primaryBlue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 12, color: AppColors.midGrey),
                              Text(' \${s.location}  •  \${s.category}',
                                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.midGrey)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFC107)),
                              Text(' \${s.rating}',
                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.charcoal)),
                              Text('  •  \${s.products} produk',
                                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.midGrey)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Kunjungi',
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryBlue)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }`;

if (content.includes(OLD)) {
    content = content.replace(OLD, NEW);
    console.log('✓ Replaced store section with single featured store card');
} else {
    console.log('ERROR: Could not find old store section');
}

content = content.replace(/\n/g, '\r\n');
fs.writeFileSync(path, content, 'utf8');
console.log('✓ File saved');
