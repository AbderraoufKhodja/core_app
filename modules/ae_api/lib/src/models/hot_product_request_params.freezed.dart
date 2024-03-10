// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hot_product_request_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HotProductRequestParams _$HotProductRequestParamsFromJson(
    Map<String, dynamic> json) {
  return _RequestParams.fromJson(json);
}

/// @nodoc
mixin _$HotProductRequestParams {
  /// List of category ID, you can get category ID via "get category" API
  @JsonKey(name: 'category_ids')
  String? get categoryIds => throw _privateConstructorUsedError;

  /// Respond parameter list, eg: commission_rate,sale_price
  String? get fields => throw _privateConstructorUsedError;

  /// Filter products by keywords. eg: mp3
  String? get keywords => throw _privateConstructorUsedError;

  /// Filter products by highest price, unit cent
  @JsonKey(name: 'max_sale_price')
  num? get maxSalePrice => throw _privateConstructorUsedError;

  /// Filter products by lowest price, unit cent
  @JsonKey(name: 'min_sale_price')
  num? get minSalePrice => throw _privateConstructorUsedError;

  /// Page number
  @JsonKey(name: 'page_no')
  String? get pageNo => throw _privateConstructorUsedError;

  /// Record count of each page, 1 - 50
  @JsonKey(name: 'page_size')
  String? get pageSize => throw _privateConstructorUsedError;

  /// product type：ALL,PLAZA,TMALL
  @JsonKey(name: 'platform_product_type')
  String? get platformProductType => throw _privateConstructorUsedError;

  /// sort by:SALE_PRICE_ASC, SALE_PRICE_DESC, LAST_VOLUME_ASC, LAST_VOLUME_DESC
  String? get sort => throw _privateConstructorUsedError;

  /// target currency:USD, GBP, CAD, EUR, UAH, MXN, TRY, RUB, BRL, AUD, INR, JPY, IDR, SEK,KRW
  @JsonKey(name: 'target_currency')
  String? get targetCurrency => throw _privateConstructorUsedError;

  /// target language:EN,RU,PT,ES,FR,ID,IT,TH,JA,AR,VI,TR,DE,HE,KO,NL,PL,MX,CL,IW,IN
  @JsonKey(name: 'target_language')
  String? get targetLanguage => throw _privateConstructorUsedError;

  /// Your trackingID
  @JsonKey(name: 'tracking_id')
  String? get trackingId => throw _privateConstructorUsedError;

  /// Estimated delivery days. 3：in 3 days，5：in 5 days，7：in 7 days，10：in 10 days
  @JsonKey(name: 'delivery_days')
  String? get deliveryDays => throw _privateConstructorUsedError;

  /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
  @JsonKey(name: 'ship_to_country')
  String? get shipToCountry => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HotProductRequestParamsCopyWith<HotProductRequestParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotProductRequestParamsCopyWith<$Res> {
  factory $HotProductRequestParamsCopyWith(HotProductRequestParams value,
          $Res Function(HotProductRequestParams) then) =
      _$HotProductRequestParamsCopyWithImpl<$Res, HotProductRequestParams>;
  @useResult
  $Res call(
      {@JsonKey(name: 'category_ids') String? categoryIds,
      String? fields,
      String? keywords,
      @JsonKey(name: 'max_sale_price') num? maxSalePrice,
      @JsonKey(name: 'min_sale_price') num? minSalePrice,
      @JsonKey(name: 'page_no') String? pageNo,
      @JsonKey(name: 'page_size') String? pageSize,
      @JsonKey(name: 'platform_product_type') String? platformProductType,
      String? sort,
      @JsonKey(name: 'target_currency') String? targetCurrency,
      @JsonKey(name: 'target_language') String? targetLanguage,
      @JsonKey(name: 'tracking_id') String? trackingId,
      @JsonKey(name: 'delivery_days') String? deliveryDays,
      @JsonKey(name: 'ship_to_country') String? shipToCountry});
}

/// @nodoc
class _$HotProductRequestParamsCopyWithImpl<$Res,
        $Val extends HotProductRequestParams>
    implements $HotProductRequestParamsCopyWith<$Res> {
  _$HotProductRequestParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryIds = freezed,
    Object? fields = freezed,
    Object? keywords = freezed,
    Object? maxSalePrice = freezed,
    Object? minSalePrice = freezed,
    Object? pageNo = freezed,
    Object? pageSize = freezed,
    Object? platformProductType = freezed,
    Object? sort = freezed,
    Object? targetCurrency = freezed,
    Object? targetLanguage = freezed,
    Object? trackingId = freezed,
    Object? deliveryDays = freezed,
    Object? shipToCountry = freezed,
  }) {
    return _then(_value.copyWith(
      categoryIds: freezed == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as String?,
      fields: freezed == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: freezed == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSalePrice: freezed == maxSalePrice
          ? _value.maxSalePrice
          : maxSalePrice // ignore: cast_nullable_to_non_nullable
              as num?,
      minSalePrice: freezed == minSalePrice
          ? _value.minSalePrice
          : minSalePrice // ignore: cast_nullable_to_non_nullable
              as num?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as String?,
      platformProductType: freezed == platformProductType
          ? _value.platformProductType
          : platformProductType // ignore: cast_nullable_to_non_nullable
              as String?,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
      targetCurrency: freezed == targetCurrency
          ? _value.targetCurrency
          : targetCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      targetLanguage: freezed == targetLanguage
          ? _value.targetLanguage
          : targetLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingId: freezed == trackingId
          ? _value.trackingId
          : trackingId // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDays: freezed == deliveryDays
          ? _value.deliveryDays
          : deliveryDays // ignore: cast_nullable_to_non_nullable
              as String?,
      shipToCountry: freezed == shipToCountry
          ? _value.shipToCountry
          : shipToCountry // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestParamsImplCopyWith<$Res>
    implements $HotProductRequestParamsCopyWith<$Res> {
  factory _$$RequestParamsImplCopyWith(
          _$RequestParamsImpl value, $Res Function(_$RequestParamsImpl) then) =
      __$$RequestParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'category_ids') String? categoryIds,
      String? fields,
      String? keywords,
      @JsonKey(name: 'max_sale_price') num? maxSalePrice,
      @JsonKey(name: 'min_sale_price') num? minSalePrice,
      @JsonKey(name: 'page_no') String? pageNo,
      @JsonKey(name: 'page_size') String? pageSize,
      @JsonKey(name: 'platform_product_type') String? platformProductType,
      String? sort,
      @JsonKey(name: 'target_currency') String? targetCurrency,
      @JsonKey(name: 'target_language') String? targetLanguage,
      @JsonKey(name: 'tracking_id') String? trackingId,
      @JsonKey(name: 'delivery_days') String? deliveryDays,
      @JsonKey(name: 'ship_to_country') String? shipToCountry});
}

