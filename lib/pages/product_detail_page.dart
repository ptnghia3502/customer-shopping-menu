import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../models/product_menu_model.dart';
import '../services/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductMenu product;

  const ProductDetailPage({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: const Color(0xFFE8F6FB),
              child: Image.network(
                product.images[0].fileURL,
                fit: BoxFit.cover,
                // width: double.infinity,
                // height: 200,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Name: ${product.productName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ).copyWith(color: const Color(0xFF843667)),
                  ),
                  const Gap(12),

                  // RatingBar and review code
                  Row(
                    children: [
                      RatingBar(
                        itemSize: 20,
                        initialRating: 4,
                        minRating: 1,
                        maxRating: 5,
                        allowHalfRating: true,
                        ratingWidget: RatingWidget(
                          empty: const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          ),
                          full: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          half: const Icon(
                            Icons.star_half_sharp,
                            color: Colors.amber,
                          ),
                        ),
                        onRatingUpdate: (value) => null,
                      ),
                      const Gap(20),
                      const Text('4953 review')
                    ],
                  ),

                  const Gap(16),
                  const Text(
                    'Mô tả sản phẩm:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(4),
                  Text(product.description),
                  const Gap(40),

                  Row(
                    children: [
                      const Text(
                        'Nhà cung cấp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Text(product.supplierName),
                    ],
                  ),

                  const Gap(8),
                  Row(
                    children: [
                      const Text(
                        'Địa chỉ:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Text(product.address),
                    ],
                  ),
                  const Gap(20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giá niêm yết: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product.supplierPrice} VND',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giá phân phối:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product.actualPrice} VND',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF843667),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        final cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        cartProvider.addToCart(product);
                      },
                      child: const Text('Thêm sản phẩm vào giỏ hàng'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
