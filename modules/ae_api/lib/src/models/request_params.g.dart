// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestParamsImpl _$$RequestParamsImplFromJson(Map<String, dynamic> json) =>
    _$RequestParamsImpl(
      device: json['device'] as String?,
      deviceId: json['device_id'] as String?,
      fields: json['fields'] as String?,
      keywords: json['keywords'] as String?,
      pageNo: json['page_no'] as int?,
      productId: json['product_id'] as String?,
      site: json['site'] as String?,
      targetCurrency: json['target_currency'] as String?,
      targetLanguage: json['target_language'] as String?,
      trackingId: json['tracking_id'] as String?,
      user: json['user'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$RequestParamsImplToJson(_$RequestParamsImpl instance) =>
    <String, dynamic>{
      'device': instance.device,
      'device_id': instance.deviceId,
      'fields': instance.fields,
      'keywords': instance.keywords,
      'page_no': instance.pageNo,
      'product_id': instance.productId,
      'site': instance.site,
      'target_currency': instance.targetCurrency,
      'target_language': instance.targetLanguage,
      'tracking_id': instance.trackingId,
      'user': instance.user,
      'country': instance.country,
    };
