import 'package:customer_shopping_menu/pages/product_detail_page.dart';
import 'package:customer_shopping_menu/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../services/cart_provider.dart';
import '../models/cart_model.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              final cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              cartProvider.clearCart();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  final List<CartItem> cartItems = cartProvider.cartItems;

                  return ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 4.0),
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final product = cartItem.product;

                      return Material(
                        //elevation: 4.0,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black, // Set the border color here
                              width: 1.0, // Set the border width here
                            ),
                          ),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                width: 80.0, // Specify the desired width
                                height: 80.0, // Specify the desired height
                                child: Image.network(
                                  product.images[0].fileURL,
                                  fit: BoxFit
                                      .cover, // Adjust the image fit as needed
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  '${product.actualPrice} VND',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    cartProvider.decreaseQuantity(cartItem);
                                  },
                                ),
                                Text('${cartItem.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    cartProvider.increaseQuantity(cartItem);
                                  },
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartProvider.removeFromCart(cartItem);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                final int totalItems = cartProvider.cartItems.length;
                final double totalPrice = cartProvider.calculateTotalPrice();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Items: $totalItems'),
                          const SizedBox(height: 8.0),
                          Text(
                              'Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final List<OrderProductDetail> orderProductDetails =
                              [];

                          for (final cartItem in cartProvider.cartItems) {
                            final product = cartItem.product;
                            final orderProductDetail = OrderProductDetail(
                              productMenuId: product
                                  .id, // Provide the appropriate ID for the product
                              productName: product.productName,
                              quantity: cartItem.quantity,
                              unitPrice: product.actualPrice.toInt(),
                            );
                            orderProductDetails.add(orderProductDetail);
                          }

                          final Order order = Order(
                            groupId: '3f2ad790-f0a7-4d28-95a9-a5031c121098',
                            customerName: 'Quang nổ db',
                            phoneNumber: '1234567890',
                            note: 'This is a sample order',
                            orderProductDetails: orderProductDetails,
                          );

                          final int statusCode =
                              await ApiService.createOrder(order);
                          if (statusCode == 201 || statusCode == 200) {
                            // Order created successfully
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Order Created'),
                                  content: Text(
                                      'Your order has been created successfully.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        cartProvider
                                            .clearCart(); // Clear the cart after successful order creation
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Error occurred while creating the order
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Order Error'),
                                  content: Text(
                                      'An error occurred while creating the order.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text('Confirm Cart'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
