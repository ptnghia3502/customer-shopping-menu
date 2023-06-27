import '../models/product_menu_model.dart';

class CartItem {
  final ProductMenu product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}
