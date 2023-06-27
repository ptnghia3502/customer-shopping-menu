import 'package:flutter/material.dart';
import 'package:customer_shopping_menu/models/cart_model.dart';
import '../models/product_menu_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(ProductMenu product) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex] = CartItem(
          product: product,
          quantity: _cartItems[existingItemIndex].quantity + 1);
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }

    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void increaseQuantity(CartItem cartItem) {
    final index = _cartItems.indexOf(cartItem);
    _cartItems[index] = CartItem(
      product: cartItem.product,
      quantity: cartItem.quantity + 1,
    );
    notifyListeners();
  }

  void decreaseQuantity(CartItem cartItem) {
    final index = _cartItems.indexOf(cartItem);
    if (cartItem.quantity > 1) {
      _cartItems[index] = CartItem(
        product: cartItem.product,
        quantity: cartItem.quantity - 1,
      );
      notifyListeners();
    } else {
      removeFromCart(cartItem);
    }
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in _cartItems) {
      totalPrice += cartItem.product.actualPrice * cartItem.quantity;
    }
    return totalPrice;
  }
}
