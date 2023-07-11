class OrderModel {
  final String id;
  final int totalPrice;
  final String status;
  final String customerName;
  final String phoneNumber;
  final String note;
  final DateTime creationDate;
  final String paymentName;
  final String groupId;
  final String groupName;
  final List<OrderDetail> orderDetails;

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.customerName,
    required this.phoneNumber,
    required this.note,
    required this.creationDate,
    required this.paymentName,
    required this.groupId,
    required this.groupName,
    required this.orderDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> orderDetailsJson = json['orderDetails'];

    return OrderModel(
      id: json['id'],
      totalPrice: json['totalPrice'],
      status: json['status'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      note: json['note'],
      creationDate: DateTime.parse(json['creationDate']),
      paymentName: json['paymentName'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      orderDetails: orderDetailsJson
          .map((orderDetailJson) => OrderDetail.fromJson(orderDetailJson))
          .toList(),
    );
  }
}

class OrderDetail {
  final String productMenuId;
  final String productName;
  final int quantity;
  final int unitPrice;

  OrderDetail({
    required this.productMenuId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productMenuId: json['productMenuId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
    );
  }
}
