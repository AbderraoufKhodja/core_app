// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_promo_products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeaturedPromoProductsResponseImpl
    _$$FeaturedPromoProductsResponseImplFromJson(Map<String, dynamic> json) =>
        _$FeaturedPromoProductsResponseImpl(
          aliexpressAffiliateFeaturedpromoProductsGetResponse: json[
                      'aliexpress_affiliate_featuredpromo_products_get_response'] ==
                  null
              ? null
              : AliexpressAffiliateFeaturedpromoProductsGetResponse.fromJson(
                  json['aliexpress_affiliate_featuredpromo_products_get_response']
                      as Map<String, dynamic>),
        );

Map<String, dynamic> _$$FeaturedPromoProductsResponseImplToJson(
        _$FeaturedPromoProductsResponseImpl instance) =>
    <String, dynamic>{
      'aliexpress_affiliate_featuredpromo_products_get_response':
          instance.aliexpressAffiliateFeaturedpromoProductsGetResponse,
    };

_$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl
    _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplFromJson(
            Map<String, dynamic> json) =>
        _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl(
          respResult: json['resp_result'] == null
              ? null
              : RespResult.fromJson(
                  json['resp_result'] as Map<String, dynamic>),
          requestId: json['request_id'] as String?,
        );

Map<String,
    dynamic> _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplToJson(
        _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl instance) =>
    <String, dynamic>{
      'resp_result': instance.respResult,
      'request_id': instance.requestId,
    };

_$RespResultImpl _$$RespResultImplFromJson(Map<String, dynamic> json) =>
    _$RespResultImpl(
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      respCode: json['resp_code'] as int?,
    );

Map<String, dynamic> _$$RespResultImplToJson(_$RespResultImpl instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resp_code': instance.respCode,
    };

_$ResultImpl _$$ResultImplFromJson(Map<String, dynamic> json) => _$ResultImpl(
      currentRecordCount: json['current_record_count'] as int?,
      totalRecordCount: json['total_record_count'] as int?,
      isFinished: json['is_finished'] as bool?,
      products: json['products'] == null
          ? null
          : Products.fromJson(json['products'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ResultImplToJson(_$ResultImpl instance) =>
    <String, dynamic>{
      'current_record_count': instance.currentRecordCount,
      'total_record_count': instance.totalRecordCount,
      'is_finished': instance.isFinished,
      'products': instance.products,
    };