/// @nodoc
class __$$RequestParamsImplCopyWithImpl<$Res>
    extends _$HotProductRequestParamsCopyWithImpl<$Res, _$RequestParamsImpl>
    implements _$$RequestParamsImplCopyWith<$Res> {
  __$$RequestParamsImplCopyWithImpl(
      _$RequestParamsImpl _value, $Res Function(_$RequestParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryIds = freezed,
    Object? fields = freezed,
    Object? keywords = freezed,
    Object? maxSalePrice = freezed,
    Object? minSalePrice = freezed,
    Object? pageNo = freezed,
    Object? pageSize = freezed,
    Object? platformProductType = freezed,
    Object? sort = freezed,
    Object? targetCurrency = freezed,
    Object? targetLanguage = freezed,
    Object? trackingId = freezed,
    Object? deliveryDays = freezed,
    Object? shipToCountry = freezed,
  }) {
    return _then(_$RequestParamsImpl(
      categoryIds: freezed == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as String?,
      fields: freezed == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: freezed == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSalePrice: freezed == maxSalePrice
          ? _value.maxSalePrice
          : maxSalePrice // ignore: cast_nullable_to_non_nullable
              as num?,
      minSalePrice: freezed == minSalePrice
          ? _value.minSalePrice
          : minSalePrice // ignore: cast_nullable_to_non_nullable
              as num?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as String?,
      platformProductType: freezed == platformProductType
          ? _value.platformProductType
          : platformProductType // ignore: cast_nullable_to_non_nullable
              as String?,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
      targetCurrency: freezed == targetCurrency
          ? _value.targetCurrency
          : targetCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      targetLanguage: freezed == targetLanguage
          ? _value.targetLanguage
          : targetLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingId: freezed == trackingId
          ? _value.trackingId
          : trackingId // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDays: freezed == deliveryDays
          ? _value.deliveryDays
          : deliveryDays // ignore: cast_nullable_to_non_nullable
              as String?,
      shipToCountry: freezed == shipToCountry
          ? _value.shipToCountry
          : shipToCountry // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestParamsImpl implements _RequestParams {
  _$RequestParamsImpl(
      {@JsonKey(name: 'category_ids') this.categoryIds,
      this.fields,
      this.keywords,
      @JsonKey(name: 'max_sale_price') this.maxSalePrice,
      @JsonKey(name: 'min_sale_price') this.minSalePrice,
      @JsonKey(name: 'page_no') this.pageNo,
      @JsonKey(name: 'page_size') this.pageSize,
      @JsonKey(name: 'platform_product_type') this.platformProductType,
      this.sort,
      @JsonKey(name: 'target_currency') this.targetCurrency,
      @JsonKey(name: 'target_language') this.targetLanguage,
      @JsonKey(name: 'tracking_id') this.trackingId,
      @JsonKey(name: 'delivery_days') this.deliveryDays,
      @JsonKey(name: 'ship_to_country') this.shipToCountry});

  factory _$RequestParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestParamsImplFromJson(json);

  /// List of category ID, you can get category ID via "get category" API
  @override
  @JsonKey(name: 'category_ids')
  final String? categoryIds;

  /// Respond parameter list, eg: commission_rate,sale_price
  @override
  final String? fields;

  /// Filter products by keywords. eg: mp3
  @override
  final String? keywords;

  /// Filter products by highest price, unit cent
  @override
  @JsonKey(name: 'max_sale_price')
  final num? maxSalePrice;

  /// Filter products by lowest price, unit cent
  @override
  @JsonKey(name: 'min_sale_price')
  final num? minSalePrice;

  /// Page number
  @override
  @JsonKey(name: 'page_no')
  final String? pageNo;

  /// Record count of each page, 1 - 50
  @override
  @JsonKey(name: 'page_size')
  final String? pageSize;

  /// product type：ALL,PLAZA,TMALL
  @override
  @JsonKey(name: 'platform_product_type')
  final String? platformProductType;

  /// sort by:SALE_PRICE_ASC, SALE_PRICE_DESC, LAST_VOLUME_ASC, LAST_VOLUME_DESC
  @override
  final String? sort;

  /// target currency:USD, GBP, CAD, EUR, UAH, MXN, TRY, RUB, BRL, AUD, INR, JPY, IDR, SEK,KRW
  @override
  @JsonKey(name: 'target_currency')
  final String? targetCurrency;

  /// target language:EN,RU,PT,ES,FR,ID,IT,TH,JA,AR,VI,TR,DE,HE,KO,NL,PL,MX,CL,IW,IN
  @override
  @JsonKey(name: 'target_language')
  final String? targetLanguage;

  /// Your trackingID
  @override
  @JsonKey(name: 'tracking_id')
  final String? trackingId;

  /// Estimated delivery days. 3：in 3 days，5：in 5 days，7：in 7 days，10：in 10 days
  @override
  @JsonKey(name: 'delivery_days')
  final String? deliveryDays;

  /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
  @override
  @JsonKey(name: 'ship_to_country')
  final String? shipToCountry;

  @override
  String toString() {
    return 'HotProductRequestParams(categoryIds: $categoryIds, fields: $fields, keywords: $keywords, maxSalePrice: $maxSalePrice, minSalePrice: $minSalePrice, pageNo: $pageNo, pageSize: $pageSize, platformProductType: $platformProductType, sort: $sort, targetCurrency: $targetCurrency, targetLanguage: $targetLanguage, trackingId: $trackingId, deliveryDays: $deliveryDays, shipToCountry: $shipToCountry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestParamsImpl &&
            (identical(other.categoryIds, categoryIds) ||
                other.categoryIds == categoryIds) &&
            (identical(other.fields, fields) || other.fields == fields) &&
            (identical(other.keywords, keywords) ||
                other.keywords == keywords) &&
            (identical(other.maxSalePrice, maxSalePrice) ||
                other.maxSalePrice == maxSalePrice) &&
            (identical(other.minSalePrice, minSalePrice) ||
                other.minSalePrice == minSalePrice) &&
            (identical(other.pageNo, pageNo) || other.pageNo == pageNo) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.platformProductType, platformProductType) ||
                other.platformProductType == platformProductType) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.targetCurrency, targetCurrency) ||
                other.targetCurrency == targetCurrency) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.trackingId, trackingId) ||
                other.trackingId == trackingId) &&
            (identical(other.deliveryDays, deliveryDays) ||
                other.deliveryDays == deliveryDays) &&
            (identical(other.shipToCountry, shipToCountry) ||
                other.shipToCountry == shipToCountry));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      categoryIds,
      fields,
      keywords,
      maxSalePrice,
      minSalePrice,
      pageNo,
      pageSize,
      platformProductType,
      sort,
      targetCurrency,
      targetLanguage,
      trackingId,
      deliveryDays,
      shipToCountry);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestParamsImplCopyWith<_$RequestParamsImpl> get copyWith =>
      __$$RequestParamsImplCopyWithImpl<_$RequestParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestParamsImplToJson(
      this,
    );
  }
}

