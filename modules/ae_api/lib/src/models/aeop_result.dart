// Define the model class for the response

import 'package:ae_api/src/models/aeop_freight_calculate_result_for_buyer_d_t_o.dart';

class AeopResult {
  // Declare the fields
  final String? errorCode;
  final String? errorDesc;
  final bool? success;
  final List<AeopFreightCalculateResultForBuyerDTO>? aeopFreightCalculateResultForBuyerDTOList;

  // Define the constructor
  AeopResult(
      {this.errorCode,
      this.errorDesc,
      this.success,
      this.aeopFreightCalculateResultForBuyerDTOList});

  // Define a factory method to create an instance from JSON
  factory AeopResult.fromJson(Map<String, dynamic> json) {
    return AeopResult(
      errorCode: json['error_code'],
      errorDesc: json['error_desc'],
      success: json['success'],
      aeopFreightCalculateResultForBuyerDTOList:
          (json['aeop_freight_calculate_result_for_buyer_d_t_o_list'] as List)
              .map((e) => AeopFreightCalculateResultForBuyerDTO.fromJson(e))
              .toList(),
    );
  }
}
