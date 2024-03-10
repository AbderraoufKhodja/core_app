// Define the model class for the response

import 'package:ae_api/src/models/aeop_result.dart';

class FreightCalculateResponse {
  // Declare the fields
  final String? code;
  final String? requestId;
  final AeopResult? result;

  // Define the constructor
  FreightCalculateResponse({this.code, this.requestId, this.result});

  // Define a factory method to create an instance from JSON
  factory FreightCalculateResponse.fromJson(Map<String, dynamic> json) {
    return FreightCalculateResponse(
      code: json['code'],
      requestId: json['request_id'],
      result: AeopResult.fromJson(json['result']),
    );
  }
}
