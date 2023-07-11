import 'package:customer_shopping_menu/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:customer_shopping_menu/pages/menu_info.dart';
import 'package:customer_shopping_menu/utils/footer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Hệ Thống Mua Hàng Online"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add your notification logic here
              },
            ),
          ],
        ),

        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  Center(
                    child: Container(
                      child: Text("Hello world! This is home page."),
                    ),
                  ),
                  ProviderScope(
                    child: MenuInfoPage(groupId: null),
                  ),
                  OrderPage(),
                  CartPage(),
                  CartPage(),
                ],
              ),
            ),
          ],
        ),
        // drawer: AppDrawer(),
        bottomNavigationBar: AppFooter(
          currentIndex: _currentPageIndex,
          onTap: _navigateToPage,
          pageController: _pageController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
