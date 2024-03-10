// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HotProductsResponseImpl _$$HotProductsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$HotProductsResponseImpl(
      aliexpressAffiliateHotproductQueryResponse:
          json['aliexpress_affiliate_hotproduct_query_response'] == null
              ? null
              : AliexpressAffiliateHotproductQueryResponse.fromJson(
                  json['aliexpress_affiliate_hotproduct_query_response']
                      as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HotProductsResponseImplToJson(
        _$HotProductsResponseImpl instance) =>
    <String, dynamic>{
      'aliexpress_affiliate_hotproduct_query_response':
          instance.aliexpressAffiliateHotproductQueryResponse,
    };

_$AliexpressAffiliateHotproductQueryResponseImpl
    _$$AliexpressAffiliateHotproductQueryResponseImplFromJson(
            Map<String, dynamic> json) =>
        _$AliexpressAffiliateHotproductQueryResponseImpl(
          respResult: json['resp_result'] == null
              ? null
              : RespResult.fromJson(
                  json['resp_result'] as Map<String, dynamic>),
          requestId: json['request_id'] as String?,
        );

Map<String, dynamic> _$$AliexpressAffiliateHotproductQueryResponseImplToJson(
        _$AliexpressAffiliateHotproductQueryResponseImpl instance) =>
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
      totalRecordCount: json['total_record_count'] as int?,
      currentPageNo: json['current_page_no'] as int?,
      products: json['products'] == null
          ? null
          : Products.fromJson(json['products'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ResultImplToJson(_$ResultImpl instance) =>
    <String, dynamic>{
      'current_record_count': instance.currentRecordCount,
      'total_record_count': instance.totalRecordCount,
      'current_page_no': instance.currentPageNo,
      'products': instance.products,
    };
