class Order {
  String groupId;
  String customerName;
  String phoneNumber;
  String note;
  List<OrderProductDetail> orderProductDetails;

  Order({
    required this.groupId,
    required this.customerName,
    required this.phoneNumber,
    required this.note,
    required this.orderProductDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'note': note,
      'orderProductDetails':
          orderProductDetails.map((detail) => detail.toJson()).toList(),
    };
  }
}

class OrderProductDetail {
  String productMenuId;
  String productName;
  int quantity;
  int unitPrice;

  OrderProductDetail({
    required this.productMenuId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'productMenuId': productMenuId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}
