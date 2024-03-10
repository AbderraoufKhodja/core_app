// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hot_products_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HotProductsResponse _$HotProductsResponseFromJson(Map<String, dynamic> json) {
  return _HotProductsResponse.fromJson(json);
}

/// @nodoc
mixin _$HotProductsResponse {
  @JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
  AliexpressAffiliateHotproductQueryResponse?
      get aliexpressAffiliateHotproductQueryResponse =>
          throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HotProductsResponseCopyWith<HotProductsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotProductsResponseCopyWith<$Res> {
  factory $HotProductsResponseCopyWith(
          HotProductsResponse value, $Res Function(HotProductsResponse) then) =
      _$HotProductsResponseCopyWithImpl<$Res, HotProductsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
      AliexpressAffiliateHotproductQueryResponse?
          aliexpressAffiliateHotproductQueryResponse});

  $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res>?
      get aliexpressAffiliateHotproductQueryResponse;
}

/// @nodoc
class _$HotProductsResponseCopyWithImpl<$Res, $Val extends HotProductsResponse>
    implements $HotProductsResponseCopyWith<$Res> {
  _$HotProductsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aliexpressAffiliateHotproductQueryResponse = freezed,
  }) {
    return _then(_value.copyWith(
      aliexpressAffiliateHotproductQueryResponse: freezed ==
              aliexpressAffiliateHotproductQueryResponse
          ? _value.aliexpressAffiliateHotproductQueryResponse
          : aliexpressAffiliateHotproductQueryResponse // ignore: cast_nullable_to_non_nullable
              as AliexpressAffiliateHotproductQueryResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res>?
      get aliexpressAffiliateHotproductQueryResponse {
    if (_value.aliexpressAffiliateHotproductQueryResponse == null) {
      return null;
    }

    return $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res>(
        _value.aliexpressAffiliateHotproductQueryResponse!, (value) {
      return _then(_value.copyWith(
          aliexpressAffiliateHotproductQueryResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HotProductsResponseImplCopyWith<$Res>
    implements $HotProductsResponseCopyWith<$Res> {
  factory _$$HotProductsResponseImplCopyWith(_$HotProductsResponseImpl value,
          $Res Function(_$HotProductsResponseImpl) then) =
      __$$HotProductsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
      AliexpressAffiliateHotproductQueryResponse?
          aliexpressAffiliateHotproductQueryResponse});

  @override
  $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res>?
      get aliexpressAffiliateHotproductQueryResponse;
}

/// @nodoc
class __$$HotProductsResponseImplCopyWithImpl<$Res>
    extends _$HotProductsResponseCopyWithImpl<$Res, _$HotProductsResponseImpl>
    implements _$$HotProductsResponseImplCopyWith<$Res> {
  __$$HotProductsResponseImplCopyWithImpl(_$HotProductsResponseImpl _value,
      $Res Function(_$HotProductsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aliexpressAffiliateHotproductQueryResponse = freezed,
  }) {
    return _then(_$HotProductsResponseImpl(
      aliexpressAffiliateHotproductQueryResponse: freezed ==
              aliexpressAffiliateHotproductQueryResponse
          ? _value.aliexpressAffiliateHotproductQueryResponse
          : aliexpressAffiliateHotproductQueryResponse // ignore: cast_nullable_to_non_nullable
              as AliexpressAffiliateHotproductQueryResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HotProductsResponseImpl
    with DiagnosticableTreeMixin
    implements _HotProductsResponse {
  const _$HotProductsResponseImpl(
      {@JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
      this.aliexpressAffiliateHotproductQueryResponse});

  factory _$HotProductsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HotProductsResponseImplFromJson(json);

  @override
  @JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
  final AliexpressAffiliateHotproductQueryResponse?
      aliexpressAffiliateHotproductQueryResponse;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HotProductsResponse(aliexpressAffiliateHotproductQueryResponse: $aliexpressAffiliateHotproductQueryResponse)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HotProductsResponse'))
      ..add(DiagnosticsProperty('aliexpressAffiliateHotproductQueryResponse',
          aliexpressAffiliateHotproductQueryResponse));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HotProductsResponseImpl &&
            (identical(other.aliexpressAffiliateHotproductQueryResponse,
                    aliexpressAffiliateHotproductQueryResponse) ||
                other.aliexpressAffiliateHotproductQueryResponse ==
                    aliexpressAffiliateHotproductQueryResponse));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, aliexpressAffiliateHotproductQueryResponse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HotProductsResponseImplCopyWith<_$HotProductsResponseImpl> get copyWith =>
      __$$HotProductsResponseImplCopyWithImpl<_$HotProductsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HotProductsResponseImplToJson(
      this,
    );
  }
}

abstract class _HotProductsResponse implements HotProductsResponse {
  const factory _HotProductsResponse(
          {@JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
          final AliexpressAffiliateHotproductQueryResponse?
              aliexpressAffiliateHotproductQueryResponse}) =
      _$HotProductsResponseImpl;

  factory _HotProductsResponse.fromJson(Map<String, dynamic> json) =
      _$HotProductsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'aliexpress_affiliate_hotproduct_query_response')
  AliexpressAffiliateHotproductQueryResponse?
      get aliexpressAffiliateHotproductQueryResponse;
  @override
  @JsonKey(ignore: true)
  _$$HotProductsResponseImplCopyWith<_$HotProductsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AliexpressAffiliateHotproductQueryResponse
    _$AliexpressAffiliateHotproductQueryResponseFromJson(
        Map<String, dynamic> json) {
  return _AliexpressAffiliateHotproductQueryResponse.fromJson(json);
}

/// @nodoc
mixin _$AliexpressAffiliateHotproductQueryResponse {
  @JsonKey(name: 'resp_result')
  RespResult? get respResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  String? get requestId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AliexpressAffiliateHotproductQueryResponseCopyWith<
          AliexpressAffiliateHotproductQueryResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res> {
  factory $AliexpressAffiliateHotproductQueryResponseCopyWith(
          AliexpressAffiliateHotproductQueryResponse value,
          $Res Function(AliexpressAffiliateHotproductQueryResponse) then) =
      _$AliexpressAffiliateHotproductQueryResponseCopyWithImpl<$Res,
          AliexpressAffiliateHotproductQueryResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'resp_result') RespResult? respResult,
      @JsonKey(name: 'request_id') String? requestId});

  $RespResultCopyWith<$Res>? get respResult;
}

/// @nodoc
class _$AliexpressAffiliateHotproductQueryResponseCopyWithImpl<$Res,
        $Val extends AliexpressAffiliateHotproductQueryResponse>
    implements $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res> {
  _$AliexpressAffiliateHotproductQueryResponseCopyWithImpl(
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
abstract class _$$AliexpressAffiliateHotproductQueryResponseImplCopyWith<$Res>
    implements $AliexpressAffiliateHotproductQueryResponseCopyWith<$Res> {
  factory _$$AliexpressAffiliateHotproductQueryResponseImplCopyWith(
          _$AliexpressAffiliateHotproductQueryResponseImpl value,
          $Res Function(_$AliexpressAffiliateHotproductQueryResponseImpl)
              then) =
      __$$AliexpressAffiliateHotproductQueryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'resp_result') RespResult? respResult,
      @JsonKey(name: 'request_id') String? requestId});

  @override
  $RespResultCopyWith<$Res>? get respResult;
}

/// @nodoc
class __$$AliexpressAffiliateHotproductQueryResponseImplCopyWithImpl<$Res>
    extends _$AliexpressAffiliateHotproductQueryResponseCopyWithImpl<$Res,
        _$AliexpressAffiliateHotproductQueryResponseImpl>
    implements _$$AliexpressAffiliateHotproductQueryResponseImplCopyWith<$Res> {
  __$$AliexpressAffiliateHotproductQueryResponseImplCopyWithImpl(
      _$AliexpressAffiliateHotproductQueryResponseImpl _value,
      $Res Function(_$AliexpressAffiliateHotproductQueryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? respResult = freezed,
    Object? requestId = freezed,
  }) {
    return _then(_$AliexpressAffiliateHotproductQueryResponseImpl(
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
class _$AliexpressAffiliateHotproductQueryResponseImpl
    with DiagnosticableTreeMixin
    implements _AliexpressAffiliateHotproductQueryResponse {
  const _$AliexpressAffiliateHotproductQueryResponseImpl(
      {@JsonKey(name: 'resp_result') this.respResult,
      @JsonKey(name: 'request_id') this.requestId});

  factory _$AliexpressAffiliateHotproductQueryResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AliexpressAffiliateHotproductQueryResponseImplFromJson(json);

  @override
  @JsonKey(name: 'resp_result')
  final RespResult? respResult;
  @override
  @JsonKey(name: 'request_id')
  final String? requestId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AliexpressAffiliateHotproductQueryResponse(respResult: $respResult, requestId: $requestId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'AliexpressAffiliateHotproductQueryResponse'))
      ..add(DiagnosticsProperty('respResult', respResult))
      ..add(DiagnosticsProperty('requestId', requestId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AliexpressAffiliateHotproductQueryResponseImpl &&
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
  _$$AliexpressAffiliateHotproductQueryResponseImplCopyWith<
          _$AliexpressAffiliateHotproductQueryResponseImpl>
      get copyWith =>
          __$$AliexpressAffiliateHotproductQueryResponseImplCopyWithImpl<
                  _$AliexpressAffiliateHotproductQueryResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AliexpressAffiliateHotproductQueryResponseImplToJson(
      this,
    );
  }
}

abstract class _AliexpressAffiliateHotproductQueryResponse
    implements AliexpressAffiliateHotproductQueryResponse {
  const factory _AliexpressAffiliateHotproductQueryResponse(
          {@JsonKey(name: 'resp_result') final RespResult? respResult,
          @JsonKey(name: 'request_id') final String? requestId}) =
      _$AliexpressAffiliateHotproductQueryResponseImpl;

  factory _AliexpressAffiliateHotproductQueryResponse.fromJson(
          Map<String, dynamic> json) =
      _$AliexpressAffiliateHotproductQueryResponseImpl.fromJson;

  @override
  @JsonKey(name: 'resp_result')
  RespResult? get respResult;
  @override
  @JsonKey(name: 'request_id')
  String? get requestId;
  @override
  @JsonKey(ignore: true)
  _$$AliexpressAffiliateHotproductQueryResponseImplCopyWith<
          _$AliexpressAffiliateHotproductQueryResponseImpl>
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
  @JsonKey(name: 'resp_msg')
  String? get respMsg => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'resp_code') int? respCode,
      @JsonKey(name: 'resp_msg') String? respMsg});

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
    Object? respMsg = freezed,
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
      respMsg: freezed == respMsg
          ? _value.respMsg
          : respMsg // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'resp_code') int? respCode,
      @JsonKey(name: 'resp_msg') String? respMsg});

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
    Object? respMsg = freezed,
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
      respMsg: freezed == respMsg
          ? _value.respMsg
          : respMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RespResultImpl with DiagnosticableTreeMixin implements _RespResult {
  const _$RespResultImpl(
      {@JsonKey(name: 'result') this.result,
      @JsonKey(name: 'resp_code') this.respCode,
      @JsonKey(name: 'resp_msg') this.respMsg});

  factory _$RespResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RespResultImplFromJson(json);

  @override
  @JsonKey(name: 'result')
  final Result? result;
  @override
  @JsonKey(name: 'resp_code')
  final int? respCode;
  @override
  @JsonKey(name: 'resp_msg')
  final String? respMsg;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RespResult(result: $result, respCode: $respCode, respMsg: $respMsg)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RespResult'))
      ..add(DiagnosticsProperty('result', result))
      ..add(DiagnosticsProperty('respCode', respCode))
      ..add(DiagnosticsProperty('respMsg', respMsg));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RespResultImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.respCode, respCode) ||
                other.respCode == respCode) &&
            (identical(other.respMsg, respMsg) || other.respMsg == respMsg));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, result, respCode, respMsg);

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
      @JsonKey(name: 'resp_code') final int? respCode,
      @JsonKey(name: 'resp_msg') final String? respMsg}) = _$RespResultImpl;

  factory _RespResult.fromJson(Map<String, dynamic> json) =
      _$RespResultImpl.fromJson;

  @override
  @JsonKey(name: 'result')
  Result? get result;
  @override
  @JsonKey(name: 'resp_code')
  int? get respCode;
  @override
  @JsonKey(name: 'resp_msg')
  String? get respMsg;
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
  @JsonKey(name: 'current_page_no')
  int? get currentPageNo => throw _privateConstructorUsedError;
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
      @JsonKey(name: 'current_page_no') int? currentPageNo,
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
      @JsonKey(name: 'current_page_no') int? currentPageNo,
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
    Object? currentPageNo = freezed,
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
      currentPageNo: freezed == currentPageNo
          ? _value.currentPageNo
          : currentPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
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
      @JsonKey(name: 'current_page_no') this.currentPageNo,
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
  @JsonKey(name: 'current_page_no')
  final int? currentPageNo;
  @override
  @JsonKey(name: 'products')
  final Products? products;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result(currentRecordCount: $currentRecordCount, totalRecordCount: $totalRecordCount, currentPageNo: $currentPageNo, products: $products)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result'))
      ..add(DiagnosticsProperty('currentRecordCount', currentRecordCount))
      ..add(DiagnosticsProperty('totalRecordCount', totalRecordCount))
      ..add(DiagnosticsProperty('currentPageNo', currentPageNo))
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
            (identical(other.currentPageNo, currentPageNo) ||
                other.currentPageNo == currentPageNo) &&
            (identical(other.products, products) ||
                other.products == products));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentRecordCount,
      totalRecordCount, currentPageNo, products);

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
      @JsonKey(name: 'current_page_no') final int? currentPageNo,
      @JsonKey(name: 'products') final Products? products}) = _$ResultImpl;

  factory _Result.fromJson(Map<String, dynamic> json) = _$ResultImpl.fromJson;

  @override
  @JsonKey(name: 'current_record_count')
  int? get currentRecordCount;
  @override
  @JsonKey(name: 'total_record_count')
  int? get totalRecordCount;
  @override
  @JsonKey(name: 'current_page_no')
  int? get currentPageNo;
  @override
  @JsonKey(name: 'products')
  Products? get products;
  @override
  @JsonKey(ignore: true)
  _$$ResultImplCopyWith<_$ResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
