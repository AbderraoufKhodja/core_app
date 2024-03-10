// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_hot_products_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetHotProductsResult _$GetHotProductsResultFromJson(Map<String, dynamic> json) {
  return _GetHotProductsResult.fromJson(json);
}

/// @nodoc
mixin _$GetHotProductsResult {
  int? get currentRecordCount => throw _privateConstructorUsedError;
  int? get totalRecordCount => throw _privateConstructorUsedError;
  int? get currentPageNo => throw _privateConstructorUsedError;
  Map<String, dynamic>? get products => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetHotProductsResultCopyWith<GetHotProductsResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetHotProductsResultCopyWith<$Res> {
  factory $GetHotProductsResultCopyWith(GetHotProductsResult value,
          $Res Function(GetHotProductsResult) then) =
      _$GetHotProductsResultCopyWithImpl<$Res, GetHotProductsResult>;
  @useResult
  $Res call(
      {int? currentRecordCount,
      int? totalRecordCount,
      int? currentPageNo,
      Map<String, dynamic>? products});
}

/// @nodoc
class _$GetHotProductsResultCopyWithImpl<$Res,
        $Val extends GetHotProductsResult>
    implements $GetHotProductsResultCopyWith<$Res> {
  _$GetHotProductsResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRecordCount = freezed,
    Object? totalRecordCount = freezed,
    Object? currentPageNo = freezed,
    Object? products = freezed,
  }) {
    return _then(_value.copyWith(
      currentRecordCount: freezed == currentRecordCount
          ? _value.currentRecordCount
          : currentRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      currentPageNo: freezed == currentPageNo
          ? _value.currentPageNo
          : currentPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      products: freezed == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetHotProductsResultImplCopyWith<$Res>
    implements $GetHotProductsResultCopyWith<$Res> {
  factory _$$GetHotProductsResultImplCopyWith(_$GetHotProductsResultImpl value,
          $Res Function(_$GetHotProductsResultImpl) then) =
      __$$GetHotProductsResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? currentRecordCount,
      int? totalRecordCount,
      int? currentPageNo,
      Map<String, dynamic>? products});
}

/// @nodoc
class __$$GetHotProductsResultImplCopyWithImpl<$Res>
    extends _$GetHotProductsResultCopyWithImpl<$Res, _$GetHotProductsResultImpl>
    implements _$$GetHotProductsResultImplCopyWith<$Res> {
  __$$GetHotProductsResultImplCopyWithImpl(_$GetHotProductsResultImpl _value,
      $Res Function(_$GetHotProductsResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRecordCount = freezed,
    Object? totalRecordCount = freezed,
    Object? currentPageNo = freezed,
    Object? products = freezed,
  }) {
    return _then(_$GetHotProductsResultImpl(
      currentRecordCount: freezed == currentRecordCount
          ? _value.currentRecordCount
          : currentRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      currentPageNo: freezed == currentPageNo
          ? _value.currentPageNo
          : currentPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      products: freezed == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetHotProductsResultImpl implements _GetHotProductsResult {
  const _$GetHotProductsResultImpl(
      {this.currentRecordCount,
      this.totalRecordCount,
      this.currentPageNo,
      final Map<String, dynamic>? products})
      : _products = products;

  factory _$GetHotProductsResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetHotProductsResultImplFromJson(json);

  @override
  final int? currentRecordCount;
  @override
  final int? totalRecordCount;
  @override
  final int? currentPageNo;
  final Map<String, dynamic>? _products;
  @override
  Map<String, dynamic>? get products {
    final value = _products;
    if (value == null) return null;
    if (_products is EqualUnmodifiableMapView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GetHotProductsResult(currentRecordCount: $currentRecordCount, totalRecordCount: $totalRecordCount, currentPageNo: $currentPageNo, products: $products)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetHotProductsResultImpl &&
            (identical(other.currentRecordCount, currentRecordCount) ||
                other.currentRecordCount == currentRecordCount) &&
            (identical(other.totalRecordCount, totalRecordCount) ||
                other.totalRecordCount == totalRecordCount) &&
            (identical(other.currentPageNo, currentPageNo) ||
                other.currentPageNo == currentPageNo) &&
            const DeepCollectionEquality().equals(other._products, _products));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentRecordCount,
      totalRecordCount,
      currentPageNo,
      const DeepCollectionEquality().hash(_products));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetHotProductsResultImplCopyWith<_$GetHotProductsResultImpl>
      get copyWith =>
          __$$GetHotProductsResultImplCopyWithImpl<_$GetHotProductsResultImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetHotProductsResultImplToJson(
      this,
    );
  }
}

abstract class _GetHotProductsResult implements GetHotProductsResult {
  const factory _GetHotProductsResult(
      {final int? currentRecordCount,
      final int? totalRecordCount,
      final int? currentPageNo,
      final Map<String, dynamic>? products}) = _$GetHotProductsResultImpl;

  factory _GetHotProductsResult.fromJson(Map<String, dynamic> json) =
      _$GetHotProductsResultImpl.fromJson;

  @override
  int? get currentRecordCount;
  @override
  int? get totalRecordCount;
  @override
  int? get currentPageNo;
  @override
  Map<String, dynamic>? get products;
  @override
  @JsonKey(ignore: true)
  _$$GetHotProductsResultImplCopyWith<_$GetHotProductsResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
