// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_hot_products_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetHotProductsResultImpl _$$GetHotProductsResultImplFromJson(
        Map<String, dynamic> json) =>
    _$GetHotProductsResultImpl(
      currentRecordCount: json['currentRecordCount'] as int?,
      totalRecordCount: json['totalRecordCount'] as int?,
      currentPageNo: json['currentPageNo'] as int?,
      products: json['products'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$GetHotProductsResultImplToJson(
        _$GetHotProductsResultImpl instance) =>
    <String, dynamic>{
      'currentRecordCount': instance.currentRecordCount,
      'totalRecordCount': instance.totalRecordCount,
      'currentPageNo': instance.currentPageNo,
      'products': instance.products,
    };
