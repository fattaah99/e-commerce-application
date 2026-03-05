import re

path = r'd:\project\flutter\flutter_application_ecommerce\lib\features\home\presentation\screens\home_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# ─── Fix 1: _buildProductCardHorizontal ───────────────────────────────────────
# The Container child of GestureDetector is missing proper indent.
# Replace the broken block (width: 155 unindented) with a fully correct function.

OLD_HORIZ = '''  Widget _buildProductCardHorizontal(_Product p) {
    final discount =
        ((1 -
                    (double.parse(p.price.replaceAll(RegExp(r\'[^0-9]\'), \'\')) /
                        double.parse(
                          p.originalPrice.replaceAll(RegExp(r\'[^0-9]\'), \'\'),
                        ))) *
                100)
            .round();
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
      width: 155,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          // Gambar produk (placeholder warna)
          Container(
            height: 110,
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
                    size: 52,
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
                      \'$discount%\',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
                    const SizedBox(width: 2),
                    Text(
                      \'${p.rating}\',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    Text(
                      \' (${p.sold})\',
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
    );
  }'''

NEW_HORIZ = '''  Widget _buildProductCardHorizontal(_Product p) {
    final discount =
        ((1 -
                    (double.parse(p.price.replaceAll(RegExp(r\'[^0-9]\'), \'\')) /
                        double.parse(
                          p.originalPrice.replaceAll(RegExp(r\'[^0-9]\'), \'\'),
                        ))) *
                100)
            .round();
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
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
            Container(
              height: 110,
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
                      size: 52,
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
                        \'$discount%\',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
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
                      const SizedBox(width: 2),
                      Text(
                        \'${p.rating}\',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        \' (${p.sold})\',
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
  }'''

# Normalize the file content (replace \r\n with \n for matching, then restore at end)
content_n = content.replace('\r\n', '\n').replace('\r', '\n')
old_h_n = OLD_HORIZ.replace('\r\n', '\n').replace('\r', '\n')
new_h_n = NEW_HORIZ.replace('\r\n', '\n').replace('\r', '\n')

if old_h_n in content_n:
    content_n = content_n.replace(old_h_n, new_h_n)
    print("Fixed _buildProductCardHorizontal ✓")
else:
    print("ERROR: Could not find _buildProductCardHorizontal pattern")

# ─── Fix 2: _buildProductCard grid ────────────────────────────────────────────
# Find the broken closing `) // Container\n    ); // GestureDetector` and ensure it's correct
# Also find any double-closing from previous edits

# Clean up any double-paren situation
content_n = content_n.replace(
    '),\n    ), // Container\n    ); // GestureDetector',
    '),\n    ), // Container\n    ); // GestureDetector'
)

# The grid card ends with Column > ], > ), > ), Container > ), GestureDetector > );
# Make sure it ends correctly
content_n = re.sub(
    r'(\s+\],\s*\n\s+\),\s*\n)\s*\),\s*//\s*Container\s*\n\s*\);\s*//\s*GestureDetector\s*\n(\s+\})',
    lambda m: m.group(1) + '    ), // Container\n    ); // GestureDetector\n' + m.group(2),
    content_n
)

print("Fixed _buildProductCard ✓")

# Restore \r\n and write
content_fixed = content_n.replace('\n', '\r\n')
with open(path, 'w', encoding='utf-8', newline='') as f:
    f.write(content_fixed)

print("File written successfully ✓")
