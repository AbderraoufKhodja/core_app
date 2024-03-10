// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_promo_products_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeaturedPromoProductsResponse _$FeaturedPromoProductsResponseFromJson(
    Map<String, dynamic> json) {
  return _FeaturedPromoProductsResponse.fromJson(json);
}

/// @nodoc
mixin _$FeaturedPromoProductsResponse {
  @JsonKey(name: 'aliexpress_affiliate_featuredpromo_products_get_response')
  AliexpressAffiliateFeaturedpromoProductsGetResponse?
      get aliexpressAffiliateFeaturedpromoProductsGetResponse =>
          throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeaturedPromoProductsResponseCopyWith<FeaturedPromoProductsResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeaturedPromoProductsResponseCopyWith<$Res> {
  factory $FeaturedPromoProductsResponseCopyWith(
          FeaturedPromoProductsResponse value,
          $Res Function(FeaturedPromoProductsResponse) then) =
      _$FeaturedPromoProductsResponseCopyWithImpl<$Res,
          FeaturedPromoProductsResponse>;
  @useResult
  $Res call(
      {@JsonKey(
          name: 'aliexpress_affiliate_featuredpromo_products_get_response')
      AliexpressAffiliateFeaturedpromoProductsGetResponse?
          aliexpressAffiliateFeaturedpromoProductsGetResponse});

  $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<$Res>?
      get aliexpressAffiliateFeaturedpromoProductsGetResponse;
}

/// @nodoc
class _$FeaturedPromoProductsResponseCopyWithImpl<$Res,
        $Val extends FeaturedPromoProductsResponse>
    implements $FeaturedPromoProductsResponseCopyWith<$Res> {
  _$FeaturedPromoProductsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aliexpressAffiliateFeaturedpromoProductsGetResponse = freezed,
  }) {
    return _then(_value.copyWith(
      aliexpressAffiliateFeaturedpromoProductsGetResponse: freezed ==
              aliexpressAffiliateFeaturedpromoProductsGetResponse
          ? _value.aliexpressAffiliateFeaturedpromoProductsGetResponse
          : aliexpressAffiliateFeaturedpromoProductsGetResponse // ignore: cast_nullable_to_non_nullable
              as AliexpressAffiliateFeaturedpromoProductsGetResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<$Res>?
      get aliexpressAffiliateFeaturedpromoProductsGetResponse {
    if (_value.aliexpressAffiliateFeaturedpromoProductsGetResponse == null) {
      return null;
    }

    return $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<$Res>(
        _value.aliexpressAffiliateFeaturedpromoProductsGetResponse!, (value) {
      return _then(_value.copyWith(
          aliexpressAffiliateFeaturedpromoProductsGetResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeaturedPromoProductsResponseImplCopyWith<$Res>
    implements $FeaturedPromoProductsResponseCopyWith<$Res> {
  factory _$$FeaturedPromoProductsResponseImplCopyWith(
          _$FeaturedPromoProductsResponseImpl value,
          $Res Function(_$FeaturedPromoProductsResponseImpl) then) =
      __$$FeaturedPromoProductsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          name: 'aliexpress_affiliate_featuredpromo_products_get_response')
      AliexpressAffiliateFeaturedpromoProductsGetResponse?
          aliexpressAffiliateFeaturedpromoProductsGetResponse});

  @override
  $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<$Res>?
      get aliexpressAffiliateFeaturedpromoProductsGetResponse;
}

/// @nodoc
class __$$FeaturedPromoProductsResponseImplCopyWithImpl<$Res>
    extends _$FeaturedPromoProductsResponseCopyWithImpl<$Res,
        _$FeaturedPromoProductsResponseImpl>
    implements _$$FeaturedPromoProductsResponseImplCopyWith<$Res> {
  __$$FeaturedPromoProductsResponseImplCopyWithImpl(
      _$FeaturedPromoProductsResponseImpl _value,
      $Res Function(_$FeaturedPromoProductsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aliexpressAffiliateFeaturedpromoProductsGetResponse = freezed,
  }) {
    return _then(_$FeaturedPromoProductsResponseImpl(
      aliexpressAffiliateFeaturedpromoProductsGetResponse: freezed ==
              aliexpressAffiliateFeaturedpromoProductsGetResponse
          ? _value.aliexpressAffiliateFeaturedpromoProductsGetResponse
          : aliexpressAffiliateFeaturedpromoProductsGetResponse // ignore: cast_nullable_to_non_nullable
              as AliexpressAffiliateFeaturedpromoProductsGetResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeaturedPromoProductsResponseImpl
    with DiagnosticableTreeMixin
    implements _FeaturedPromoProductsResponse {
  const _$FeaturedPromoProductsResponseImpl(
      {@JsonKey(
          name: 'aliexpress_affiliate_featuredpromo_products_get_response')
      this.aliexpressAffiliateFeaturedpromoProductsGetResponse});

  factory _$FeaturedPromoProductsResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$FeaturedPromoProductsResponseImplFromJson(json);

  @override
  @JsonKey(name: 'aliexpress_affiliate_featuredpromo_products_get_response')
  final AliexpressAffiliateFeaturedpromoProductsGetResponse?
      aliexpressAffiliateFeaturedpromoProductsGetResponse;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeaturedPromoProductsResponse(aliexpressAffiliateFeaturedpromoProductsGetResponse: $aliexpressAffiliateFeaturedpromoProductsGetResponse)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FeaturedPromoProductsResponse'))
      ..add(DiagnosticsProperty(
          'aliexpressAffiliateFeaturedpromoProductsGetResponse',
          aliexpressAffiliateFeaturedpromoProductsGetResponse));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeaturedPromoProductsResponseImpl &&
            (identical(
                    other.aliexpressAffiliateFeaturedpromoProductsGetResponse,
                    aliexpressAffiliateFeaturedpromoProductsGetResponse) ||
                other.aliexpressAffiliateFeaturedpromoProductsGetResponse ==
                    aliexpressAffiliateFeaturedpromoProductsGetResponse));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, aliexpressAffiliateFeaturedpromoProductsGetResponse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeaturedPromoProductsResponseImplCopyWith<
          _$FeaturedPromoProductsResponseImpl>
      get copyWith => __$$FeaturedPromoProductsResponseImplCopyWithImpl<
          _$FeaturedPromoProductsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeaturedPromoProductsResponseImplToJson(
      this,
    );
  }
}

abstract class _FeaturedPromoProductsResponse
    implements FeaturedPromoProductsResponse {
  const factory _FeaturedPromoProductsResponse(
          {@JsonKey(
              name: 'aliexpress_affiliate_featuredpromo_products_get_response')
          final AliexpressAffiliateFeaturedpromoProductsGetResponse?
              aliexpressAffiliateFeaturedpromoProductsGetResponse}) =
      _$FeaturedPromoProductsResponseImpl;

  factory _FeaturedPromoProductsResponse.fromJson(Map<String, dynamic> json) =
      _$FeaturedPromoProductsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'aliexpress_affiliate_featuredpromo_products_get_response')
  AliexpressAffiliateFeaturedpromoProductsGetResponse?
      get aliexpressAffiliateFeaturedpromoProductsGetResponse;
  @override
  @JsonKey(ignore: true)
  _$$FeaturedPromoProductsResponseImplCopyWith<
          _$FeaturedPromoProductsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AliexpressAffiliateFeaturedpromoProductsGetResponse
    _$AliexpressAffiliateFeaturedpromoProductsGetResponseFromJson(
        Map<String, dynamic> json) {
  return _AliexpressAffiliateFeaturedpromoProductsGetResponse.fromJson(json);
}

/// @nodoc
mixin _$AliexpressAffiliateFeaturedpromoProductsGetResponse {
  @JsonKey(name: 'resp_result')
  RespResult? get respResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  String? get requestId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<
          AliexpressAffiliateFeaturedpromoProductsGetResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<
    $Res> {
  factory $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith(
          AliexpressAffiliateFeaturedpromoProductsGetResponse value,
          $Res Function(AliexpressAffiliateFeaturedpromoProductsGetResponse)
              then) =
      _$AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWithImpl<$Res,
          AliexpressAffiliateFeaturedpromoProductsGetResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'resp_result') RespResult? respResult,
      @JsonKey(name: 'request_id') String? requestId});

  $RespResultCopyWith<$Res>? get respResult;
}

/// @nodoc
class _$AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWithImpl<$Res,
        $Val extends AliexpressAffiliateFeaturedpromoProductsGetResponse>
    implements
        $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<$Res> {
  _$AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? respResult = freezed,
    Object? requestId = freezed,
  }) {
    return _then(_value.copyWith(
      respResult: freezed == respResult
          ? _value.respResult
          : respResult // ignore: cast_nullable_to_non_nullable
              as RespResult?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RespResultCopyWith<$Res>? get respResult {
    if (_value.respResult == null) {
      return null;
    }

    return $RespResultCopyWith<$Res>(_value.respResult!, (value) {
      return _then(_value.copyWith(respResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWith<
        $Res>
    implements
        $AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWith<$Res> {
  factory _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWith(
          _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl value,
          $Res Function(
                  _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl)
              then) =
      __$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWithImpl<
          $Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'resp_result') RespResult? respResult,
      @JsonKey(name: 'request_id') String? requestId});

  @override
  $RespResultCopyWith<$Res>? get respResult;
}

/// @nodoc
class __$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWithImpl<
        $Res>
    extends _$AliexpressAffiliateFeaturedpromoProductsGetResponseCopyWithImpl<
        $Res, _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl>
    implements
        _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWith<
            $Res> {
  __$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWithImpl(
      _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl _value,
      $Res Function(_$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? respResult = freezed,
    Object? requestId = freezed,
  }) {
    return _then(_$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl(
      respResult: freezed == respResult
          ? _value.respResult
          : respResult // ignore: cast_nullable_to_non_nullable
              as RespResult?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl
    with DiagnosticableTreeMixin
    implements _AliexpressAffiliateFeaturedpromoProductsGetResponse {
  const _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl(
      {@JsonKey(name: 'resp_result') this.respResult,
      @JsonKey(name: 'request_id') this.requestId});

  factory _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplFromJson(json);

  @override
  @JsonKey(name: 'resp_result')
  final RespResult? respResult;
  @override
  @JsonKey(name: 'request_id')
  final String? requestId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AliexpressAffiliateFeaturedpromoProductsGetResponse(respResult: $respResult, requestId: $requestId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'AliexpressAffiliateFeaturedpromoProductsGetResponse'))
      ..add(DiagnosticsProperty('respResult', respResult))
      ..add(DiagnosticsProperty('requestId', requestId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl &&
            (identical(other.respResult, respResult) ||
                other.respResult == respResult) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, respResult, requestId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWith<
          _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl>
      get copyWith =>
          __$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWithImpl<
                  _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplToJson(
      this,
    );
  }
}

abstract class _AliexpressAffiliateFeaturedpromoProductsGetResponse
    implements AliexpressAffiliateFeaturedpromoProductsGetResponse {
  const factory _AliexpressAffiliateFeaturedpromoProductsGetResponse(
          {@JsonKey(name: 'resp_result') final RespResult? respResult,
          @JsonKey(name: 'request_id') final String? requestId}) =
      _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl;

  factory _AliexpressAffiliateFeaturedpromoProductsGetResponse.fromJson(
          Map<String, dynamic> json) =
      _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl.fromJson;

  @override
  @JsonKey(name: 'resp_result')
  RespResult? get respResult;
  @override
  @JsonKey(name: 'request_id')
  String? get requestId;
  @override
  @JsonKey(ignore: true)
  _$$AliexpressAffiliateFeaturedpromoProductsGetResponseImplCopyWith<
          _$AliexpressAffiliateFeaturedpromoProductsGetResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RespResult _$RespResultFromJson(Map<String, dynamic> json) {
  return _RespResult.fromJson(json);
}

/// @nodoc
mixin _$RespResult {
  @JsonKey(name: 'result')
  Result? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'resp_code')
  int? get respCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RespResultCopyWith<RespResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RespResultCopyWith<$Res> {
  factory $RespResultCopyWith(
          RespResult value, $Res Function(RespResult) then) =
      _$RespResultCopyWithImpl<$Res, RespResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'result') Result? result,
      @JsonKey(name: 'resp_code') int? respCode});

  $ResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$RespResultCopyWithImpl<$Res, $Val extends RespResult>
    implements $RespResultCopyWith<$Res> {
  _$RespResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = freezed,
    Object? respCode = freezed,
  }) {
    return _then(_value.copyWith(
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result?,
      respCode: freezed == respCode
          ? _value.respCode
          : respCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $ResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RespResultImplCopyWith<$Res>
    implements $RespResultCopyWith<$Res> {
  factory _$$RespResultImplCopyWith(
          _$RespResultImpl value, $Res Function(_$RespResultImpl) then) =
      __$$RespResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'result') Result? result,
      @JsonKey(name: 'resp_code') int? respCode});

  @override
  $ResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$RespResultImplCopyWithImpl<$Res>
    extends _$RespResultCopyWithImpl<$Res, _$RespResultImpl>
    implements _$$RespResultImplCopyWith<$Res> {
  __$$RespResultImplCopyWithImpl(
      _$RespResultImpl _value, $Res Function(_$RespResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = freezed,
    Object? respCode = freezed,
  }) {
    return _then(_$RespResultImpl(
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result?,
      respCode: freezed == respCode
          ? _value.respCode
          : respCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RespResultImpl with DiagnosticableTreeMixin implements _RespResult {
  const _$RespResultImpl(
      {@JsonKey(name: 'result') this.result,
      @JsonKey(name: 'resp_code') this.respCode});

  factory _$RespResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RespResultImplFromJson(json);

  @override
  @JsonKey(name: 'result')
  final Result? result;
  @override
  @JsonKey(name: 'resp_code')
  final int? respCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RespResult(result: $result, respCode: $respCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RespResult'))
      ..add(DiagnosticsProperty('result', result))
      ..add(DiagnosticsProperty('respCode', respCode));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RespResultImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.respCode, respCode) ||
                other.respCode == respCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, result, respCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RespResultImplCopyWith<_$RespResultImpl> get copyWith =>
      __$$RespResultImplCopyWithImpl<_$RespResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RespResultImplToJson(
      this,
    );
  }
}

abstract class _RespResult implements RespResult {
  const factory _RespResult(
      {@JsonKey(name: 'result') final Result? result,
      @JsonKey(name: 'resp_code') final int? respCode}) = _$RespResultImpl;

  factory _RespResult.fromJson(Map<String, dynamic> json) =
      _$RespResultImpl.fromJson;

  @override
  @JsonKey(name: 'result')
  Result? get result;
  @override
  @JsonKey(name: 'resp_code')
  int? get respCode;
  @override
  @JsonKey(ignore: true)
  _$$RespResultImplCopyWith<_$RespResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Result _$ResultFromJson(Map<String, dynamic> json) {
  return _Result.fromJson(json);
}

/// @nodoc
mixin _$Result {
  @JsonKey(name: 'current_record_count')
  int? get currentRecordCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_record_count')
  int? get totalRecordCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_finished')
  bool? get isFinished => throw _privateConstructorUsedError;
  @JsonKey(name: 'products')
  Products? get products => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResultCopyWith<Result> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<$Res> {
  factory $ResultCopyWith(Result value, $Res Function(Result) then) =
      _$ResultCopyWithImpl<$Res, Result>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_record_count') int? currentRecordCount,
      @JsonKey(name: 'total_record_count') int? totalRecordCount,
      @JsonKey(name: 'is_finished') bool? isFinished,
      @JsonKey(name: 'products') Products? products});

  $ProductsCopyWith<$Res>? get products;
}

/// @nodoc
class _$ResultCopyWithImpl<$Res, $Val extends Result>
    implements $ResultCopyWith<$Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRecordCount = freezed,
    Object? totalRecordCount = freezed,
    Object? isFinished = freezed,
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
      isFinished: freezed == isFinished
          ? _value.isFinished
          : isFinished // ignore: cast_nullable_to_non_nullable
              as bool?,
      products: freezed == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as Products?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductsCopyWith<$Res>? get products {
    if (_value.products == null) {
      return null;
    }

    return $ProductsCopyWith<$Res>(_value.products!, (value) {
      return _then(_value.copyWith(products: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResultImplCopyWith<$Res> implements $ResultCopyWith<$Res> {
  factory _$$ResultImplCopyWith(
          _$ResultImpl value, $Res Function(_$ResultImpl) then) =
      __$$ResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_record_count') int? currentRecordCount,
      @JsonKey(name: 'total_record_count') int? totalRecordCount,
      @JsonKey(name: 'is_finished') bool? isFinished,
      @JsonKey(name: 'products') Products? products});

  @override
  $ProductsCopyWith<$Res>? get products;
}

/// @nodoc
class __$$ResultImplCopyWithImpl<$Res>
    extends _$ResultCopyWithImpl<$Res, _$ResultImpl>
    implements _$$ResultImplCopyWith<$Res> {
  __$$ResultImplCopyWithImpl(
      _$ResultImpl _value, $Res Function(_$ResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRecordCount = freezed,
    Object? totalRecordCount = freezed,
    Object? isFinished = freezed,
    Object? products = freezed,
  }) {
    return _then(_$ResultImpl(
      currentRecordCount: freezed == currentRecordCount
          ? _value.currentRecordCount
          : currentRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isFinished: freezed == isFinished
          ? _value.isFinished
          : isFinished // ignore: cast_nullable_to_non_nullable
              as bool?,
      products: freezed == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as Products?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResultImpl with DiagnosticableTreeMixin implements _Result {
  const _$ResultImpl(
      {@JsonKey(name: 'current_record_count') this.currentRecordCount,
      @JsonKey(name: 'total_record_count') this.totalRecordCount,
      @JsonKey(name: 'is_finished') this.isFinished,
      @JsonKey(name: 'products') this.products});

  factory _$ResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResultImplFromJson(json);

  @override
  @JsonKey(name: 'current_record_count')
  final int? currentRecordCount;
  @override
  @JsonKey(name: 'total_record_count')
  final int? totalRecordCount;
  @override
  @JsonKey(name: 'is_finished')
  final bool? isFinished;
  @override
  @JsonKey(name: 'products')
  final Products? products;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result(currentRecordCount: $currentRecordCount, totalRecordCount: $totalRecordCount, isFinished: $isFinished, products: $products)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result'))
      ..add(DiagnosticsProperty('currentRecordCount', currentRecordCount))
      ..add(DiagnosticsProperty('totalRecordCount', totalRecordCount))
      ..add(DiagnosticsProperty('isFinished', isFinished))
      ..add(DiagnosticsProperty('products', products));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultImpl &&
            (identical(other.currentRecordCount, currentRecordCount) ||
                other.currentRecordCount == currentRecordCount) &&
            (identical(other.totalRecordCount, totalRecordCount) ||
                other.totalRecordCount == totalRecordCount) &&
            (identical(other.isFinished, isFinished) ||
                other.isFinished == isFinished) &&
            (identical(other.products, products) ||
                other.products == products));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, currentRecordCount, totalRecordCount, isFinished, products);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultImplCopyWith<_$ResultImpl> get copyWith =>
      __$$ResultImplCopyWithImpl<_$ResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResultImplToJson(
      this,
    );
  }
}

abstract class _Result implements Result {
  const factory _Result(
      {@JsonKey(name: 'current_record_count') final int? currentRecordCount,
      @JsonKey(name: 'total_record_count') final int? totalRecordCount,
      @JsonKey(name: 'is_finished') final bool? isFinished,
      @JsonKey(name: 'products') final Products? products}) = _$ResultImpl;

  factory _Result.fromJson(Map<String, dynamic> json) = _$ResultImpl.fromJson;

  @override
  @JsonKey(name: 'current_record_count')
  int? get currentRecordCount;
  @override
  @JsonKey(name: 'total_record_count')
  int? get totalRecordCount;
  @override
  @JsonKey(name: 'is_finished')
  bool? get isFinished;
  @override
  @JsonKey(name: 'products')
  Products? get products;
  @override
  @JsonKey(ignore: true)
  _$$ResultImplCopyWith<_$ResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
