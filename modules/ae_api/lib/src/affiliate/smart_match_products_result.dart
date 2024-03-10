import 'package:ae_api/ae_api.dart';

class SmartMatchProductsResult {
  final String? currentRecordCount;
  final int? currentPageNo;
  final List<Product>? products;

  SmartMatchProductsResult({
    required this.currentRecordCount,
    required this.currentPageNo,
    required this.products,
  });

  factory SmartMatchProductsResult.fromJson(Map<String, dynamic> json) {
    return SmartMatchProductsResult(
      currentRecordCount: json['current_record_count'],
      currentPageNo: json['current_page_no'],
      products: (json["products"]?["product"] as List?)
          ?.map((x) => Product.fromJson(x))
          .toList(),
    );
  }
}
