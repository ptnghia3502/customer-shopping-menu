import 'package:customer_shopping_menu/pages/menu_info.dart';
import 'package:customer_shopping_menu/pages/product_detail_page.dart';
import 'package:customer_shopping_menu/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../services/cart_provider.dart';
import '../models/cart_model.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();

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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  height: 340.0,
                                  width: 300.0,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text('Confirm Cart',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 16.0),
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                        ),
                                      ),
                                      TextField(
                                        controller: phoneController,
                                        decoration: const InputDecoration(
                                          labelText: 'Phone',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: noteController,
                                        maxLines:
                                            4, // Allow multiple lines of input
                                        decoration: const InputDecoration(
                                          labelText: 'Note',
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          const SizedBox(width: 8.0),
                                          TextButton(
                                            child: const Text('Confirm'),
                                            onPressed: () async {
                                              final List<OrderProductDetail>
                                                  orderProductDetails = [];

                                              for (final cartItem
                                                  in cartProvider.cartItems) {
                                                final product =
                                                    cartItem.product;
                                                final orderProductDetail =
                                                    OrderProductDetail(
                                                  productMenuId: product
                                                      .id, // Provide the appropriate ID for the product
                                                  productName:
                                                      product.productName,
                                                  quantity: cartItem.quantity,
                                                  unitPrice: product.actualPrice
                                                      .toInt(),
                                                );
                                                orderProductDetails
                                                    .add(orderProductDetail);
                                              }

                                              final Order order = Order(
                                                groupId:
                                                    MenuInfoPage.currentGroupId,
                                                customerName:
                                                    nameController.text,
                                                phoneNumber:
                                                    phoneController.text,
                                                note: noteController.text,
                                                orderProductDetails:
                                                    orderProductDetails,
                                              );

                                              final int statusCode =
                                                  await ApiService.createOrder(
                                                      order);
                                              if (statusCode == 201 ||
                                                  statusCode == 200) {
                                                // Order created successfully
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Order Created'),
                                                      content: Text(
                                                          'Your order has been created successfully.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            cartProvider
                                                                .clearCart();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                // Error occurred while creating the order
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Order Error'),
                                                      content: Text(
                                                          'An error occurred while creating the order.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
