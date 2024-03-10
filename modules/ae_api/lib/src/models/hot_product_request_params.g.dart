// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_product_request_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestParamsImpl _$$RequestParamsImplFromJson(Map<String, dynamic> json) =>
    _$RequestParamsImpl(
      categoryIds: json['category_ids'] as String?,
      fields: json['fields'] as String?,
      keywords: json['keywords'] as String?,
      maxSalePrice: json['max_sale_price'] as num?,
      minSalePrice: json['min_sale_price'] as num?,
      pageNo: json['page_no'] as String?,
      pageSize: json['page_size'] as String?,
      platformProductType: json['platform_product_type'] as String?,
      sort: json['sort'] as String?,
      targetCurrency: json['target_currency'] as String?,
      targetLanguage: json['target_language'] as String?,
      trackingId: json['tracking_id'] as String?,
      deliveryDays: json['delivery_days'] as String?,
      shipToCountry: json['ship_to_country'] as String?,
    );

Map<String, dynamic> _$$RequestParamsImplToJson(_$RequestParamsImpl instance) =>
    <String, dynamic>{
      'category_ids': instance.categoryIds,
      'fields': instance.fields,
      'keywords': instance.keywords,
      'max_sale_price': instance.maxSalePrice,
      'min_sale_price': instance.minSalePrice,
      'page_no': instance.pageNo,
      'page_size': instance.pageSize,
      'platform_product_type': instance.platformProductType,
      'sort': instance.sort,
      'target_currency': instance.targetCurrency,
      'target_language': instance.targetLanguage,
      'tracking_id': instance.trackingId,
      'delivery_days': instance.deliveryDays,
      'ship_to_country': instance.shipToCountry,
    };
