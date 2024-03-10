import 'package:ae_api/src/models/resp_result.dart';

class CategoryResponse {
  final String code;
  final JsonSerializable respResult;
  final String requestId;

  CategoryResponse({required this.code, required this.respResult, required this.requestId});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      code: json['code'],
      respResult: JsonSerializable.fromJson(json['resp_result']),
      requestId: json['request_id'],
    );
  }
}
