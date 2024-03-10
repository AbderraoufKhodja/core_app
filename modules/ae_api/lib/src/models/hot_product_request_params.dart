import 'package:freezed_annotation/freezed_annotation.dart';

part 'hot_product_request_params.freezed.dart';
part 'hot_product_request_params.g.dart';

@freezed
class HotProductRequestParams with _$HotProductRequestParams {
  factory HotProductRequestParams({
    /// List of category ID, you can get category ID via "get category" API
    @JsonKey(name: 'category_ids') String? categoryIds,

    /// Respond parameter list, eg: commission_rate,sale_price
    String? fields,

    /// Filter products by keywords. eg: mp3
    String? keywords,

    /// Filter products by highest price, unit cent
    @JsonKey(name: 'max_sale_price') num? maxSalePrice,

    /// Filter products by lowest price, unit cent
    @JsonKey(name: 'min_sale_price') num? minSalePrice,

    /// Page number
    @JsonKey(name: 'page_no') String? pageNo,

    /// Record count of each page, 1 - 50
    @JsonKey(name: 'page_size') String? pageSize,

    /// product type：ALL,PLAZA,TMALL
    @JsonKey(name: 'platform_product_type') String? platformProductType,

    /// sort by:SALE_PRICE_ASC, SALE_PRICE_DESC, LAST_VOLUME_ASC, LAST_VOLUME_DESC
    String? sort,

    /// target currency:USD, GBP, CAD, EUR, UAH, MXN, TRY, RUB, BRL, AUD, INR, JPY, IDR, SEK,KRW
    @JsonKey(name: 'target_currency') String? targetCurrency,

    /// target language:EN,RU,PT,ES,FR,ID,IT,TH,JA,AR,VI,TR,DE,HE,KO,NL,PL,MX,CL,IW,IN
    @JsonKey(name: 'target_language') String? targetLanguage,

    /// Your trackingID
    @JsonKey(name: 'tracking_id') String? trackingId,

    /// Estimated delivery days. 3：in 3 days，5：in 5 days，7：in 7 days，10：in 10 days
    @JsonKey(name: 'delivery_days') String? deliveryDays,

    /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
    @JsonKey(name: 'ship_to_country') String? shipToCountry,
  }) = _RequestParams;

  factory HotProductRequestParams.fromJson(Map<String, dynamic> json) =>
      _$HotProductRequestParamsFromJson(json);
}
