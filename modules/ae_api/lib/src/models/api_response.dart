import 'package:ae_api/affiliate_api.dart';

class ApiResponse {
  final String code;
  final RespResult respResult;
  final String requestId;

  ApiResponse({required this.code, required this.respResult, required this.requestId});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      respResult: RespResult.fromJson(json['resp_result']),
      requestId: json['request_id'],
    );
  }
}
