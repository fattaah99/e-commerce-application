const fs = require('fs');
const filePath = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\features\\\\product\\\\presentation\\\\screens\\\\product_list_screen.dart';

let content = fs.readFileSync(filePath, 'utf8').replace(/\r\n/g, '\n');

// ── 1. Replace build() method to use Scaffold.appBar instead of NestedScrollView ──
const OLD_BUILD = `  // ════════════════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: NestedScrollView(
            controller: _scrollCtrl,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(innerBoxIsScrolled),
            ],
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Store section ──
                if (_showStores && _query.isEmpty)
                  SliverToBoxAdapter(child: _buildStoreSection()),

                // ── Filter + Sort row ──
                SliverToBoxAdapter(child: _buildFilterRow()),

                // ── Product count ──
                SliverToBoxAdapter(child: _buildResultHeader()),

                // ── Products ──
                if (_isGrid) _buildProductGrid() else _buildProductList(),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }`;

const NEW_BUILD = `  // ════════════════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        // ── Sticky header: gradient bar with search + category chips ──────────
        appBar: _buildStickyHeader(),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Store section ──
              if (_showStores && _query.isEmpty)
                SliverToBoxAdapter(child: _buildStoreSection()),

              // ── Filter + Sort row ──
              SliverToBoxAdapter(child: _buildFilterRow()),

              // ── Product count ──
              SliverToBoxAdapter(child: _buildResultHeader()),

              // ── Products ──
              if (_isGrid) _buildProductGrid() else _buildProductList(),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }`;

if (content.includes(OLD_BUILD)) {
    content = content.replace(OLD_BUILD, NEW_BUILD);
    console.log('✓ Replaced build()');
} else {
    console.log('ERROR: Could not find build() body');
    process.exit(1);
}

// ── 2. Replace _buildSliverAppBar with _buildStickyHeader (PreferredSizeWidget) ──
const OLD_APPBAR = `  // ─── SLIVER APP BAR (search + category always pinned) ──────────────────
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

const NEW_APPBAR = `  // ─── STICKY HEADER (always pinned — search + category chips) ────────────
  PreferredSizeWidget _buildStickyHeader() {
    // Total height = statusBar + top-row (58) + category chips (48)
    final statusH = MediaQuery.of(context).padding.top;
    return PreferredSize(
      preferredSize: Size.fromHeight(statusH + 106),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
          ),
          boxShadow: [
            BoxShadow(color: Color(0x281565C0), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Row: back button + search bar + cart ──
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Row(
                  children: [
                    // Back
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                    // Search bar (expands to fill space)
                    Expanded(child: _buildSearchBar()),
                    // Cart icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ],
                ),
              ),
              // ── Category filter chips ──
              _buildCategoryBar(),
            ],
          ),
        ),
      ),
    );
  }`;

if (content.includes(OLD_APPBAR)) {
    content = content.replace(OLD_APPBAR, NEW_APPBAR);
    console.log('✓ Replaced _buildSliverAppBar with _buildStickyHeader');
} else {
    console.log('ERROR: Could not find _buildSliverAppBar');
    process.exit(1);
}

content = content.replace(/\n/g, '\r\n');
fs.writeFileSync(filePath, content, 'utf8');
console.log('✓ File saved successfully');
