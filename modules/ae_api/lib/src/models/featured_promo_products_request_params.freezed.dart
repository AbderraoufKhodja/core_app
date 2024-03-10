// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_promo_products_request_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeaturedPromoProductsRequestParams _$FeaturedPromoProductsRequestParamsFromJson(
    Map<String, dynamic> json) {
  return _FeaturedPromoProductsRequestParams.fromJson(json);
}

/// @nodoc
mixin _$FeaturedPromoProductsRequestParams {
  /// you can get category ID via "get category" API
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;

  /// Respond parameter list, eg: commission_rate,sale_price
  String? get fields => throw _privateConstructorUsedError;

  /// Filter products by keywords. eg: mp3
  String? get keywords => throw _privateConstructorUsedError;

  /// Filter products by highest price, unit cent
  @JsonKey(name: 'max_sale_price')
  String? get maxSalePrice => throw _privateConstructorUsedError;

  /// Filter products by lowest price, unit cent
  @JsonKey(name: 'min_sale_price')
  String? get minSalePrice => throw _privateConstructorUsedError;

  /// Page number
  @JsonKey(name: 'page_no')
  String? get pageNo => throw _privateConstructorUsedError;

  /// Record count of each page, 1 - 50
  @JsonKey(name: 'page_size')
  String? get pageSize => throw _privateConstructorUsedError;

  /// End time of promotion, PST time
  @JsonKey(name: 'promotion_end_time')
  String? get promotionEndTime => throw _privateConstructorUsedError;

  /// Promotion name, you can get Promotion name via "get featuredpromo info" API. eg. "Hot Product", "New Arrival", "Best Seller", "weeklydeals"
  @JsonKey(name: 'promotion_name')
  String get promotionName => throw _privateConstructorUsedError;

  /// Start time of promotion, PST time
  @JsonKey(name: 'promotion_start_time')
  String? get promotionStartTime => throw _privateConstructorUsedError;

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

  /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
  String? get country => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeaturedPromoProductsRequestParamsCopyWith<
          FeaturedPromoProductsRequestParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeaturedPromoProductsRequestParamsCopyWith<$Res> {
  factory $FeaturedPromoProductsRequestParamsCopyWith(
          FeaturedPromoProductsRequestParams value,
          $Res Function(FeaturedPromoProductsRequestParams) then) =
      _$FeaturedPromoProductsRequestParamsCopyWithImpl<$Res,
          FeaturedPromoProductsRequestParams>;
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String? categoryId,
      String? fields,
      String? keywords,
      @JsonKey(name: 'max_sale_price') String? maxSalePrice,
      @JsonKey(name: 'min_sale_price') String? minSalePrice,
      @JsonKey(name: 'page_no') String? pageNo,
      @JsonKey(name: 'page_size') String? pageSize,
      @JsonKey(name: 'promotion_end_time') String? promotionEndTime,
      @JsonKey(name: 'promotion_name') String promotionName,
      @JsonKey(name: 'promotion_start_time') String? promotionStartTime,
      String? sort,
      @JsonKey(name: 'target_currency') String? targetCurrency,
      @JsonKey(name: 'target_language') String? targetLanguage,
      @JsonKey(name: 'tracking_id') String? trackingId,
      String? country});
}

/// @nodoc
class _$FeaturedPromoProductsRequestParamsCopyWithImpl<$Res,
        $Val extends FeaturedPromoProductsRequestParams>
    implements $FeaturedPromoProductsRequestParamsCopyWith<$Res> {
  _$FeaturedPromoProductsRequestParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? fields = freezed,
    Object? keywords = freezed,
    Object? maxSalePrice = freezed,
    Object? minSalePrice = freezed,
    Object? pageNo = freezed,
    Object? pageSize = freezed,
    Object? promotionEndTime = freezed,
    Object? promotionName = null,
    Object? promotionStartTime = freezed,
    Object? sort = freezed,
    Object? targetCurrency = freezed,
    Object? targetLanguage = freezed,
    Object? trackingId = freezed,
    Object? country = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
              as String?,
      minSalePrice: freezed == minSalePrice
          ? _value.minSalePrice
          : minSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionEndTime: freezed == promotionEndTime
          ? _value.promotionEndTime
          : promotionEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionName: null == promotionName
          ? _value.promotionName
          : promotionName // ignore: cast_nullable_to_non_nullable
              as String,
      promotionStartTime: freezed == promotionStartTime
          ? _value.promotionStartTime
          : promotionStartTime // ignore: cast_nullable_to_non_nullable
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
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeaturedPromoProductsRequestParamsImplCopyWith<$Res>
    implements $FeaturedPromoProductsRequestParamsCopyWith<$Res> {
  factory _$$FeaturedPromoProductsRequestParamsImplCopyWith(
          _$FeaturedPromoProductsRequestParamsImpl value,
          $Res Function(_$FeaturedPromoProductsRequestParamsImpl) then) =
      __$$FeaturedPromoProductsRequestParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String? categoryId,
      String? fields,
      String? keywords,
      @JsonKey(name: 'max_sale_price') String? maxSalePrice,
      @JsonKey(name: 'min_sale_price') String? minSalePrice,
      @JsonKey(name: 'page_no') String? pageNo,
      @JsonKey(name: 'page_size') String? pageSize,
      @JsonKey(name: 'promotion_end_time') String? promotionEndTime,
      @JsonKey(name: 'promotion_name') String promotionName,
      @JsonKey(name: 'promotion_start_time') String? promotionStartTime,
      String? sort,
      @JsonKey(name: 'target_currency') String? targetCurrency,
      @JsonKey(name: 'target_language') String? targetLanguage,
      @JsonKey(name: 'tracking_id') String? trackingId,
      String? country});
}

