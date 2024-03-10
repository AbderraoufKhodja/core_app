import 'package:ae_api/ae_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'featured_promo_products_response.freezed.dart';
part 'featured_promo_products_response.g.dart';

@freezed
class FeaturedPromoProductsResponse with _$FeaturedPromoProductsResponse {
  const factory FeaturedPromoProductsResponse({
    @JsonKey(name: 'aliexpress_affiliate_featuredpromo_products_get_response')
    AliexpressAffiliateFeaturedpromoProductsGetResponse?
        aliexpressAffiliateFeaturedpromoProductsGetResponse,
  }) = _FeaturedPromoProductsResponse;

  factory FeaturedPromoProductsResponse.fromJson(Map<String, Object?> json) =>
      _$FeaturedPromoProductsResponseFromJson(json);
}

@freezed
class AliexpressAffiliateFeaturedpromoProductsGetResponse
    with _$AliexpressAffiliateFeaturedpromoProductsGetResponse {
  const factory AliexpressAffiliateFeaturedpromoProductsGetResponse({
    @JsonKey(name: 'resp_result') RespResult? respResult,
    @JsonKey(name: 'request_id') String? requestId,
  }) = _AliexpressAffiliateFeaturedpromoProductsGetResponse;

  factory AliexpressAffiliateFeaturedpromoProductsGetResponse.fromJson(
          Map<String, Object?> json) =>
      _$AliexpressAffiliateFeaturedpromoProductsGetResponseFromJson(json);
}

@freezed
class RespResult with _$RespResult {
  const factory RespResult({
    @JsonKey(name: 'result') Result? result,
    @JsonKey(name: 'resp_code') int? respCode,
  }) = _RespResult;

  factory RespResult.fromJson(Map<String, Object?> json) =>
      _$RespResultFromJson(json);
}

@freezed
class Result with _$Result {
  const factory Result({
    @JsonKey(name: 'current_record_count') int? currentRecordCount,
    @JsonKey(name: 'total_record_count') int? totalRecordCount,
    @JsonKey(name: 'is_finished') bool? isFinished,
    @JsonKey(name: 'products') Products? products,
  }) = _Result;

  factory Result.fromJson(Map<String, Object?> json) => _$ResultFromJson(json);
}
