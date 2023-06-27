import 'package:flutter/material.dart';
import 'package:customer_shopping_menu/routes/routes.dart';
import 'package:customer_shopping_menu/themes/theme.dart';
import 'package:customer_shopping_menu/services/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: customLightTheme,
        darkTheme: customDarkTheme,
        initialRoute: "/",
        routes: appRoutes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
