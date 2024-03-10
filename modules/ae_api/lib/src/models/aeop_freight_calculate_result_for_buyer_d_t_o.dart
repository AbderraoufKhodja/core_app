// Define the model class for the response

import 'package:ae_api/src/models/freight.dart';

class AeopFreightCalculateResultForBuyerDTO {
  // Declare the fields
  final String? serviceName;
  final String? estimatedDeliveryTime;
  final Freight? freight;
  final String? errorCode;
  final bool? trackingAvailable;

  // Define the constructor
  AeopFreightCalculateResultForBuyerDTO(
      {this.serviceName,
      this.estimatedDeliveryTime,
      this.freight,
      this.errorCode,
      this.trackingAvailable});

  // Define a factory method to create an instance from JSON
  factory AeopFreightCalculateResultForBuyerDTO.fromJson(Map<String, dynamic> json) {
    return AeopFreightCalculateResultForBuyerDTO(
      serviceName: json['service_name'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      freight: Freight.fromJson(json['freight']),
      errorCode: json['error_code'],
      trackingAvailable: json['tracking_available'],
    );
  }
}