/// @nodoc
class __$$FeaturedPromoProductsRequestParamsImplCopyWithImpl<$Res>
    extends _$FeaturedPromoProductsRequestParamsCopyWithImpl<$Res,
        _$FeaturedPromoProductsRequestParamsImpl>
    implements _$$FeaturedPromoProductsRequestParamsImplCopyWith<$Res> {
  __$$FeaturedPromoProductsRequestParamsImplCopyWithImpl(
      _$FeaturedPromoProductsRequestParamsImpl _value,
      $Res Function(_$FeaturedPromoProductsRequestParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? fields = freezed,
    Object? keywords = freezed,
    Object? maxSalePrice = freezed,
    Object? minSalePrice = freezed,
    Object? pageNo = freezed,
    Object? pageSize = freezed,
    Object? promotionEndTime = freezed,
    Object? promotionName = null,
    Object? promotionStartTime = freezed,
    Object? sort = freezed,
    Object? targetCurrency = freezed,
    Object? targetLanguage = freezed,
    Object? trackingId = freezed,
    Object? country = freezed,
  }) {
    return _then(_$FeaturedPromoProductsRequestParamsImpl(
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
              as String?,
      minSalePrice: freezed == minSalePrice
          ? _value.minSalePrice
          : minSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionEndTime: freezed == promotionEndTime
          ? _value.promotionEndTime
          : promotionEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionName: null == promotionName
          ? _value.promotionName
          : promotionName // ignore: cast_nullable_to_non_nullable
              as String,
      promotionStartTime: freezed == promotionStartTime
          ? _value.promotionStartTime
          : promotionStartTime // ignore: cast_nullable_to_non_nullable
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
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeaturedPromoProductsRequestParamsImpl
    implements _FeaturedPromoProductsRequestParams {
  _$FeaturedPromoProductsRequestParamsImpl(
      {@JsonKey(name: 'category_id') this.categoryId,
      this.fields,
      this.keywords,
      @JsonKey(name: 'max_sale_price') this.maxSalePrice,
      @JsonKey(name: 'min_sale_price') this.minSalePrice,
      @JsonKey(name: 'page_no') this.pageNo,
      @JsonKey(name: 'page_size') this.pageSize,
      @JsonKey(name: 'promotion_end_time') this.promotionEndTime,
      @JsonKey(name: 'promotion_name') required this.promotionName,
      @JsonKey(name: 'promotion_start_time') this.promotionStartTime,
      this.sort,
      @JsonKey(name: 'target_currency') this.targetCurrency,
      @JsonKey(name: 'target_language') this.targetLanguage,
      @JsonKey(name: 'tracking_id') this.trackingId,
      this.country});

  factory _$FeaturedPromoProductsRequestParamsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$FeaturedPromoProductsRequestParamsImplFromJson(json);

  /// you can get category ID via "get category" API
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;

  /// Respond parameter list, eg: commission_rate,sale_price
  @override
  final String? fields;

  /// Filter products by keywords. eg: mp3
  @override
  final String? keywords;

  /// Filter products by highest price, unit cent
  @override
  @JsonKey(name: 'max_sale_price')
  final String? maxSalePrice;

  /// Filter products by lowest price, unit cent
  @override
  @JsonKey(name: 'min_sale_price')
  final String? minSalePrice;

  /// Page number
  @override
  @JsonKey(name: 'page_no')
  final String? pageNo;

  /// Record count of each page, 1 - 50
  @override
  @JsonKey(name: 'page_size')
  final String? pageSize;

  /// End time of promotion, PST time
  @override
  @JsonKey(name: 'promotion_end_time')
  final String? promotionEndTime;

  /// Promotion name, you can get Promotion name via "get featuredpromo info" API. eg. "Hot Product", "New Arrival", "Best Seller", "weeklydeals"
  @override
  @JsonKey(name: 'promotion_name')
  final String promotionName;

  /// Start time of promotion, PST time
  @override
  @JsonKey(name: 'promotion_start_time')
  final String? promotionStartTime;

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

  /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
  @override
  final String? country;

  @override
  String toString() {
    return 'FeaturedPromoProductsRequestParams(categoryId: $categoryId, fields: $fields, keywords: $keywords, maxSalePrice: $maxSalePrice, minSalePrice: $minSalePrice, pageNo: $pageNo, pageSize: $pageSize, promotionEndTime: $promotionEndTime, promotionName: $promotionName, promotionStartTime: $promotionStartTime, sort: $sort, targetCurrency: $targetCurrency, targetLanguage: $targetLanguage, trackingId: $trackingId, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeaturedPromoProductsRequestParamsImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
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
            (identical(other.promotionEndTime, promotionEndTime) ||
                other.promotionEndTime == promotionEndTime) &&
            (identical(other.promotionName, promotionName) ||
                other.promotionName == promotionName) &&
            (identical(other.promotionStartTime, promotionStartTime) ||
                other.promotionStartTime == promotionStartTime) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.targetCurrency, targetCurrency) ||
                other.targetCurrency == targetCurrency) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.trackingId, trackingId) ||
                other.trackingId == trackingId) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      categoryId,
      fields,
      keywords,
      maxSalePrice,
      minSalePrice,
      pageNo,
      pageSize,
      promotionEndTime,
      promotionName,
      promotionStartTime,
      sort,
      targetCurrency,
      targetLanguage,
      trackingId,
      country);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeaturedPromoProductsRequestParamsImplCopyWith<
          _$FeaturedPromoProductsRequestParamsImpl>
      get copyWith => __$$FeaturedPromoProductsRequestParamsImplCopyWithImpl<
          _$FeaturedPromoProductsRequestParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeaturedPromoProductsRequestParamsImplToJson(
      this,
    );
  }
}