abstract class _RequestParams implements HotProductRequestParams {
  factory _RequestParams(
      {@JsonKey(name: 'category_ids') final String? categoryIds,
      final String? fields,
      final String? keywords,
      @JsonKey(name: 'max_sale_price') final num? maxSalePrice,
      @JsonKey(name: 'min_sale_price') final num? minSalePrice,
      @JsonKey(name: 'page_no') final String? pageNo,
      @JsonKey(name: 'page_size') final String? pageSize,
      @JsonKey(name: 'platform_product_type') final String? platformProductType,
      final String? sort,
      @JsonKey(name: 'target_currency') final String? targetCurrency,
      @JsonKey(name: 'target_language') final String? targetLanguage,
      @JsonKey(name: 'tracking_id') final String? trackingId,
      @JsonKey(name: 'delivery_days') final String? deliveryDays,
      @JsonKey(name: 'ship_to_country')
      final String? shipToCountry}) = _$RequestParamsImpl;

  factory _RequestParams.fromJson(Map<String, dynamic> json) =
      _$RequestParamsImpl.fromJson;

  @override

  /// List of category ID, you can get category ID via "get category" API
  @JsonKey(name: 'category_ids')
  String? get categoryIds;
  @override

  /// Respond parameter list, eg: commission_rate,sale_price
  String? get fields;
  @override

