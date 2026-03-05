const fs = require('fs');
const filePath = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\features\\\\product\\\\presentation\\\\screens\\\\product_list_screen.dart';

let content = fs.readFileSync(filePath, 'utf8').replace(/\r\n/g, '\n');

// ── Find and replace _buildSliverAppBar ──────────────────────────────────────
// We look for the method start and its closing `}` after _buildCategoryBar call.
// Replace the entire _buildSliverAppBar + _buildSearchBar + _buildCategoryBar block.

const OLD_APP_BAR_START = `  // ─── SLIVER APP BAR ──────────────────────────────────────────────────────
  Widget _buildSliverAppBar(bool innerScrolled) {
    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
              child: _buildSearchBar(),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: _buildCategoryBar(),
      ),
    );
  }`;

const NEW_APP_BAR_START = `  // ─── SLIVER APP BAR (search + category always pinned) ──────────────────
  Widget _buildSliverAppBar(bool innerScrolled) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      toolbarHeight: 0,   // hide default toolbar; everything goes in bottom
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(106),   // 58 search + 48 chips
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Top row: back + search + cart/bell ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                      // Search bar
                      Expanded(child: _buildSearchBar()),
                      // Cart
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ],
                  ),
                ),
                // ── Category chips ──
                _buildCategoryBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }`;

if (content.includes(OLD_APP_BAR_START)) {
    content = content.replace(OLD_APP_BAR_START, NEW_APP_BAR_START);
    console.log('✓ Replaced _buildSliverAppBar');
} else {
    console.log('ERROR: Could not find _buildSliverAppBar');
    process.exit(1);
}

// ── Also update _buildSearchBar: remove the filter button since we're in a tight row ──
// Keep filter icon but remove margin to fit better in the row
const OLD_SEARCH = `  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 0),
          ),
        ],
      ),`;

const NEW_SEARCH = `  Widget _buildSearchBar() {
    return Container(
      height: 42,
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
      ),`;

if (content.includes(OLD_SEARCH)) {
    content = content.replace(OLD_SEARCH, NEW_SEARCH);
    console.log('✓ Updated _buildSearchBar height');
} else {
    console.log('? Could not find OLD_SEARCH — trying fallback');
    // Try without offset variant
    const OLD_SEARCH2 = `  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),`;
    const NEW_SEARCH2 = `  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),`;
    if (content.includes(OLD_SEARCH2)) {
        content = content.replace(OLD_SEARCH2, NEW_SEARCH2);
        console.log('✓ Updated _buildSearchBar (fallback)');
    } else {
        console.log('ERROR: Could not find search bar block either');
    }
}

content = content.replace(/\n/g, '\r\n');
fs.writeFileSync(filePath, content, 'utf8');
console.log('✓ File saved');
