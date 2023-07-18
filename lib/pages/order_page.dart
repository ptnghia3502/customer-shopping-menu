import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/order_detail_model.dart';
import 'order_detail_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  Future<void> _getOrdersByPhone() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String phoneNumber = _phoneNumberController.text.trim();
      List<OrderModel> orders = await ApiService.getOrdersByPhone(phoneNumber);
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Error: $e');
      _orders = [];
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra thông tin đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Số điện thọai',
              ),
              onSubmitted: (_) => _getOrdersByPhone(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _getOrdersByPhone,
              child: const Text('Kiểm tra đơn hàng'),
            ),
            const SizedBox(height: 16.0),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_orders.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    OrderModel order = _orders[index];
                    return ListTile(
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailPage(orderId: order.id),
                            ),
                          );
                        },
                        child: Text(
                          'Mã đơn hàng: ${order.id}',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tên khách hàng: ${order.customerName}'),
                          Text('Số điện thoại: ${order.phoneNumber}'),
                          Text('Tổng giá tiền: ${order.totalPrice} VND'),
                          Text(
                            'Ngày đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.creationDate)}',
                          ),
                          Text('Trạng thái: ${order.status}'),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text('Không tìm thấy đơn hàng nào.'),
              ),
          ],
        ),
      ),
    );
  }
}
