import 'package:ae_api/src/models/order.dart';

/// Represents the result of getting order information.
class OrdersResult {
  final String currentRecordCount;
  final List<Order> orders;

  OrdersResult({required this.currentRecordCount, required this.orders});

  factory OrdersResult.fromJson(Map<String, dynamic> json) {
    return OrdersResult(
      currentRecordCount: json['current_record_count'],
      orders: (json['orders'] as List).map((i) => Order.fromJson(i)).toList(),
    );
  }
}
