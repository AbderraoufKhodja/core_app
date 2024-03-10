// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_promo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeaturedPromoResponseImpl _$$FeaturedPromoResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FeaturedPromoResponseImpl(
      aliexpressAffiliateFeaturedpromoGetResponse:
          json['aliexpress_affiliate_featuredpromo_get_response'] == null
              ? null
              : AliexpressAffiliateFeaturedpromoGetResponse.fromJson(
                  json['aliexpress_affiliate_featuredpromo_get_response']
                      as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FeaturedPromoResponseImplToJson(
        _$FeaturedPromoResponseImpl instance) =>
    <String, dynamic>{
      'aliexpress_affiliate_featuredpromo_get_response':
          instance.aliexpressAffiliateFeaturedpromoGetResponse,
    };

_$AliexpressAffiliateFeaturedpromoGetResponseImpl
    _$$AliexpressAffiliateFeaturedpromoGetResponseImplFromJson(
            Map<String, dynamic> json) =>
        _$AliexpressAffiliateFeaturedpromoGetResponseImpl(
          respResult: json['resp_result'] == null
              ? null
              : RespResult.fromJson(
                  json['resp_result'] as Map<String, dynamic>),
          requestId: json['request_id'] as String?,
        );

Map<String, dynamic> _$$AliexpressAffiliateFeaturedpromoGetResponseImplToJson(
        _$AliexpressAffiliateFeaturedpromoGetResponseImpl instance) =>
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
      respMsg: json['resp_msg'] as String?,
    );

Map<String, dynamic> _$$RespResultImplToJson(_$RespResultImpl instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resp_code': instance.respCode,
      'resp_msg': instance.respMsg,
    };

_$ResultImpl _$$ResultImplFromJson(Map<String, dynamic> json) => _$ResultImpl(
      currentRecordCount: json['current_record_count'] as int?,
      promos: json['promos'] == null
          ? null
          : Promos.fromJson(json['promos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ResultImplToJson(_$ResultImpl instance) =>
    <String, dynamic>{
      'current_record_count': instance.currentRecordCount,
      'promos': instance.promos,
    };

_$PromosImpl _$$PromosImplFromJson(Map<String, dynamic> json) => _$PromosImpl(
      promo: (json['promo'] as List<dynamic>?)
          ?.map((e) => Promo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PromosImplToJson(_$PromosImpl instance) =>
    <String, dynamic>{
      'promo': instance.promo,
    };

_$PromoImpl _$$PromoImplFromJson(Map<String, dynamic> json) => _$PromoImpl(
      promoName: json['promo_name'] as String?,
      promoDesc: json['promo_desc'] as String?,
      productNum: json['product_num'] as int?,
    );

Map<String, dynamic> _$$PromoImplToJson(_$PromoImpl instance) =>
    <String, dynamic>{
      'promo_name': instance.promoName,
      'promo_desc': instance.promoDesc,
      'product_num': instance.productNum,
    };
