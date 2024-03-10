import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'featured_promo_response.freezed.dart';
part 'featured_promo_response.g.dart';

@freezed
class FeaturedPromoResponse with _$FeaturedPromoResponse {
  const factory FeaturedPromoResponse({
    @JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
    AliexpressAffiliateFeaturedpromoGetResponse?
        aliexpressAffiliateFeaturedpromoGetResponse,
  }) = _FeaturedPromoResponse;

  factory FeaturedPromoResponse.fromJson(Map<String, Object?> json) =>
      _$FeaturedPromoResponseFromJson(json);
}

@freezed
class AliexpressAffiliateFeaturedpromoGetResponse
    with _$AliexpressAffiliateFeaturedpromoGetResponse {
  const factory AliexpressAffiliateFeaturedpromoGetResponse({
    @JsonKey(name: 'resp_result') RespResult? respResult,
    @JsonKey(name: 'request_id') String? requestId,
  }) = _AliexpressAffiliateFeaturedpromoGetResponse;

  factory AliexpressAffiliateFeaturedpromoGetResponse.fromJson(
          Map<String, Object?> json) =>
      _$AliexpressAffiliateFeaturedpromoGetResponseFromJson(json);
}

@freezed
class RespResult with _$RespResult {
  const factory RespResult({
    @JsonKey(name: 'result') Result? result,
    @JsonKey(name: 'resp_code') int? respCode,
    @JsonKey(name: 'resp_msg') String? respMsg,
  }) = _RespResult;

  factory RespResult.fromJson(Map<String, Object?> json) =>
      _$RespResultFromJson(json);
}

@freezed
class Result with _$Result {
  const factory Result({
    @JsonKey(name: 'current_record_count') int? currentRecordCount,
    @JsonKey(name: 'promos') Promos? promos,
  }) = _Result;

  factory Result.fromJson(Map<String, Object?> json) => _$ResultFromJson(json);
}

@freezed
class Promos with _$Promos {
  const factory Promos({
    @JsonKey(name: 'promo') List<Promo>? promo,
  }) = _Promos;

  factory Promos.fromJson(Map<String, Object?> json) => _$PromosFromJson(json);
}

@freezed
class Promo with _$Promo {
  const factory Promo({
    @JsonKey(name: 'promo_name') String? promoName,
    @JsonKey(name: 'promo_desc') String? promoDesc,
    @JsonKey(name: 'product_num') int? productNum,
  }) = _Promo;

  factory Promo.fromJson(Map<String, Object?> json) => _$PromoFromJson(json);
}
