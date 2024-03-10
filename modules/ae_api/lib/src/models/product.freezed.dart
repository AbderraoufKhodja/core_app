// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Products _$ProductsFromJson(Map<String, dynamic> json) {
  return _Products.fromJson(json);
}

/// @nodoc
mixin _$Products {
  @JsonKey(name: 'product')
  List<Product>? get product => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductsCopyWith<Products> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsCopyWith<$Res> {
  factory $ProductsCopyWith(Products value, $Res Function(Products) then) =
      _$ProductsCopyWithImpl<$Res, Products>;
  @useResult
  $Res call({@JsonKey(name: 'product') List<Product>? product});
}

/// @nodoc
class _$ProductsCopyWithImpl<$Res, $Val extends Products>
    implements $ProductsCopyWith<$Res> {
  _$ProductsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = freezed,
  }) {
    return _then(_value.copyWith(
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as List<Product>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductsImplCopyWith<$Res>
    implements $ProductsCopyWith<$Res> {
  factory _$$ProductsImplCopyWith(
          _$ProductsImpl value, $Res Function(_$ProductsImpl) then) =
      __$$ProductsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'product') List<Product>? product});
}

/// @nodoc
class __$$ProductsImplCopyWithImpl<$Res>
    extends _$ProductsCopyWithImpl<$Res, _$ProductsImpl>
    implements _$$ProductsImplCopyWith<$Res> {
  __$$ProductsImplCopyWithImpl(
      _$ProductsImpl _value, $Res Function(_$ProductsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = freezed,
  }) {
    return _then(_$ProductsImpl(
      product: freezed == product
          ? _value._product
          : product // ignore: cast_nullable_to_non_nullable
              as List<Product>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductsImpl with DiagnosticableTreeMixin implements _Products {
  const _$ProductsImpl({@JsonKey(name: 'product') final List<Product>? product})
      : _product = product;

  factory _$ProductsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductsImplFromJson(json);

  final List<Product>? _product;
  @override
  @JsonKey(name: 'product')
  List<Product>? get product {
    final value = _product;
    if (value == null) return null;
    if (_product is EqualUnmodifiableListView) return _product;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Products(product: $product)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Products'))
      ..add(DiagnosticsProperty('product', product));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsImpl &&
            const DeepCollectionEquality().equals(other._product, _product));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_product));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsImplCopyWith<_$ProductsImpl> get copyWith =>
      __$$ProductsImplCopyWithImpl<_$ProductsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductsImplToJson(
      this,
    );
  }
}

abstract class _Products implements Products {
  const factory _Products(
          {@JsonKey(name: 'product') final List<Product>? product}) =
      _$ProductsImpl;

  factory _Products.fromJson(Map<String, dynamic> json) =
      _$ProductsImpl.fromJson;

  @override
  @JsonKey(name: 'product')
  List<Product>? get product;
  @override
  @JsonKey(ignore: true)
  _$$ProductsImplCopyWith<_$ProductsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  @JsonKey(name: 'app_sale_price')
  String? get appSalePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_price')
  String? get originalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_detail_url')
  String? get productDetailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_small_image_urls')
  ProductSmallImageUrls? get productSmallImageUrls =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'second_level_category_name')
  String? get secondLevelCategoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_sale_price')
  String? get targetSalePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'second_level_category_id')
  int? get secondLevelCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount')
  String? get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_main_image_url')
  String? get productMainImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_level_category_id')
  int? get firstLevelCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_sale_price_currency')
  String? get targetSalePriceCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_app_sale_price_currency')
  String? get targetAppSalePriceCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_price_currency')
  String? get originalPriceCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'shop_url')
  String? get shopUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_original_price_currency')
  String? get targetOriginalPriceCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_original_price')
  String? get targetOriginalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_video_url')
  String? get productVideoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_level_category_name')
  String? get firstLevelCategoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'promotion_link')
  String? get promotionLink => throw _privateConstructorUsedError;
  @JsonKey(name: 'evaluate_rate')
  String? get evaluateRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price')
  String? get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_title')
  String? get productTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'hot_product_commission_rate')
  String? get hotProductCommissionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'shop_id')
  int? get shopId => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_sale_price_currency')
  String? get appSalePriceCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price_currency')
  String? get salePriceCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastest_volume')
  int? get lastestVolume => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_app_sale_price')
  String? get targetAppSalePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'commission_rate')
  String? get commissionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'platform_product_type')
  String? get platformProductType => throw _privateConstructorUsedError;
  @JsonKey(name: 'ship_to_days')
  int? get shipToDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'relevant_market_commission_rate')
  String? get relevantMarketCommissionRate =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'promo_code_info')
  PromoCodeInfo? get promoCodeInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {@JsonKey(name: 'app_sale_price') String? appSalePrice,
      @JsonKey(name: 'original_price') String? originalPrice,
      @JsonKey(name: 'product_detail_url') String? productDetailUrl,
      @JsonKey(name: 'product_small_image_urls')
      ProductSmallImageUrls? productSmallImageUrls,
      @JsonKey(name: 'second_level_category_name')
      String? secondLevelCategoryName,
      @JsonKey(name: 'target_sale_price') String? targetSalePrice,
      @JsonKey(name: 'second_level_category_id') int? secondLevelCategoryId,
      @JsonKey(name: 'discount') String? discount,
      @JsonKey(name: 'product_main_image_url') String? productMainImageUrl,
      @JsonKey(name: 'first_level_category_id') int? firstLevelCategoryId,
      @JsonKey(name: 'target_sale_price_currency')
      String? targetSalePriceCurrency,
      @JsonKey(name: 'target_app_sale_price_currency')
      String? targetAppSalePriceCurrency,
      @JsonKey(name: 'original_price_currency') String? originalPriceCurrency,
      @JsonKey(name: 'shop_url') String? shopUrl,
      @JsonKey(name: 'target_original_price_currency')
      String? targetOriginalPriceCurrency,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'target_original_price') String? targetOriginalPrice,
      @JsonKey(name: 'product_video_url') String? productVideoUrl,
      @JsonKey(name: 'first_level_category_name')
      String? firstLevelCategoryName,
      @JsonKey(name: 'promotion_link') String? promotionLink,
      @JsonKey(name: 'evaluate_rate') String? evaluateRate,
      @JsonKey(name: 'sale_price') String? salePrice,
      @JsonKey(name: 'product_title') String? productTitle,
      @JsonKey(name: 'hot_product_commission_rate')
      String? hotProductCommissionRate,
      @JsonKey(name: 'shop_id') int? shopId,
      @JsonKey(name: 'app_sale_price_currency') String? appSalePriceCurrency,
      @JsonKey(name: 'sale_price_currency') String? salePriceCurrency,
      @JsonKey(name: 'lastest_volume') int? lastestVolume,
      @JsonKey(name: 'target_app_sale_price') String? targetAppSalePrice,
      @JsonKey(name: 'commission_rate') String? commissionRate,
      @JsonKey(name: 'platform_product_type') String? platformProductType,
      @JsonKey(name: 'ship_to_days') int? shipToDays,
      @JsonKey(name: 'relevant_market_commission_rate')
      String? relevantMarketCommissionRate,
      @JsonKey(name: 'promo_code_info') PromoCodeInfo? promoCodeInfo});

  $ProductSmallImageUrlsCopyWith<$Res>? get productSmallImageUrls;
  $PromoCodeInfoCopyWith<$Res>? get promoCodeInfo;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appSalePrice = freezed,
    Object? originalPrice = freezed,
    Object? productDetailUrl = freezed,
    Object? productSmallImageUrls = freezed,
    Object? secondLevelCategoryName = freezed,
    Object? targetSalePrice = freezed,
    Object? secondLevelCategoryId = freezed,
    Object? discount = freezed,
    Object? productMainImageUrl = freezed,
    Object? firstLevelCategoryId = freezed,
    Object? targetSalePriceCurrency = freezed,
    Object? targetAppSalePriceCurrency = freezed,
    Object? originalPriceCurrency = freezed,
    Object? shopUrl = freezed,
    Object? targetOriginalPriceCurrency = freezed,
    Object? productId = freezed,
    Object? targetOriginalPrice = freezed,
    Object? productVideoUrl = freezed,
    Object? firstLevelCategoryName = freezed,
    Object? promotionLink = freezed,
    Object? evaluateRate = freezed,
    Object? salePrice = freezed,
    Object? productTitle = freezed,
    Object? hotProductCommissionRate = freezed,
    Object? shopId = freezed,
    Object? appSalePriceCurrency = freezed,
    Object? salePriceCurrency = freezed,
    Object? lastestVolume = freezed,
    Object? targetAppSalePrice = freezed,
    Object? commissionRate = freezed,
    Object? platformProductType = freezed,
    Object? shipToDays = freezed,
    Object? relevantMarketCommissionRate = freezed,
    Object? promoCodeInfo = freezed,
  }) {
    return _then(_value.copyWith(
      appSalePrice: freezed == appSalePrice
          ? _value.appSalePrice
          : appSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      productDetailUrl: freezed == productDetailUrl
          ? _value.productDetailUrl
          : productDetailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productSmallImageUrls: freezed == productSmallImageUrls
          ? _value.productSmallImageUrls
          : productSmallImageUrls // ignore: cast_nullable_to_non_nullable
              as ProductSmallImageUrls?,
      secondLevelCategoryName: freezed == secondLevelCategoryName
          ? _value.secondLevelCategoryName
          : secondLevelCategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetSalePrice: freezed == targetSalePrice
          ? _value.targetSalePrice
          : targetSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      secondLevelCategoryId: freezed == secondLevelCategoryId
          ? _value.secondLevelCategoryId
          : secondLevelCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String?,
      productMainImageUrl: freezed == productMainImageUrl
          ? _value.productMainImageUrl
          : productMainImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      firstLevelCategoryId: freezed == firstLevelCategoryId
          ? _value.firstLevelCategoryId
          : firstLevelCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetSalePriceCurrency: freezed == targetSalePriceCurrency
          ? _value.targetSalePriceCurrency
          : targetSalePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      targetAppSalePriceCurrency: freezed == targetAppSalePriceCurrency
          ? _value.targetAppSalePriceCurrency
          : targetAppSalePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPriceCurrency: freezed == originalPriceCurrency
          ? _value.originalPriceCurrency
          : originalPriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      shopUrl: freezed == shopUrl
          ? _value.shopUrl
          : shopUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      targetOriginalPriceCurrency: freezed == targetOriginalPriceCurrency
          ? _value.targetOriginalPriceCurrency
          : targetOriginalPriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetOriginalPrice: freezed == targetOriginalPrice
          ? _value.targetOriginalPrice
          : targetOriginalPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      productVideoUrl: freezed == productVideoUrl
          ? _value.productVideoUrl
          : productVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      firstLevelCategoryName: freezed == firstLevelCategoryName
          ? _value.firstLevelCategoryName
          : firstLevelCategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionLink: freezed == promotionLink
          ? _value.promotionLink
          : promotionLink // ignore: cast_nullable_to_non_nullable
              as String?,
      evaluateRate: freezed == evaluateRate
          ? _value.evaluateRate
          : evaluateRate // ignore: cast_nullable_to_non_nullable
              as String?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      productTitle: freezed == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      hotProductCommissionRate: freezed == hotProductCommissionRate
          ? _value.hotProductCommissionRate
          : hotProductCommissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      shopId: freezed == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as int?,
      appSalePriceCurrency: freezed == appSalePriceCurrency
          ? _value.appSalePriceCurrency
          : appSalePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      salePriceCurrency: freezed == salePriceCurrency
          ? _value.salePriceCurrency
          : salePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      lastestVolume: freezed == lastestVolume
          ? _value.lastestVolume
          : lastestVolume // ignore: cast_nullable_to_non_nullable
              as int?,
      targetAppSalePrice: freezed == targetAppSalePrice
          ? _value.targetAppSalePrice
          : targetAppSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      platformProductType: freezed == platformProductType
          ? _value.platformProductType
          : platformProductType // ignore: cast_nullable_to_non_nullable
              as String?,
      shipToDays: freezed == shipToDays
          ? _value.shipToDays
          : shipToDays // ignore: cast_nullable_to_non_nullable
              as int?,
      relevantMarketCommissionRate: freezed == relevantMarketCommissionRate
          ? _value.relevantMarketCommissionRate
          : relevantMarketCommissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      promoCodeInfo: freezed == promoCodeInfo
          ? _value.promoCodeInfo
          : promoCodeInfo // ignore: cast_nullable_to_non_nullable
              as PromoCodeInfo?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductSmallImageUrlsCopyWith<$Res>? get productSmallImageUrls {
    if (_value.productSmallImageUrls == null) {
      return null;
    }

    return $ProductSmallImageUrlsCopyWith<$Res>(_value.productSmallImageUrls!,
        (value) {
      return _then(_value.copyWith(productSmallImageUrls: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PromoCodeInfoCopyWith<$Res>? get promoCodeInfo {
    if (_value.promoCodeInfo == null) {
      return null;
    }

    return $PromoCodeInfoCopyWith<$Res>(_value.promoCodeInfo!, (value) {
      return _then(_value.copyWith(promoCodeInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'app_sale_price') String? appSalePrice,
      @JsonKey(name: 'original_price') String? originalPrice,
      @JsonKey(name: 'product_detail_url') String? productDetailUrl,
      @JsonKey(name: 'product_small_image_urls')
      ProductSmallImageUrls? productSmallImageUrls,
      @JsonKey(name: 'second_level_category_name')
      String? secondLevelCategoryName,
      @JsonKey(name: 'target_sale_price') String? targetSalePrice,
      @JsonKey(name: 'second_level_category_id') int? secondLevelCategoryId,
      @JsonKey(name: 'discount') String? discount,
      @JsonKey(name: 'product_main_image_url') String? productMainImageUrl,
      @JsonKey(name: 'first_level_category_id') int? firstLevelCategoryId,
      @JsonKey(name: 'target_sale_price_currency')
      String? targetSalePriceCurrency,
      @JsonKey(name: 'target_app_sale_price_currency')
      String? targetAppSalePriceCurrency,
      @JsonKey(name: 'original_price_currency') String? originalPriceCurrency,
      @JsonKey(name: 'shop_url') String? shopUrl,
      @JsonKey(name: 'target_original_price_currency')
      String? targetOriginalPriceCurrency,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'target_original_price') String? targetOriginalPrice,
      @JsonKey(name: 'product_video_url') String? productVideoUrl,
      @JsonKey(name: 'first_level_category_name')
      String? firstLevelCategoryName,
      @JsonKey(name: 'promotion_link') String? promotionLink,
      @JsonKey(name: 'evaluate_rate') String? evaluateRate,
      @JsonKey(name: 'sale_price') String? salePrice,
      @JsonKey(name: 'product_title') String? productTitle,
      @JsonKey(name: 'hot_product_commission_rate')
      String? hotProductCommissionRate,
      @JsonKey(name: 'shop_id') int? shopId,
      @JsonKey(name: 'app_sale_price_currency') String? appSalePriceCurrency,
      @JsonKey(name: 'sale_price_currency') String? salePriceCurrency,
      @JsonKey(name: 'lastest_volume') int? lastestVolume,
      @JsonKey(name: 'target_app_sale_price') String? targetAppSalePrice,
      @JsonKey(name: 'commission_rate') String? commissionRate,
      @JsonKey(name: 'platform_product_type') String? platformProductType,
      @JsonKey(name: 'ship_to_days') int? shipToDays,
      @JsonKey(name: 'relevant_market_commission_rate')
      String? relevantMarketCommissionRate,
      @JsonKey(name: 'promo_code_info') PromoCodeInfo? promoCodeInfo});

  @override
  $ProductSmallImageUrlsCopyWith<$Res>? get productSmallImageUrls;
  @override
  $PromoCodeInfoCopyWith<$Res>? get promoCodeInfo;
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appSalePrice = freezed,
    Object? originalPrice = freezed,
    Object? productDetailUrl = freezed,
    Object? productSmallImageUrls = freezed,
    Object? secondLevelCategoryName = freezed,
    Object? targetSalePrice = freezed,
    Object? secondLevelCategoryId = freezed,
    Object? discount = freezed,
    Object? productMainImageUrl = freezed,
    Object? firstLevelCategoryId = freezed,
    Object? targetSalePriceCurrency = freezed,
    Object? targetAppSalePriceCurrency = freezed,
    Object? originalPriceCurrency = freezed,
    Object? shopUrl = freezed,
    Object? targetOriginalPriceCurrency = freezed,
    Object? productId = freezed,
    Object? targetOriginalPrice = freezed,
    Object? productVideoUrl = freezed,
    Object? firstLevelCategoryName = freezed,
    Object? promotionLink = freezed,
    Object? evaluateRate = freezed,
    Object? salePrice = freezed,
    Object? productTitle = freezed,
    Object? hotProductCommissionRate = freezed,
    Object? shopId = freezed,
    Object? appSalePriceCurrency = freezed,
    Object? salePriceCurrency = freezed,
    Object? lastestVolume = freezed,
    Object? targetAppSalePrice = freezed,
    Object? commissionRate = freezed,
    Object? platformProductType = freezed,
    Object? shipToDays = freezed,
    Object? relevantMarketCommissionRate = freezed,
    Object? promoCodeInfo = freezed,
  }) {
    return _then(_$ProductImpl(
      appSalePrice: freezed == appSalePrice
          ? _value.appSalePrice
          : appSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      productDetailUrl: freezed == productDetailUrl
          ? _value.productDetailUrl
          : productDetailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productSmallImageUrls: freezed == productSmallImageUrls
          ? _value.productSmallImageUrls
          : productSmallImageUrls // ignore: cast_nullable_to_non_nullable
              as ProductSmallImageUrls?,
      secondLevelCategoryName: freezed == secondLevelCategoryName
          ? _value.secondLevelCategoryName
          : secondLevelCategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetSalePrice: freezed == targetSalePrice
          ? _value.targetSalePrice
          : targetSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      secondLevelCategoryId: freezed == secondLevelCategoryId
          ? _value.secondLevelCategoryId
          : secondLevelCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String?,
      productMainImageUrl: freezed == productMainImageUrl
          ? _value.productMainImageUrl
          : productMainImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      firstLevelCategoryId: freezed == firstLevelCategoryId
          ? _value.firstLevelCategoryId
          : firstLevelCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetSalePriceCurrency: freezed == targetSalePriceCurrency
          ? _value.targetSalePriceCurrency
          : targetSalePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      targetAppSalePriceCurrency: freezed == targetAppSalePriceCurrency
          ? _value.targetAppSalePriceCurrency
          : targetAppSalePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPriceCurrency: freezed == originalPriceCurrency
          ? _value.originalPriceCurrency
          : originalPriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      shopUrl: freezed == shopUrl
          ? _value.shopUrl
          : shopUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      targetOriginalPriceCurrency: freezed == targetOriginalPriceCurrency
          ? _value.targetOriginalPriceCurrency
          : targetOriginalPriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetOriginalPrice: freezed == targetOriginalPrice
          ? _value.targetOriginalPrice
          : targetOriginalPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      productVideoUrl: freezed == productVideoUrl
          ? _value.productVideoUrl
          : productVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      firstLevelCategoryName: freezed == firstLevelCategoryName
          ? _value.firstLevelCategoryName
          : firstLevelCategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionLink: freezed == promotionLink
          ? _value.promotionLink
          : promotionLink // ignore: cast_nullable_to_non_nullable
              as String?,
      evaluateRate: freezed == evaluateRate
          ? _value.evaluateRate
          : evaluateRate // ignore: cast_nullable_to_non_nullable
              as String?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      productTitle: freezed == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      hotProductCommissionRate: freezed == hotProductCommissionRate
          ? _value.hotProductCommissionRate
          : hotProductCommissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      shopId: freezed == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as int?,
      appSalePriceCurrency: freezed == appSalePriceCurrency
          ? _value.appSalePriceCurrency
          : appSalePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      salePriceCurrency: freezed == salePriceCurrency
          ? _value.salePriceCurrency
          : salePriceCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      lastestVolume: freezed == lastestVolume
          ? _value.lastestVolume
          : lastestVolume // ignore: cast_nullable_to_non_nullable
              as int?,
      targetAppSalePrice: freezed == targetAppSalePrice
          ? _value.targetAppSalePrice
          : targetAppSalePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      platformProductType: freezed == platformProductType
          ? _value.platformProductType
          : platformProductType // ignore: cast_nullable_to_non_nullable
              as String?,
      shipToDays: freezed == shipToDays
          ? _value.shipToDays
          : shipToDays // ignore: cast_nullable_to_non_nullable
              as int?,
      relevantMarketCommissionRate: freezed == relevantMarketCommissionRate
          ? _value.relevantMarketCommissionRate
          : relevantMarketCommissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      promoCodeInfo: freezed == promoCodeInfo
          ? _value.promoCodeInfo
          : promoCodeInfo // ignore: cast_nullable_to_non_nullable
              as PromoCodeInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl with DiagnosticableTreeMixin implements _Product {
  const _$ProductImpl(
      {@JsonKey(name: 'app_sale_price') this.appSalePrice,
      @JsonKey(name: 'original_price') this.originalPrice,
      @JsonKey(name: 'product_detail_url') this.productDetailUrl,
      @JsonKey(name: 'product_small_image_urls') this.productSmallImageUrls,
      @JsonKey(name: 'second_level_category_name') this.secondLevelCategoryName,
      @JsonKey(name: 'target_sale_price') this.targetSalePrice,
      @JsonKey(name: 'second_level_category_id') this.secondLevelCategoryId,
      @JsonKey(name: 'discount') this.discount,
      @JsonKey(name: 'product_main_image_url') this.productMainImageUrl,
      @JsonKey(name: 'first_level_category_id') this.firstLevelCategoryId,
      @JsonKey(name: 'target_sale_price_currency') this.targetSalePriceCurrency,
      @JsonKey(name: 'target_app_sale_price_currency')
      this.targetAppSalePriceCurrency,
      @JsonKey(name: 'original_price_currency') this.originalPriceCurrency,
      @JsonKey(name: 'shop_url') this.shopUrl,
      @JsonKey(name: 'target_original_price_currency')
      this.targetOriginalPriceCurrency,
      @JsonKey(name: 'product_id') this.productId,
      @JsonKey(name: 'target_original_price') this.targetOriginalPrice,
      @JsonKey(name: 'product_video_url') this.productVideoUrl,
      @JsonKey(name: 'first_level_category_name') this.firstLevelCategoryName,
      @JsonKey(name: 'promotion_link') this.promotionLink,
      @JsonKey(name: 'evaluate_rate') this.evaluateRate,
      @JsonKey(name: 'sale_price') this.salePrice,
      @JsonKey(name: 'product_title') this.productTitle,
      @JsonKey(name: 'hot_product_commission_rate')
      this.hotProductCommissionRate,
      @JsonKey(name: 'shop_id') this.shopId,
      @JsonKey(name: 'app_sale_price_currency') this.appSalePriceCurrency,
      @JsonKey(name: 'sale_price_currency') this.salePriceCurrency,
      @JsonKey(name: 'lastest_volume') this.lastestVolume,
      @JsonKey(name: 'target_app_sale_price') this.targetAppSalePrice,
      @JsonKey(name: 'commission_rate') this.commissionRate,
      @JsonKey(name: 'platform_product_type') this.platformProductType,
      @JsonKey(name: 'ship_to_days') this.shipToDays,
      @JsonKey(name: 'relevant_market_commission_rate')
      this.relevantMarketCommissionRate,
      @JsonKey(name: 'promo_code_info') this.promoCodeInfo});

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  @JsonKey(name: 'app_sale_price')
  final String? appSalePrice;
  @override
  @JsonKey(name: 'original_price')
  final String? originalPrice;
  @override
  @JsonKey(name: 'product_detail_url')
  final String? productDetailUrl;
  @override
  @JsonKey(name: 'product_small_image_urls')
  final ProductSmallImageUrls? productSmallImageUrls;
  @override
  @JsonKey(name: 'second_level_category_name')
  final String? secondLevelCategoryName;
  @override
  @JsonKey(name: 'target_sale_price')
  final String? targetSalePrice;
  @override
  @JsonKey(name: 'second_level_category_id')
  final int? secondLevelCategoryId;
  @override
  @JsonKey(name: 'discount')
  final String? discount;
  @override
  @JsonKey(name: 'product_main_image_url')
  final String? productMainImageUrl;
  @override
  @JsonKey(name: 'first_level_category_id')
  final int? firstLevelCategoryId;
  @override
  @JsonKey(name: 'target_sale_price_currency')
  final String? targetSalePriceCurrency;
  @override
  @JsonKey(name: 'target_app_sale_price_currency')
  final String? targetAppSalePriceCurrency;
  @override
  @JsonKey(name: 'original_price_currency')
  final String? originalPriceCurrency;
  @override
  @JsonKey(name: 'shop_url')
  final String? shopUrl;
  @override
  @JsonKey(name: 'target_original_price_currency')
  final String? targetOriginalPriceCurrency;
  @override
  @JsonKey(name: 'product_id')
  final int? productId;
  @override
  @JsonKey(name: 'target_original_price')
  final String? targetOriginalPrice;
  @override
  @JsonKey(name: 'product_video_url')
  final String? productVideoUrl;
  @override
  @JsonKey(name: 'first_level_category_name')
  final String? firstLevelCategoryName;
  @override
  @JsonKey(name: 'promotion_link')
  final String? promotionLink;
  @override
  @JsonKey(name: 'evaluate_rate')
  final String? evaluateRate;
  @override
  @JsonKey(name: 'sale_price')
  final String? salePrice;
  @override
  @JsonKey(name: 'product_title')
  final String? productTitle;
  @override
  @JsonKey(name: 'hot_product_commission_rate')
  final String? hotProductCommissionRate;
  @override
  @JsonKey(name: 'shop_id')
  final int? shopId;
  @override
  @JsonKey(name: 'app_sale_price_currency')
  final String? appSalePriceCurrency;
  @override
  @JsonKey(name: 'sale_price_currency')
  final String? salePriceCurrency;
  @override
  @JsonKey(name: 'lastest_volume')
  final int? lastestVolume;
  @override
  @JsonKey(name: 'target_app_sale_price')
  final String? targetAppSalePrice;
  @override
  @JsonKey(name: 'commission_rate')
  final String? commissionRate;
  @override
  @JsonKey(name: 'platform_product_type')
  final String? platformProductType;
  @override
  @JsonKey(name: 'ship_to_days')
  final int? shipToDays;
  @override
  @JsonKey(name: 'relevant_market_commission_rate')
  final String? relevantMarketCommissionRate;
  @override
  @JsonKey(name: 'promo_code_info')
  final PromoCodeInfo? promoCodeInfo;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Product(appSalePrice: $appSalePrice, originalPrice: $originalPrice, productDetailUrl: $productDetailUrl, productSmallImageUrls: $productSmallImageUrls, secondLevelCategoryName: $secondLevelCategoryName, targetSalePrice: $targetSalePrice, secondLevelCategoryId: $secondLevelCategoryId, discount: $discount, productMainImageUrl: $productMainImageUrl, firstLevelCategoryId: $firstLevelCategoryId, targetSalePriceCurrency: $targetSalePriceCurrency, targetAppSalePriceCurrency: $targetAppSalePriceCurrency, originalPriceCurrency: $originalPriceCurrency, shopUrl: $shopUrl, targetOriginalPriceCurrency: $targetOriginalPriceCurrency, productId: $productId, targetOriginalPrice: $targetOriginalPrice, productVideoUrl: $productVideoUrl, firstLevelCategoryName: $firstLevelCategoryName, promotionLink: $promotionLink, evaluateRate: $evaluateRate, salePrice: $salePrice, productTitle: $productTitle, hotProductCommissionRate: $hotProductCommissionRate, shopId: $shopId, appSalePriceCurrency: $appSalePriceCurrency, salePriceCurrency: $salePriceCurrency, lastestVolume: $lastestVolume, targetAppSalePrice: $targetAppSalePrice, commissionRate: $commissionRate, platformProductType: $platformProductType, shipToDays: $shipToDays, relevantMarketCommissionRate: $relevantMarketCommissionRate, promoCodeInfo: $promoCodeInfo)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Product'))
      ..add(DiagnosticsProperty('appSalePrice', appSalePrice))
      ..add(DiagnosticsProperty('originalPrice', originalPrice))
      ..add(DiagnosticsProperty('productDetailUrl', productDetailUrl))
      ..add(DiagnosticsProperty('productSmallImageUrls', productSmallImageUrls))
      ..add(DiagnosticsProperty(
          'secondLevelCategoryName', secondLevelCategoryName))
      ..add(DiagnosticsProperty('targetSalePrice', targetSalePrice))
      ..add(DiagnosticsProperty('secondLevelCategoryId', secondLevelCategoryId))
      ..add(DiagnosticsProperty('discount', discount))
      ..add(DiagnosticsProperty('productMainImageUrl', productMainImageUrl))
      ..add(DiagnosticsProperty('firstLevelCategoryId', firstLevelCategoryId))
      ..add(DiagnosticsProperty(
          'targetSalePriceCurrency', targetSalePriceCurrency))
      ..add(DiagnosticsProperty(
          'targetAppSalePriceCurrency', targetAppSalePriceCurrency))
      ..add(DiagnosticsProperty('originalPriceCurrency', originalPriceCurrency))
      ..add(DiagnosticsProperty('shopUrl', shopUrl))
      ..add(DiagnosticsProperty(
          'targetOriginalPriceCurrency', targetOriginalPriceCurrency))
      ..add(DiagnosticsProperty('productId', productId))
      ..add(DiagnosticsProperty('targetOriginalPrice', targetOriginalPrice))
      ..add(DiagnosticsProperty('productVideoUrl', productVideoUrl))
      ..add(
          DiagnosticsProperty('firstLevelCategoryName', firstLevelCategoryName))
      ..add(DiagnosticsProperty('promotionLink', promotionLink))
      ..add(DiagnosticsProperty('evaluateRate', evaluateRate))
      ..add(DiagnosticsProperty('salePrice', salePrice))
      ..add(DiagnosticsProperty('productTitle', productTitle))
      ..add(DiagnosticsProperty(
          'hotProductCommissionRate', hotProductCommissionRate))
      ..add(DiagnosticsProperty('shopId', shopId))
      ..add(DiagnosticsProperty('appSalePriceCurrency', appSalePriceCurrency))
      ..add(DiagnosticsProperty('salePriceCurrency', salePriceCurrency))
      ..add(DiagnosticsProperty('lastestVolume', lastestVolume))
      ..add(DiagnosticsProperty('targetAppSalePrice', targetAppSalePrice))
      ..add(DiagnosticsProperty('commissionRate', commissionRate))
      ..add(DiagnosticsProperty('platformProductType', platformProductType))
      ..add(DiagnosticsProperty('shipToDays', shipToDays))
      ..add(DiagnosticsProperty(
          'relevantMarketCommissionRate', relevantMarketCommissionRate))
      ..add(DiagnosticsProperty('promoCodeInfo', promoCodeInfo));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.appSalePrice, appSalePrice) ||
                other.appSalePrice == appSalePrice) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.productDetailUrl, productDetailUrl) ||
                other.productDetailUrl == productDetailUrl) &&
            (identical(other.productSmallImageUrls, productSmallImageUrls) ||
                other.productSmallImageUrls == productSmallImageUrls) &&
            (identical(other.secondLevelCategoryName, secondLevelCategoryName) ||
                other.secondLevelCategoryName == secondLevelCategoryName) &&
            (identical(other.targetSalePrice, targetSalePrice) ||
                other.targetSalePrice == targetSalePrice) &&
            (identical(other.secondLevelCategoryId, secondLevelCategoryId) ||
                other.secondLevelCategoryId == secondLevelCategoryId) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.productMainImageUrl, productMainImageUrl) ||
                other.productMainImageUrl == productMainImageUrl) &&
            (identical(other.firstLevelCategoryId, firstLevelCategoryId) ||
                other.firstLevelCategoryId == firstLevelCategoryId) &&
            (identical(other.targetSalePriceCurrency, targetSalePriceCurrency) ||
                other.targetSalePriceCurrency == targetSalePriceCurrency) &&
            (identical(other.targetAppSalePriceCurrency, targetAppSalePriceCurrency) ||
                other.targetAppSalePriceCurrency ==
                    targetAppSalePriceCurrency) &&
            (identical(other.originalPriceCurrency, originalPriceCurrency) ||
                other.originalPriceCurrency == originalPriceCurrency) &&
            (identical(other.shopUrl, shopUrl) || other.shopUrl == shopUrl) &&
            (identical(other.targetOriginalPriceCurrency, targetOriginalPriceCurrency) ||
                other.targetOriginalPriceCurrency ==
                    targetOriginalPriceCurrency) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.targetOriginalPrice, targetOriginalPrice) ||
                other.targetOriginalPrice == targetOriginalPrice) &&
            (identical(other.productVideoUrl, productVideoUrl) ||
                other.productVideoUrl == productVideoUrl) &&
            (identical(other.firstLevelCategoryName, firstLevelCategoryName) ||
                other.firstLevelCategoryName == firstLevelCategoryName) &&
            (identical(other.promotionLink, promotionLink) ||
                other.promotionLink == promotionLink) &&
            (identical(other.evaluateRate, evaluateRate) ||
                other.evaluateRate == evaluateRate) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.productTitle, productTitle) ||
                other.productTitle == productTitle) &&
            (identical(other.hotProductCommissionRate, hotProductCommissionRate) ||
                other.hotProductCommissionRate == hotProductCommissionRate) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.appSalePriceCurrency, appSalePriceCurrency) ||
                other.appSalePriceCurrency == appSalePriceCurrency) &&
            (identical(other.salePriceCurrency, salePriceCurrency) ||
                other.salePriceCurrency == salePriceCurrency) &&
            (identical(other.lastestVolume, lastestVolume) ||
                other.lastestVolume == lastestVolume) &&
            (identical(other.targetAppSalePrice, targetAppSalePrice) || other.targetAppSalePrice == targetAppSalePrice) &&
            (identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate) &&
            (identical(other.platformProductType, platformProductType) || other.platformProductType == platformProductType) &&
            (identical(other.shipToDays, shipToDays) || other.shipToDays == shipToDays) &&
            (identical(other.relevantMarketCommissionRate, relevantMarketCommissionRate) || other.relevantMarketCommissionRate == relevantMarketCommissionRate) &&
            (identical(other.promoCodeInfo, promoCodeInfo) || other.promoCodeInfo == promoCodeInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        appSalePrice,
        originalPrice,
        productDetailUrl,
        productSmallImageUrls,
        secondLevelCategoryName,
        targetSalePrice,
        secondLevelCategoryId,
        discount,
        productMainImageUrl,
        firstLevelCategoryId,
        targetSalePriceCurrency,
        targetAppSalePriceCurrency,
        originalPriceCurrency,
        shopUrl,
        targetOriginalPriceCurrency,
        productId,
        targetOriginalPrice,
        productVideoUrl,
        firstLevelCategoryName,
        promotionLink,
        evaluateRate,
        salePrice,
        productTitle,
        hotProductCommissionRate,
        shopId,
        appSalePriceCurrency,
        salePriceCurrency,
        lastestVolume,
        targetAppSalePrice,
        commissionRate,
        platformProductType,
        shipToDays,
        relevantMarketCommissionRate,
        promoCodeInfo
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {@JsonKey(name: 'app_sale_price') final String? appSalePrice,
      @JsonKey(name: 'original_price') final String? originalPrice,
      @JsonKey(name: 'product_detail_url') final String? productDetailUrl,
      @JsonKey(name: 'product_small_image_urls')
      final ProductSmallImageUrls? productSmallImageUrls,
      @JsonKey(name: 'second_level_category_name')
      final String? secondLevelCategoryName,
      @JsonKey(name: 'target_sale_price') final String? targetSalePrice,
      @JsonKey(name: 'second_level_category_id')
      final int? secondLevelCategoryId,
      @JsonKey(name: 'discount') final String? discount,
      @JsonKey(name: 'product_main_image_url')
      final String? productMainImageUrl,
      @JsonKey(name: 'first_level_category_id') final int? firstLevelCategoryId,
      @JsonKey(name: 'target_sale_price_currency')
      final String? targetSalePriceCurrency,
      @JsonKey(name: 'target_app_sale_price_currency')
      final String? targetAppSalePriceCurrency,
      @JsonKey(name: 'original_price_currency')
      final String? originalPriceCurrency,
      @JsonKey(name: 'shop_url') final String? shopUrl,
      @JsonKey(name: 'target_original_price_currency')
      final String? targetOriginalPriceCurrency,
      @JsonKey(name: 'product_id') final int? productId,
      @JsonKey(name: 'target_original_price') final String? targetOriginalPrice,
      @JsonKey(name: 'product_video_url') final String? productVideoUrl,
      @JsonKey(name: 'first_level_category_name')
      final String? firstLevelCategoryName,
      @JsonKey(name: 'promotion_link') final String? promotionLink,
      @JsonKey(name: 'evaluate_rate') final String? evaluateRate,
      @JsonKey(name: 'sale_price') final String? salePrice,
      @JsonKey(name: 'product_title') final String? productTitle,
      @JsonKey(name: 'hot_product_commission_rate')
      final String? hotProductCommissionRate,
      @JsonKey(name: 'shop_id') final int? shopId,
      @JsonKey(name: 'app_sale_price_currency')
      final String? appSalePriceCurrency,
      @JsonKey(name: 'sale_price_currency') final String? salePriceCurrency,
      @JsonKey(name: 'lastest_volume') final int? lastestVolume,
      @JsonKey(name: 'target_app_sale_price') final String? targetAppSalePrice,
      @JsonKey(name: 'commission_rate') final String? commissionRate,
      @JsonKey(name: 'platform_product_type') final String? platformProductType,
      @JsonKey(name: 'ship_to_days') final int? shipToDays,
      @JsonKey(name: 'relevant_market_commission_rate')
      final String? relevantMarketCommissionRate,
      @JsonKey(name: 'promo_code_info')
      final PromoCodeInfo? promoCodeInfo}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  @JsonKey(name: 'app_sale_price')
  String? get appSalePrice;
  @override
  @JsonKey(name: 'original_price')
  String? get originalPrice;
  @override
  @JsonKey(name: 'product_detail_url')
  String? get productDetailUrl;
  @override
  @JsonKey(name: 'product_small_image_urls')
  ProductSmallImageUrls? get productSmallImageUrls;
  @override
  @JsonKey(name: 'second_level_category_name')
  String? get secondLevelCategoryName;
  @override
  @JsonKey(name: 'target_sale_price')
  String? get targetSalePrice;
  @override
  @JsonKey(name: 'second_level_category_id')
  int? get secondLevelCategoryId;
  @override
  @JsonKey(name: 'discount')
  String? get discount;
  @override
  @JsonKey(name: 'product_main_image_url')
  String? get productMainImageUrl;
  @override
  @JsonKey(name: 'first_level_category_id')
  int? get firstLevelCategoryId;
  @override
  @JsonKey(name: 'target_sale_price_currency')
  String? get targetSalePriceCurrency;
  @override
  @JsonKey(name: 'target_app_sale_price_currency')
  String? get targetAppSalePriceCurrency;
  @override
  @JsonKey(name: 'original_price_currency')
  String? get originalPriceCurrency;
  @override
  @JsonKey(name: 'shop_url')
  String? get shopUrl;
  @override
  @JsonKey(name: 'target_original_price_currency')
  String? get targetOriginalPriceCurrency;
  @override
  @JsonKey(name: 'product_id')
  int? get productId;
  @override
  @JsonKey(name: 'target_original_price')
  String? get targetOriginalPrice;
  @override
  @JsonKey(name: 'product_video_url')
  String? get productVideoUrl;
  @override
  @JsonKey(name: 'first_level_category_name')
  String? get firstLevelCategoryName;
  @override
  @JsonKey(name: 'promotion_link')
  String? get promotionLink;
  @override
  @JsonKey(name: 'evaluate_rate')
  String? get evaluateRate;
  @override
  @JsonKey(name: 'sale_price')
  String? get salePrice;
  @override
  @JsonKey(name: 'product_title')
  String? get productTitle;
  @override
  @JsonKey(name: 'hot_product_commission_rate')
  String? get hotProductCommissionRate;
  @override
  @JsonKey(name: 'shop_id')
  int? get shopId;
  @override
  @JsonKey(name: 'app_sale_price_currency')
  String? get appSalePriceCurrency;
  @override
  @JsonKey(name: 'sale_price_currency')
  String? get salePriceCurrency;
  @override
  @JsonKey(name: 'lastest_volume')
  int? get lastestVolume;
  @override
  @JsonKey(name: 'target_app_sale_price')
  String? get targetAppSalePrice;
  @override
  @JsonKey(name: 'commission_rate')
  String? get commissionRate;
  @override
  @JsonKey(name: 'platform_product_type')
  String? get platformProductType;
  @override
  @JsonKey(name: 'ship_to_days')
  int? get shipToDays;
  @override
  @JsonKey(name: 'relevant_market_commission_rate')
  String? get relevantMarketCommissionRate;
  @override
  @JsonKey(name: 'promo_code_info')
  PromoCodeInfo? get promoCodeInfo;
  @override
  @JsonKey(ignore: true)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSmallImageUrls _$ProductSmallImageUrlsFromJson(
    Map<String, dynamic> json) {
  return _ProductSmallImageUrls.fromJson(json);
}

/// @nodoc
mixin _$ProductSmallImageUrls {
  @JsonKey(name: 'string')
  List<String>? get string => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductSmallImageUrlsCopyWith<ProductSmallImageUrls> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSmallImageUrlsCopyWith<$Res> {
  factory $ProductSmallImageUrlsCopyWith(ProductSmallImageUrls value,
          $Res Function(ProductSmallImageUrls) then) =
      _$ProductSmallImageUrlsCopyWithImpl<$Res, ProductSmallImageUrls>;
  @useResult
  $Res call({@JsonKey(name: 'string') List<String>? string});
}

/// @nodoc
class _$ProductSmallImageUrlsCopyWithImpl<$Res,
        $Val extends ProductSmallImageUrls>
    implements $ProductSmallImageUrlsCopyWith<$Res> {
  _$ProductSmallImageUrlsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? string = freezed,
  }) {
    return _then(_value.copyWith(
      string: freezed == string
          ? _value.string
          : string // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductSmallImageUrlsImplCopyWith<$Res>
    implements $ProductSmallImageUrlsCopyWith<$Res> {
  factory _$$ProductSmallImageUrlsImplCopyWith(
          _$ProductSmallImageUrlsImpl value,
          $Res Function(_$ProductSmallImageUrlsImpl) then) =
      __$$ProductSmallImageUrlsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'string') List<String>? string});
}

/// @nodoc
class __$$ProductSmallImageUrlsImplCopyWithImpl<$Res>
    extends _$ProductSmallImageUrlsCopyWithImpl<$Res,
        _$ProductSmallImageUrlsImpl>
    implements _$$ProductSmallImageUrlsImplCopyWith<$Res> {
  __$$ProductSmallImageUrlsImplCopyWithImpl(_$ProductSmallImageUrlsImpl _value,
      $Res Function(_$ProductSmallImageUrlsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? string = freezed,
  }) {
    return _then(_$ProductSmallImageUrlsImpl(
      string: freezed == string
          ? _value._string
          : string // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSmallImageUrlsImpl
    with DiagnosticableTreeMixin
    implements _ProductSmallImageUrls {
  const _$ProductSmallImageUrlsImpl(
      {@JsonKey(name: 'string') final List<String>? string})
      : _string = string;

  factory _$ProductSmallImageUrlsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSmallImageUrlsImplFromJson(json);

  final List<String>? _string;
  @override
  @JsonKey(name: 'string')
  List<String>? get string {
    final value = _string;
    if (value == null) return null;
    if (_string is EqualUnmodifiableListView) return _string;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductSmallImageUrls(string: $string)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductSmallImageUrls'))
      ..add(DiagnosticsProperty('string', string));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSmallImageUrlsImpl &&
            const DeepCollectionEquality().equals(other._string, _string));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_string));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSmallImageUrlsImplCopyWith<_$ProductSmallImageUrlsImpl>
      get copyWith => __$$ProductSmallImageUrlsImplCopyWithImpl<
          _$ProductSmallImageUrlsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSmallImageUrlsImplToJson(
      this,
    );
  }
}

abstract class _ProductSmallImageUrls implements ProductSmallImageUrls {
  const factory _ProductSmallImageUrls(
          {@JsonKey(name: 'string') final List<String>? string}) =
      _$ProductSmallImageUrlsImpl;

  factory _ProductSmallImageUrls.fromJson(Map<String, dynamic> json) =
      _$ProductSmallImageUrlsImpl.fromJson;

  @override
  @JsonKey(name: 'string')
  List<String>? get string;
  @override
  @JsonKey(ignore: true)
  _$$ProductSmallImageUrlsImplCopyWith<_$ProductSmallImageUrlsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PromoCodeInfo _$PromoCodeInfoFromJson(Map<String, dynamic> json) {
  return _PromoCodeInfo.fromJson(json);
}

/// @nodoc
mixin _$PromoCodeInfo {
  @JsonKey(name: 'code_campaigntype')
  String? get codeCampaigntype => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_availabletime_end')
  String? get codeAvailabletimeEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_quantity')
  String? get codeQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_availabletime_start')
  String? get codeAvailabletimeStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_value')
  String? get codeValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'promo_code')
  String? get promoCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_mini_spend')
  String? get codeMiniSpend => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromoCodeInfoCopyWith<PromoCodeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromoCodeInfoCopyWith<$Res> {
  factory $PromoCodeInfoCopyWith(
          PromoCodeInfo value, $Res Function(PromoCodeInfo) then) =
      _$PromoCodeInfoCopyWithImpl<$Res, PromoCodeInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code_campaigntype') String? codeCampaigntype,
      @JsonKey(name: 'code_availabletime_end') String? codeAvailabletimeEnd,
      @JsonKey(name: 'code_quantity') String? codeQuantity,
      @JsonKey(name: 'code_availabletime_start') String? codeAvailabletimeStart,
      @JsonKey(name: 'code_value') String? codeValue,
      @JsonKey(name: 'promo_code') String? promoCode,
      @JsonKey(name: 'code_mini_spend') String? codeMiniSpend});
}

/// @nodoc
class _$PromoCodeInfoCopyWithImpl<$Res, $Val extends PromoCodeInfo>
    implements $PromoCodeInfoCopyWith<$Res> {
  _$PromoCodeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeCampaigntype = freezed,
    Object? codeAvailabletimeEnd = freezed,
    Object? codeQuantity = freezed,
    Object? codeAvailabletimeStart = freezed,
    Object? codeValue = freezed,
    Object? promoCode = freezed,
    Object? codeMiniSpend = freezed,
  }) {
    return _then(_value.copyWith(
      codeCampaigntype: freezed == codeCampaigntype
          ? _value.codeCampaigntype
          : codeCampaigntype // ignore: cast_nullable_to_non_nullable
              as String?,
      codeAvailabletimeEnd: freezed == codeAvailabletimeEnd
          ? _value.codeAvailabletimeEnd
          : codeAvailabletimeEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      codeQuantity: freezed == codeQuantity
          ? _value.codeQuantity
          : codeQuantity // ignore: cast_nullable_to_non_nullable
              as String?,
      codeAvailabletimeStart: freezed == codeAvailabletimeStart
          ? _value.codeAvailabletimeStart
          : codeAvailabletimeStart // ignore: cast_nullable_to_non_nullable
              as String?,
      codeValue: freezed == codeValue
          ? _value.codeValue
          : codeValue // ignore: cast_nullable_to_non_nullable
              as String?,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      codeMiniSpend: freezed == codeMiniSpend
          ? _value.codeMiniSpend
          : codeMiniSpend // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromoCodeInfoImplCopyWith<$Res>
    implements $PromoCodeInfoCopyWith<$Res> {
  factory _$$PromoCodeInfoImplCopyWith(
          _$PromoCodeInfoImpl value, $Res Function(_$PromoCodeInfoImpl) then) =
      __$$PromoCodeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code_campaigntype') String? codeCampaigntype,
      @JsonKey(name: 'code_availabletime_end') String? codeAvailabletimeEnd,
      @JsonKey(name: 'code_quantity') String? codeQuantity,
      @JsonKey(name: 'code_availabletime_start') String? codeAvailabletimeStart,
      @JsonKey(name: 'code_value') String? codeValue,
      @JsonKey(name: 'promo_code') String? promoCode,
      @JsonKey(name: 'code_mini_spend') String? codeMiniSpend});
}

/// @nodoc
class __$$PromoCodeInfoImplCopyWithImpl<$Res>
    extends _$PromoCodeInfoCopyWithImpl<$Res, _$PromoCodeInfoImpl>
    implements _$$PromoCodeInfoImplCopyWith<$Res> {
  __$$PromoCodeInfoImplCopyWithImpl(
      _$PromoCodeInfoImpl _value, $Res Function(_$PromoCodeInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeCampaigntype = freezed,
    Object? codeAvailabletimeEnd = freezed,
    Object? codeQuantity = freezed,
    Object? codeAvailabletimeStart = freezed,
    Object? codeValue = freezed,
    Object? promoCode = freezed,
    Object? codeMiniSpend = freezed,
  }) {
    return _then(_$PromoCodeInfoImpl(
      codeCampaigntype: freezed == codeCampaigntype
          ? _value.codeCampaigntype
          : codeCampaigntype // ignore: cast_nullable_to_non_nullable
              as String?,
      codeAvailabletimeEnd: freezed == codeAvailabletimeEnd
          ? _value.codeAvailabletimeEnd
          : codeAvailabletimeEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      codeQuantity: freezed == codeQuantity
          ? _value.codeQuantity
          : codeQuantity // ignore: cast_nullable_to_non_nullable
              as String?,
      codeAvailabletimeStart: freezed == codeAvailabletimeStart
          ? _value.codeAvailabletimeStart
          : codeAvailabletimeStart // ignore: cast_nullable_to_non_nullable
              as String?,
      codeValue: freezed == codeValue
          ? _value.codeValue
          : codeValue // ignore: cast_nullable_to_non_nullable
              as String?,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      codeMiniSpend: freezed == codeMiniSpend
          ? _value.codeMiniSpend
          : codeMiniSpend // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromoCodeInfoImpl
    with DiagnosticableTreeMixin
    implements _PromoCodeInfo {
  const _$PromoCodeInfoImpl(
      {@JsonKey(name: 'code_campaigntype') this.codeCampaigntype,
      @JsonKey(name: 'code_availabletime_end') this.codeAvailabletimeEnd,
      @JsonKey(name: 'code_quantity') this.codeQuantity,
      @JsonKey(name: 'code_availabletime_start') this.codeAvailabletimeStart,
      @JsonKey(name: 'code_value') this.codeValue,
      @JsonKey(name: 'promo_code') this.promoCode,
      @JsonKey(name: 'code_mini_spend') this.codeMiniSpend});

  factory _$PromoCodeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromoCodeInfoImplFromJson(json);

  @override
  @JsonKey(name: 'code_campaigntype')
  final String? codeCampaigntype;
  @override
  @JsonKey(name: 'code_availabletime_end')
  final String? codeAvailabletimeEnd;
  @override
  @JsonKey(name: 'code_quantity')
  final String? codeQuantity;
  @override
  @JsonKey(name: 'code_availabletime_start')
  final String? codeAvailabletimeStart;
  @override
  @JsonKey(name: 'code_value')
  final String? codeValue;
  @override
  @JsonKey(name: 'promo_code')
  final String? promoCode;
  @override
  @JsonKey(name: 'code_mini_spend')
  final String? codeMiniSpend;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PromoCodeInfo(codeCampaigntype: $codeCampaigntype, codeAvailabletimeEnd: $codeAvailabletimeEnd, codeQuantity: $codeQuantity, codeAvailabletimeStart: $codeAvailabletimeStart, codeValue: $codeValue, promoCode: $promoCode, codeMiniSpend: $codeMiniSpend)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PromoCodeInfo'))
      ..add(DiagnosticsProperty('codeCampaigntype', codeCampaigntype))
      ..add(DiagnosticsProperty('codeAvailabletimeEnd', codeAvailabletimeEnd))
      ..add(DiagnosticsProperty('codeQuantity', codeQuantity))
      ..add(
          DiagnosticsProperty('codeAvailabletimeStart', codeAvailabletimeStart))
      ..add(DiagnosticsProperty('codeValue', codeValue))
      ..add(DiagnosticsProperty('promoCode', promoCode))
      ..add(DiagnosticsProperty('codeMiniSpend', codeMiniSpend));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromoCodeInfoImpl &&
            (identical(other.codeCampaigntype, codeCampaigntype) ||
                other.codeCampaigntype == codeCampaigntype) &&
            (identical(other.codeAvailabletimeEnd, codeAvailabletimeEnd) ||
                other.codeAvailabletimeEnd == codeAvailabletimeEnd) &&
            (identical(other.codeQuantity, codeQuantity) ||
                other.codeQuantity == codeQuantity) &&
            (identical(other.codeAvailabletimeStart, codeAvailabletimeStart) ||
                other.codeAvailabletimeStart == codeAvailabletimeStart) &&
            (identical(other.codeValue, codeValue) ||
                other.codeValue == codeValue) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.codeMiniSpend, codeMiniSpend) ||
                other.codeMiniSpend == codeMiniSpend));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      codeCampaigntype,
      codeAvailabletimeEnd,
      codeQuantity,
      codeAvailabletimeStart,
      codeValue,
      promoCode,
      codeMiniSpend);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromoCodeInfoImplCopyWith<_$PromoCodeInfoImpl> get copyWith =>
      __$$PromoCodeInfoImplCopyWithImpl<_$PromoCodeInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromoCodeInfoImplToJson(
      this,
    );
  }
}

