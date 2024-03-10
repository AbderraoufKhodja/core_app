import 'package:ae_api/ae_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'hot_products_response.freezed.dart';
part 'hot_products_response.g.dart';

@freezed
class HotProductsResponse with _$HotProductsResponse {
  const factory HotProductsResponse({
    @JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
    AliexpressAffiliateHotproductQueryResponse?
        aliexpressAffiliateHotproductQueryResponse,
  }) = _HotProductsResponse;

  factory HotProductsResponse.fromJson(Map<String, Object?> json) =>
      _$HotProductsResponseFromJson(json);
}

@freezed
class AliexpressAffiliateHotproductQueryResponse
    with _$AliexpressAffiliateHotproductQueryResponse {
  const factory AliexpressAffiliateHotproductQueryResponse({
    @JsonKey(name: 'resp_result') RespResult? respResult,
    @JsonKey(name: 'request_id') String? requestId,
  }) = _AliexpressAffiliateHotproductQueryResponse;

  factory AliexpressAffiliateHotproductQueryResponse.fromJson(
          Map<String, Object?> json) =>
      _$AliexpressAffiliateHotproductQueryResponseFromJson(json);
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
    @JsonKey(name: 'total_record_count') int? totalRecordCount,
    @JsonKey(name: 'current_page_no') int? currentPageNo,
    @JsonKey(name: 'products') Products? products,
  }) = _Result;

  factory Result.fromJson(Map<String, Object?> json) => _$ResultFromJson(json);
}
