import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:customer_shopping_menu/models/order_detail_model.dart';
import 'package:customer_shopping_menu/services/api_service.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: FutureBuilder<OrderModel>(
        future: ApiService.getOrderByOrderId(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to fetch order details: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final order = snapshot.data;
            if (order != null) {
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã đơn hàng: ${order.id}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Tên khách hàng: ${order.customerName}'),
                      Text('Số điện thoại: ${order.phoneNumber}'),
                      Text('Tổng giá tiền: ${order.totalPrice} VND'),
                      Text(
                        'Ngày đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.creationDate)}',
                      ),
                      Text('Thuộc nhóm: ${order.groupName}'),
                      Text('Loại giao dịch: ${order.paymentName}'),
                      Text('Ghi chú: ${order.note}'),
                      Text('Trạng thái: ${order.status}'),
                      const SizedBox(height: 16),
                      const Text(
                        'Danh sách sản phẩm đặt hàng:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.orderDetails.length,
                        itemBuilder: (context, index) {
                          final product = order.orderDetails[index];
                          return ListTile(
                            title: Text(product.productName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Số lượng: ${product.quantity}'),
                                Text(
                                    'Giá sản phẩm: ${product.unitPrice} VND / 1 sản phẩm'),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No order details available',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