abstract class _FeaturedPromoProductsRequestParams
    implements FeaturedPromoProductsRequestParams {
  factory _FeaturedPromoProductsRequestParams(
      {@JsonKey(name: 'category_id') final String? categoryId,
      final String? fields,
      final String? keywords,
      @JsonKey(name: 'max_sale_price') final String? maxSalePrice,
      @JsonKey(name: 'min_sale_price') final String? minSalePrice,
      @JsonKey(name: 'page_no') final String? pageNo,
      @JsonKey(name: 'page_size') final String? pageSize,
      @JsonKey(name: 'promotion_end_time') final String? promotionEndTime,
      @JsonKey(name: 'promotion_name') required final String promotionName,
      @JsonKey(name: 'promotion_start_time') final String? promotionStartTime,
      final String? sort,
      @JsonKey(name: 'target_currency') final String? targetCurrency,
      @JsonKey(name: 'target_language') final String? targetLanguage,
      @JsonKey(name: 'tracking_id') final String? trackingId,
      final String? country}) = _$FeaturedPromoProductsRequestParamsImpl;

  factory _FeaturedPromoProductsRequestParams.fromJson(
          Map<String, dynamic> json) =
      _$FeaturedPromoProductsRequestParamsImpl.fromJson;

  @override

  /// you can get category ID via "get category" API
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override

  /// Respond parameter list, eg: commission_rate,sale_price
  String? get fields;
  @override

  /// Filter products by keywords. eg: mp3
  String? get keywords;
  @override

  /// Filter products by highest price, unit cent
  @JsonKey(name: 'max_sale_price')
  String? get maxSalePrice;
  @override

  /// Filter products by lowest price, unit cent
  @JsonKey(name: 'min_sale_price')
  String? get minSalePrice;
  @override

  /// Page number
  @JsonKey(name: 'page_no')
  String? get pageNo;
  @override

  /// Record count of each page, 1 - 50
  @JsonKey(name: 'page_size')
  String? get pageSize;
  @override

  /// End time of promotion, PST time
  @JsonKey(name: 'promotion_end_time')
  String? get promotionEndTime;
  @override

  /// Promotion name, you can get Promotion name via "get featuredpromo info" API. eg. "Hot Product", "New Arrival", "Best Seller", "weeklydeals"
  @JsonKey(name: 'promotion_name')
  String get promotionName;
  @override

  /// Start time of promotion, PST time
  @JsonKey(name: 'promotion_start_time')
  String? get promotionStartTime;
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

  /// The Ship to country. Filter products that can be sent to that country; Returns the price according to the country’s tax rate policy.
  String? get country;
  @override
  @JsonKey(ignore: true)
  _$$FeaturedPromoProductsRequestParamsImplCopyWith<
          _$FeaturedPromoProductsRequestParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
