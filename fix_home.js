const fs = require('fs');
const path = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\features\\\\home\\\\presentation\\\\screens\\\\home_screen.dart';

let content = fs.readFileSync(path, 'utf8').replace(/\r\n/g, '\n');

// 1. Add product_list_screen import after product_detail_screen import
const oldImport = "import '../../../product/presentation/screens/product_detail_screen.dart';";
const newImport = "import '../../../product/presentation/screens/product_detail_screen.dart';\nimport '../../../product/presentation/screens/product_list_screen.dart';";
if (content.includes(oldImport)) {
    content = content.replace(oldImport, newImport);
    console.log('✓ Added product_list_screen import');
} else {
    console.log('? Import already exists or not found');
}

// 2. Wire the Lihat Semua button in _buildSectionTitle  
const oldTap = "onTap: () {},\n            child: Text(\n              action,";
const newTap = "onTap: () => Navigator.push(\n              context,\n              PageRouteBuilder(\n                pageBuilder: (ctx, anim, _) => const ProductListScreen(),\n                transitionsBuilder: (ctx, anim, _, child) => SlideTransition(\n                  position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)\n                      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),\n                  child: child,\n                ),\n                transitionDuration: const Duration(milliseconds: 320),\n              ),\n            ),\n            child: Text(\n              action,";

if (content.includes(oldTap)) {
    content = content.replace(oldTap, newTap);
    console.log('✓ Wired Lihat Semua navigation');
} else {
    console.log('? Could not find Lihat Semua onTap pattern');
    // Show context
    const idx = content.indexOf('action,');
    if (idx > -1) console.log('Context:', JSON.stringify(content.substring(idx - 100, idx + 60)));
}

content = content.replace(/\n/g, '\r\n');
fs.writeFileSync(path, content, 'utf8');
console.log('✓ File written');
