// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductsImpl _$$ProductsImplFromJson(Map<String, dynamic> json) =>
    _$ProductsImpl(
      product: (json['product'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProductsImplToJson(_$ProductsImpl instance) =>
    <String, dynamic>{
      'product': instance.product,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      appSalePrice: json['app_sale_price'] as String?,
      originalPrice: json['original_price'] as String?,
      productDetailUrl: json['product_detail_url'] as String?,
      productSmallImageUrls: json['product_small_image_urls'] == null
          ? null
          : ProductSmallImageUrls.fromJson(
              json['product_small_image_urls'] as Map<String, dynamic>),
      secondLevelCategoryName: json['second_level_category_name'] as String?,
      targetSalePrice: json['target_sale_price'] as String?,
      secondLevelCategoryId: json['second_level_category_id'] as int?,
      discount: json['discount'] as String?,
      productMainImageUrl: json['product_main_image_url'] as String?,
      firstLevelCategoryId: json['first_level_category_id'] as int?,
      targetSalePriceCurrency: json['target_sale_price_currency'] as String?,
      targetAppSalePriceCurrency:
          json['target_app_sale_price_currency'] as String?,
      originalPriceCurrency: json['original_price_currency'] as String?,
      shopUrl: json['shop_url'] as String?,
      targetOriginalPriceCurrency:
          json['target_original_price_currency'] as String?,
      productId: json['product_id'] as int?,
      targetOriginalPrice: json['target_original_price'] as String?,
      productVideoUrl: json['product_video_url'] as String?,
      firstLevelCategoryName: json['first_level_category_name'] as String?,
      promotionLink: json['promotion_link'] as String?,
      evaluateRate: json['evaluate_rate'] as String?,
      salePrice: json['sale_price'] as String?,
      productTitle: json['product_title'] as String?,
      hotProductCommissionRate: json['hot_product_commission_rate'] as String?,
      shopId: json['shop_id'] as int?,
      appSalePriceCurrency: json['app_sale_price_currency'] as String?,
      salePriceCurrency: json['sale_price_currency'] as String?,
      lastestVolume: json['lastest_volume'] as int?,
      targetAppSalePrice: json['target_app_sale_price'] as String?,
      commissionRate: json['commission_rate'] as String?,
      platformProductType: json['platform_product_type'] as String?,
      shipToDays: json['ship_to_days'] as int?,
      relevantMarketCommissionRate:
          json['relevant_market_commission_rate'] as String?,
      promoCodeInfo: json['promo_code_info'] == null
          ? null
          : PromoCodeInfo.fromJson(
              json['promo_code_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'app_sale_price': instance.appSalePrice,
      'original_price': instance.originalPrice,
      'product_detail_url': instance.productDetailUrl,
      'product_small_image_urls': instance.productSmallImageUrls,
      'second_level_category_name': instance.secondLevelCategoryName,
      'target_sale_price': instance.targetSalePrice,
      'second_level_category_id': instance.secondLevelCategoryId,
      'discount': instance.discount,
      'product_main_image_url': instance.productMainImageUrl,
      'first_level_category_id': instance.firstLevelCategoryId,
      'target_sale_price_currency': instance.targetSalePriceCurrency,
      'target_app_sale_price_currency': instance.targetAppSalePriceCurrency,
      'original_price_currency': instance.originalPriceCurrency,
      'shop_url': instance.shopUrl,
      'target_original_price_currency': instance.targetOriginalPriceCurrency,
      'product_id': instance.productId,
      'target_original_price': instance.targetOriginalPrice,
      'product_video_url': instance.productVideoUrl,
      'first_level_category_name': instance.firstLevelCategoryName,
      'promotion_link': instance.promotionLink,
      'evaluate_rate': instance.evaluateRate,
      'sale_price': instance.salePrice,
      'product_title': instance.productTitle,
      'hot_product_commission_rate': instance.hotProductCommissionRate,
      'shop_id': instance.shopId,
      'app_sale_price_currency': instance.appSalePriceCurrency,
      'sale_price_currency': instance.salePriceCurrency,
      'lastest_volume': instance.lastestVolume,
      'target_app_sale_price': instance.targetAppSalePrice,
      'commission_rate': instance.commissionRate,
      'platform_product_type': instance.platformProductType,
      'ship_to_days': instance.shipToDays,
      'relevant_market_commission_rate': instance.relevantMarketCommissionRate,
      'promo_code_info': instance.promoCodeInfo,
    };

_$ProductSmallImageUrlsImpl _$$ProductSmallImageUrlsImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductSmallImageUrlsImpl(
      string:
          (json['string'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ProductSmallImageUrlsImplToJson(
        _$ProductSmallImageUrlsImpl instance) =>
    <String, dynamic>{
      'string': instance.string,
    };

_$PromoCodeInfoImpl _$$PromoCodeInfoImplFromJson(Map<String, dynamic> json) =>
    _$PromoCodeInfoImpl(
      codeCampaigntype: json['code_campaigntype'] as String?,
      codeAvailabletimeEnd: json['code_availabletime_end'] as String?,
      codeQuantity: json['code_quantity'] as String?,
      codeAvailabletimeStart: json['code_availabletime_start'] as String?,
      codeValue: json['code_value'] as String?,
      promoCode: json['promo_code'] as String?,
      codeMiniSpend: json['code_mini_spend'] as String?,
    );

Map<String, dynamic> _$$PromoCodeInfoImplToJson(_$PromoCodeInfoImpl instance) =>
    <String, dynamic>{
      'code_campaigntype': instance.codeCampaigntype,
      'code_availabletime_end': instance.codeAvailabletimeEnd,
      'code_quantity': instance.codeQuantity,
      'code_availabletime_start': instance.codeAvailabletimeStart,
      'code_value': instance.codeValue,
      'promo_code': instance.promoCode,
      'code_mini_spend': instance.codeMiniSpend,
    };
