import 'package:ae_api/src/affiliate/smart_match_products_result.dart';

class SmartMatchProductsResponse {
  final String? code;
  final String? respCode;
  final String? respMsg;
  final SmartMatchProductsResult? result;

  SmartMatchProductsResponse({
    required this.code,
    required this.respCode,
    required this.respMsg,
    required this.result,
  });

  factory SmartMatchProductsResponse.fromJson(Map<String, dynamic> jsonResult) {
    final json = jsonResult['aliexpress_affiliate_product_smartmatch_response'];
    return SmartMatchProductsResponse(
      code: json['code'],
      respCode: json['resp_code'],
      respMsg: json['resp_msg'],
      result: json['resp_result']?['result'] != null
          ? SmartMatchProductsResult.fromJson(json['resp_result']['result'])
          : null,
    );
  }
}
