import 'package:ae_api/ae_api.dart';

class AeDsRecommendFeedGetResponse {
  final ProductsResult result;

  AeDsRecommendFeedGetResponse({required this.result});

  factory AeDsRecommendFeedGetResponse.fromJson(Map<String, dynamic> json) {
    return AeDsRecommendFeedGetResponse(
      result: ProductsResult.fromJson(
          json['aliexpress_ds_recommend_feed_get_response']['result']),
    );
  }
}

class ProductsResult {
  final int currentRecordCount;
  final int totalRecordCount;
  final bool isFinished;
  final List<Product>? products;

  ProductsResult(
      {required this.currentRecordCount,
      required this.totalRecordCount,
      required this.isFinished,
      required this.products});

  factory ProductsResult.fromJson(Map<String, dynamic> json) {
    return ProductsResult(
      currentRecordCount: json['current_record_count'],
      totalRecordCount: json['total_record_count'],
      isFinished: json['is_finished'],
      products: (json['products']['traffic_product_d_t_o'] as List?)
          ?.map((i) => Product.fromJson(i))
          .toList(),
    );
  }
}
