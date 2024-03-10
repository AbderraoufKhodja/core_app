import 'package:freezed_annotation/freezed_annotation.dart';

part 'featured_promo_products_request_params.freezed.dart';
part 'featured_promo_products_request_params.g.dart';

@freezed
class FeaturedPromoProductsRequestParams
    with _$FeaturedPromoProductsRequestParams {
  factory FeaturedPromoProductsRequestParams({
    /// you can get category ID via "get category" API
    @JsonKey(name: 'category_id') String? categoryId,

    /// Respond parameter list, eg: commission_rate,sale_price
    String? fields,

    /// Filter products by keywords. eg: mp3
    String? keywords,

    /// Filter products by highest price, unit cent
    @JsonKey(name: 'max_sale_price') String? maxSalePrice,

    /// Filter products by lowest price, unit cent
    @JsonKey(name: 'min_sale_price') String? minSalePrice,

    /// Page number
    @JsonKey(name: 'page_no') String? pageNo,

    /// Record count of each page, 1 - 50
    @JsonKey(name: 'page_size') String? pageSize,

    /// End time of promotion, PST time
    @JsonKey(name: 'promotion_end_time') String? promotionEndTime,

    /// Promotion name, you can get Promotion name via "get featuredpromo info" API. eg. "Hot Product", "New Arrival", "Best Seller", "weeklydeals"
    @JsonKey(name: 'promotion_name') required String promotionName,

    /// Start time of promotion, PST time
    @JsonKey(name: 'promotion_start_time') String? promotionStartTime,

    /// sort by:SALE_PRICE_ASC, SALE_PRICE_DESC, LAST_VOLUME_ASC, LAST_VOLUME_DESC
    String? sort,

    /// target currency:USD, GBP, CAD, EUR, UAH, MXN, TRY, RUB, BRL, AUD, INR, JPY, IDR, SEK,KRW
    @JsonKey(name: 'target_currency') String? targetCurrency,

    /// target language:EN,RU,PT,ES,FR,ID,IT,TH,JA,AR,VI,TR,DE,HE,KO,NL,PL,MX,CL,IW,IN
    @JsonKey(name: 'target_language') String? targetLanguage,

    /// Your trackingID
    @JsonKey(name: 'tracking_id') String? trackingId,

    /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
    String? country,
  }) = _FeaturedPromoProductsRequestParams;

  factory FeaturedPromoProductsRequestParams.fromJson(
          Map<String, dynamic> json) =>
      _$FeaturedPromoProductsRequestParamsFromJson(json);
}
