const fs = require('fs');

// ── 1. main.dart: add circuit route ─────────────────────────────────────────
const mainPath = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\main.dart';
let main = fs.readFileSync(mainPath, 'utf8').replace(/\r\n/g, '\n');

const OLD_MAIN_IMPORT = "import 'features/product/presentation/screens/product_list_screen.dart';";
const NEW_MAIN_IMPORT = `import 'features/product/presentation/screens/product_list_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';`;

if (main.includes(OLD_MAIN_IMPORT)) {
    main = main.replace(OLD_MAIN_IMPORT, NEW_MAIN_IMPORT);
    console.log('✓ Added cart import to main.dart');
}

const OLD_ROUTE = "        '/products': (context) => const ProductListScreen(),";
const NEW_ROUTE = `        '/products': (context) => const ProductListScreen(),
        '/cart': (context) => const CartScreen(),`;

if (main.includes(OLD_ROUTE)) {
    main = main.replace(OLD_ROUTE, NEW_ROUTE);
    console.log('✓ Added /cart route');
}

fs.writeFileSync(mainPath, main.replace(/\n/g, '\r\n'), 'utf8');

// ── 2. home_screen.dart: wire cart icon ──────────────────────────────────────
const homePath = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\features\\\\home\\\\presentation\\\\screens\\\\home_screen.dart';
let home = fs.readFileSync(homePath, 'utf8').replace(/\r\n/g, '\n');

// Add cart import
const OLD_HOME_IMPORT = "import '../../../product/presentation/screens/product_list_screen.dart';";
const NEW_HOME_IMPORT = `import '../../../product/presentation/screens/product_list_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';`;
if (home.includes(OLD_HOME_IMPORT)) {
    home = home.replace(OLD_HOME_IMPORT, NEW_HOME_IMPORT);
    console.log('✓ Added cart import to home_screen.dart');
}

// Wire the cart icon onPressed in header (shopping_cart_outlined with onPressed: () {})
// There's one cart button in _buildHeader
const OLD_CART_BTN = "                onPressed: () {},\n                icon: Stack(\n                  clipBehavior: Clip.none,\n                  children: [\n                    const Icon(\n                      Icons.shopping_cart_outlined,";
const NEW_CART_BTN = `                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,`;
if (home.includes(OLD_CART_BTN)) {
    home = home.replace(OLD_CART_BTN, NEW_CART_BTN);
    console.log('✓ Wired cart icon in home header');
}

fs.writeFileSync(homePath, home.replace(/\n/g, '\r\n'), 'utf8');

// ── 3. product_list_screen.dart: wire cart icon ──────────────────────────────
const listPath = 'd:\\\\project\\\\flutter\\\\flutter_application_ecommerce\\\\lib\\\\features\\\\product\\\\presentation\\\\screens\\\\product_list_screen.dart';
let list = fs.readFileSync(listPath, 'utf8').replace(/\r\n/g, '\n');

// Add cart import
const OLD_LIST_IMPORT = "import 'product_detail_screen.dart';";
const NEW_LIST_IMPORT = `import 'product_detail_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';`;
if (list.includes(OLD_LIST_IMPORT)) {
    list = list.replace(OLD_LIST_IMPORT, NEW_LIST_IMPORT);
    console.log('✓ Added cart import to product_list_screen.dart');
}

// Wire cart icon (shopping_cart_outlined onPressed: () {} in _buildStickyHeader)
const OLD_LIST_CART = `                    // Cart icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shopping_cart_outlined,`;
const NEW_LIST_CART = `                    // Cart icon
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                      icon: const Icon(
                        Icons.shopping_cart_outlined,`;
if (list.includes(OLD_LIST_CART)) {
    list = list.replace(OLD_LIST_CART, NEW_LIST_CART);
    console.log('✓ Wired cart icon in product list');
}

fs.writeFileSync(listPath, list.replace(/\n/g, '\r\n'), 'utf8');

console.log('✓ All done!');
