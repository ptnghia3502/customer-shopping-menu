import 'package:customer_shopping_menu/pages/home_page.dart';

import '../pages/menu_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var appRoutes = {
  "/": (context) => HomePage(),
  "/home": (context) => HomePage(),
  "/menu-info": (context) => ProviderScope(child: MenuInfoPage()),
};
