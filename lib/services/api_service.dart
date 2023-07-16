import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/group_model.dart';
import '../models/order_detail_model.dart';
import '../models/order_model.dart';
import '../models/product_menu_model.dart';

class ApiService {
  // static const String baseUrl =
  //     'https://vouch-tour-apis.azurewebsites.net/api/';
  static const String baseUrl = 'https://vouch-tour.azurewebsites.net/api/';

  // ========================= MENU API ==============================
  //get all item in menu
  static Future<List<ProductMenu>> fetchProductsInMenu(String menuId) async {
    final url = Uri.parse('${baseUrl}menus/$menuId/products-menu');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => ProductMenu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products in menu');
    }
  }

// ========================= GROUPS API ==============================
// Get group by id
  static Future<Group> getGroupById(String id) async {
    final url = Uri.parse('${baseUrl}groups/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> groupJson = json.decode(response.body);
      return Group.fromJson(groupJson);
    } else {
      throw Exception('Failed to fetch group');
    }
  }

// ========================= ORDERS API ==============================
  static Future<int> createOrder(Order order) async {
    final url = Uri.parse('${baseUrl}orders');
    final body = jsonEncode(order.toJson());

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response.statusCode;
  }

  // Get Order detail by order id
  static Future<OrderModel> getOrderByOrderId(String orderId) async {
    final url = Uri.parse('${baseUrl}orders/$orderId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final orderJson = json.decode(response.body);
      return OrderModel.fromJson(orderJson);
    } else {
      throw Exception('Failed to fetch order details');
    }
  }

  // Get Orders by Phone Number
  static Future<List<OrderModel>> getOrdersByPhone(String phoneNumber) async {
    final url = Uri.parse('${baseUrl}customers/$phoneNumber/orders');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic responseBody = json.decode(response.body);

      if (responseBody is Map) {
        final orderJson = responseBody
            as Map<String, dynamic>; // Cast to Map<String, dynamic>
        final order = OrderModel.fromJson(orderJson);
        return [order]; // Return a list with the single order
      } else if (responseBody is List) {
        final ordersJson =
            responseBody as List<dynamic>; // Cast to List<dynamic>
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch orders');
    }
  }
}
