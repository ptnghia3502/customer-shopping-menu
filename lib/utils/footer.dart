import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final PageController pageController;

  const AppFooter({
    required this.currentIndex,
    required this.onTap,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFF3F3F3),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, 'Giới thiệu', 0, context),
            _buildBottomNavItem(Icons.menu_book, 'Menu', 1, context),
            _buildBottomNavItem(Icons.shopping_cart, 'Giỏ hàng', 2, context),
            _buildBottomNavItem(Icons.inventory_2, 'Đơn hàng', 3, context),
            _buildBottomNavItem(Icons.qr_code, 'QR Code', 4, context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      IconData icon, String label, int index, BuildContext context) {
    final color = currentIndex == index ? Colors.blue : Colors.black;
    final themeData = Theme.of(context);
    final labelStyle = themeData.textTheme.caption?.copyWith(color: color);

    return InkWell(
      onTap: () {
        onTap(index);
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: labelStyle),
        ],
      ),
    );
  }
}
