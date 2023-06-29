import 'package:flutter/material.dart';
import 'package:customer_shopping_menu/themes/theme.dart';
import 'package:customer_shopping_menu/services/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'pages/home_page.dart';
import 'pages/menu_info.dart';
import 'pages/cart_page.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

void main() {
  configureApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: customLightTheme,
        darkTheme: customDarkTheme,
        initialRoute: "/",
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(
              builder: (context) => HomePage(),
            );
          } else if (settings.name!.startsWith('/menu')) {
            final groupId = settings.name!.split('&id=')[1];
            return MaterialPageRoute(
              builder: (context) => ProviderScope(
                child: MenuInfoPage(groupId: groupId),
              ),
            );
          } else if (settings.name == CartPage.routeName) {
            return MaterialPageRoute(
              builder: (context) => CartPage(),
            );
          }
          return null;
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
