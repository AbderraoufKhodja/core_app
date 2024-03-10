import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Products with _$Products {
  const factory Products({
    @JsonKey(name: 'product') List<Product>? product,
  }) = _Products;

  factory Products.fromJson(Map<String, Object?> json) =>
      _$ProductsFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: 'app_sale_price') String? appSalePrice,
    @JsonKey(name: 'original_price') String? originalPrice,
    @JsonKey(name: 'product_detail_url') String? productDetailUrl,
    @JsonKey(name: 'product_small_image_urls')
    ProductSmallImageUrls? productSmallImageUrls,
    @JsonKey(name: 'second_level_category_name')
    String? secondLevelCategoryName,
    @JsonKey(name: 'target_sale_price') String? targetSalePrice,
    @JsonKey(name: 'second_level_category_id') int? secondLevelCategoryId,
    @JsonKey(name: 'discount') String? discount,
    @JsonKey(name: 'product_main_image_url') String? productMainImageUrl,
    @JsonKey(name: 'first_level_category_id') int? firstLevelCategoryId,
    @JsonKey(name: 'target_sale_price_currency')
    String? targetSalePriceCurrency,
    @JsonKey(name: 'target_app_sale_price_currency')
    String? targetAppSalePriceCurrency,
    @JsonKey(name: 'original_price_currency') String? originalPriceCurrency,
    @JsonKey(name: 'shop_url') String? shopUrl,
    @JsonKey(name: 'target_original_price_currency')
    String? targetOriginalPriceCurrency,
    @JsonKey(name: 'product_id') int? productId,
    @JsonKey(name: 'target_original_price') String? targetOriginalPrice,
    @JsonKey(name: 'product_video_url') String? productVideoUrl,
    @JsonKey(name: 'first_level_category_name') String? firstLevelCategoryName,
    @JsonKey(name: 'promotion_link') String? promotionLink,
    @JsonKey(name: 'evaluate_rate') String? evaluateRate,
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'product_title') String? productTitle,
    @JsonKey(name: 'hot_product_commission_rate')
    String? hotProductCommissionRate,
    @JsonKey(name: 'shop_id') int? shopId,
    @JsonKey(name: 'app_sale_price_currency') String? appSalePriceCurrency,
    @JsonKey(name: 'sale_price_currency') String? salePriceCurrency,
    @JsonKey(name: 'lastest_volume') int? lastestVolume,
    @JsonKey(name: 'target_app_sale_price') String? targetAppSalePrice,
    @JsonKey(name: 'commission_rate') String? commissionRate,
    @JsonKey(name: 'platform_product_type') String? platformProductType,
    @JsonKey(name: 'ship_to_days') int? shipToDays,
    @JsonKey(name: 'relevant_market_commission_rate')
    String? relevantMarketCommissionRate,
    @JsonKey(name: 'promo_code_info') PromoCodeInfo? promoCodeInfo,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}

@freezed
class ProductSmallImageUrls with _$ProductSmallImageUrls {
  const factory ProductSmallImageUrls({
    @JsonKey(name: 'string') List<String>? string,
  }) = _ProductSmallImageUrls;

  factory ProductSmallImageUrls.fromJson(Map<String, Object?> json) =>
      _$ProductSmallImageUrlsFromJson(json);
}

@freezed
class PromoCodeInfo with _$PromoCodeInfo {
  const factory PromoCodeInfo({
    @JsonKey(name: 'code_campaigntype') String? codeCampaigntype,
    @JsonKey(name: 'code_availabletime_end') String? codeAvailabletimeEnd,
    @JsonKey(name: 'code_quantity') String? codeQuantity,
    @JsonKey(name: 'code_availabletime_start') String? codeAvailabletimeStart,
    @JsonKey(name: 'code_value') String? codeValue,
    @JsonKey(name: 'promo_code') String? promoCode,
    @JsonKey(name: 'code_mini_spend') String? codeMiniSpend,
  }) = _PromoCodeInfo;

  factory PromoCodeInfo.fromJson(Map<String, Object?> json) =>
      _$PromoCodeInfoFromJson(json);
}