  /// Filter products by keywords. eg: mp3
  String? get keywords;
  @override

  /// Filter products by highest price, unit cent
  @JsonKey(name: 'max_sale_price')
  num? get maxSalePrice;
  @override

  /// Filter products by lowest price, unit cent
  @JsonKey(name: 'min_sale_price')
  num? get minSalePrice;
  @override

  /// Page number
  @JsonKey(name: 'page_no')
  String? get pageNo;
  @override

  /// Record count of each page, 1 - 50
  @JsonKey(name: 'page_size')
  String? get pageSize;
  @override

  /// product type：ALL,PLAZA,TMALL
  @JsonKey(name: 'platform_product_type')
  String? get platformProductType;
  @override

  /// sort by:SALE_PRICE_ASC, SALE_PRICE_DESC, LAST_VOLUME_ASC, LAST_VOLUME_DESC
  String? get sort;
  @override

  /// target currency:USD, GBP, CAD, EUR, UAH, MXN, TRY, RUB, BRL, AUD, INR, JPY, IDR, SEK,KRW
  @JsonKey(name: 'target_currency')
  String? get targetCurrency;
  @override

  /// target language:EN,RU,PT,ES,FR,ID,IT,TH,JA,AR,VI,TR,DE,HE,KO,NL,PL,MX,CL,IW,IN
  @JsonKey(name: 'target_language')
  String? get targetLanguage;
  @override

  /// Your trackingID
  @JsonKey(name: 'tracking_id')
  String? get trackingId;
  @override

  /// Estimated delivery days. 3：in 3 days，5：in 5 days，7：in 7 days，10：in 10 days
  @JsonKey(name: 'delivery_days')
  String? get deliveryDays;
  @override

  /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
  @JsonKey(name: 'ship_to_country')
  String? get shipToCountry;
  @override
  @JsonKey(ignore: true)
  _$$RequestParamsImplCopyWith<_$RequestParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