abstract class _PromoCodeInfo implements PromoCodeInfo {
  const factory _PromoCodeInfo(
          {@JsonKey(name: 'code_campaigntype') final String? codeCampaigntype,
          @JsonKey(name: 'code_availabletime_end')
          final String? codeAvailabletimeEnd,
          @JsonKey(name: 'code_quantity') final String? codeQuantity,
          @JsonKey(name: 'code_availabletime_start')
          final String? codeAvailabletimeStart,
          @JsonKey(name: 'code_value') final String? codeValue,
          @JsonKey(name: 'promo_code') final String? promoCode,
          @JsonKey(name: 'code_mini_spend') final String? codeMiniSpend}) =
      _$PromoCodeInfoImpl;

  factory _PromoCodeInfo.fromJson(Map<String, dynamic> json) =
      _$PromoCodeInfoImpl.fromJson;

  @override
  @JsonKey(name: 'code_campaigntype')
  String? get codeCampaigntype;
  @override
  @JsonKey(name: 'code_availabletime_end')
  String? get codeAvailabletimeEnd;
  @override
  @JsonKey(name: 'code_quantity')
  String? get codeQuantity;
  @override
  @JsonKey(name: 'code_availabletime_start')
  String? get codeAvailabletimeStart;
  @override
  @JsonKey(name: 'code_value')
  String? get codeValue;
  @override
  @JsonKey(name: 'promo_code')
  String? get promoCode;
  @override
  @JsonKey(name: 'code_mini_spend')
  String? get codeMiniSpend;
  @override
  @JsonKey(ignore: true)
  _$$PromoCodeInfoImplCopyWith<_$PromoCodeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
