// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_promo_products_request_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeaturedPromoProductsRequestParamsImpl
    _$$FeaturedPromoProductsRequestParamsImplFromJson(
            Map<String, dynamic> json) =>
        _$FeaturedPromoProductsRequestParamsImpl(
          categoryId: json['category_id'] as String?,
          fields: json['fields'] as String?,
          keywords: json['keywords'] as String?,
          maxSalePrice: json['max_sale_price'] as String?,
          minSalePrice: json['min_sale_price'] as String?,
          pageNo: json['page_no'] as String?,
          pageSize: json['page_size'] as String?,
          promotionEndTime: json['promotion_end_time'] as String?,
          promotionName: json['promotion_name'] as String,
          promotionStartTime: json['promotion_start_time'] as String?,
          sort: json['sort'] as String?,
          targetCurrency: json['target_currency'] as String?,
          targetLanguage: json['target_language'] as String?,
          trackingId: json['tracking_id'] as String?,
          country: json['country'] as String?,
        );

Map<String, dynamic> _$$FeaturedPromoProductsRequestParamsImplToJson(
        _$FeaturedPromoProductsRequestParamsImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'fields': instance.fields,
      'keywords': instance.keywords,
      'max_sale_price': instance.maxSalePrice,
      'min_sale_price': instance.minSalePrice,
      'page_no': instance.pageNo,
      'page_size': instance.pageSize,
      'promotion_end_time': instance.promotionEndTime,
      'promotion_name': instance.promotionName,
      'promotion_start_time': instance.promotionStartTime,
      'sort': instance.sort,
      'target_currency': instance.targetCurrency,
      'target_language': instance.targetLanguage,
      'tracking_id': instance.trackingId,
      'country': instance.country,
    };
