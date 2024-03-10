// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_promo_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeaturedPromoResponse _$FeaturedPromoResponseFromJson(
    Map<String, dynamic> json) {
  return _FeaturedPromoResponse.fromJson(json);
}

/// @nodoc
mixin _$FeaturedPromoResponse {
  @JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
  AliexpressAffiliateFeaturedpromoGetResponse?
      get aliexpressAffiliateFeaturedpromoGetResponse =>
          throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeaturedPromoResponseCopyWith<FeaturedPromoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeaturedPromoResponseCopyWith<$Res> {
  factory $FeaturedPromoResponseCopyWith(FeaturedPromoResponse value,
          $Res Function(FeaturedPromoResponse) then) =
      _$FeaturedPromoResponseCopyWithImpl<$Res, FeaturedPromoResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
      AliexpressAffiliateFeaturedpromoGetResponse?
          aliexpressAffiliateFeaturedpromoGetResponse});

  $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res>?
      get aliexpressAffiliateFeaturedpromoGetResponse;
}

/// @nodoc
class _$FeaturedPromoResponseCopyWithImpl<$Res,
        $Val extends FeaturedPromoResponse>
    implements $FeaturedPromoResponseCopyWith<$Res> {
  _$FeaturedPromoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aliexpressAffiliateFeaturedpromoGetResponse = freezed,
  }) {
    return _then(_value.copyWith(
      aliexpressAffiliateFeaturedpromoGetResponse: freezed ==
              aliexpressAffiliateFeaturedpromoGetResponse
          ? _value.aliexpressAffiliateFeaturedpromoGetResponse
          : aliexpressAffiliateFeaturedpromoGetResponse // ignore: cast_nullable_to_non_nullable
              as AliexpressAffiliateFeaturedpromoGetResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res>?
      get aliexpressAffiliateFeaturedpromoGetResponse {
    if (_value.aliexpressAffiliateFeaturedpromoGetResponse == null) {
      return null;
    }

    return $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res>(
        _value.aliexpressAffiliateFeaturedpromoGetResponse!, (value) {
      return _then(_value.copyWith(
          aliexpressAffiliateFeaturedpromoGetResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeaturedPromoResponseImplCopyWith<$Res>
    implements $FeaturedPromoResponseCopyWith<$Res> {
  factory _$$FeaturedPromoResponseImplCopyWith(
          _$FeaturedPromoResponseImpl value,
          $Res Function(_$FeaturedPromoResponseImpl) then) =
      __$$FeaturedPromoResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
      AliexpressAffiliateFeaturedpromoGetResponse?
          aliexpressAffiliateFeaturedpromoGetResponse});

  @override
  $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res>?
      get aliexpressAffiliateFeaturedpromoGetResponse;
}

/// @nodoc
class __$$FeaturedPromoResponseImplCopyWithImpl<$Res>
    extends _$FeaturedPromoResponseCopyWithImpl<$Res,
        _$FeaturedPromoResponseImpl>
    implements _$$FeaturedPromoResponseImplCopyWith<$Res> {
  __$$FeaturedPromoResponseImplCopyWithImpl(_$FeaturedPromoResponseImpl _value,
      $Res Function(_$FeaturedPromoResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aliexpressAffiliateFeaturedpromoGetResponse = freezed,
  }) {
    return _then(_$FeaturedPromoResponseImpl(
      aliexpressAffiliateFeaturedpromoGetResponse: freezed ==
              aliexpressAffiliateFeaturedpromoGetResponse
          ? _value.aliexpressAffiliateFeaturedpromoGetResponse
          : aliexpressAffiliateFeaturedpromoGetResponse // ignore: cast_nullable_to_non_nullable
              as AliexpressAffiliateFeaturedpromoGetResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeaturedPromoResponseImpl
    with DiagnosticableTreeMixin
    implements _FeaturedPromoResponse {
  const _$FeaturedPromoResponseImpl(
      {@JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
      this.aliexpressAffiliateFeaturedpromoGetResponse});

  factory _$FeaturedPromoResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeaturedPromoResponseImplFromJson(json);

  @override
  @JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
  final AliexpressAffiliateFeaturedpromoGetResponse?
      aliexpressAffiliateFeaturedpromoGetResponse;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeaturedPromoResponse(aliexpressAffiliateFeaturedpromoGetResponse: $aliexpressAffiliateFeaturedpromoGetResponse)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FeaturedPromoResponse'))
      ..add(DiagnosticsProperty('aliexpressAffiliateFeaturedpromoGetResponse',
          aliexpressAffiliateFeaturedpromoGetResponse));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeaturedPromoResponseImpl &&
            (identical(other.aliexpressAffiliateFeaturedpromoGetResponse,
                    aliexpressAffiliateFeaturedpromoGetResponse) ||
                other.aliexpressAffiliateFeaturedpromoGetResponse ==
                    aliexpressAffiliateFeaturedpromoGetResponse));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, aliexpressAffiliateFeaturedpromoGetResponse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeaturedPromoResponseImplCopyWith<_$FeaturedPromoResponseImpl>
      get copyWith => __$$FeaturedPromoResponseImplCopyWithImpl<
          _$FeaturedPromoResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeaturedPromoResponseImplToJson(
      this,
    );
  }
}

abstract class _FeaturedPromoResponse implements FeaturedPromoResponse {
  const factory _FeaturedPromoResponse(
          {@JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
          final AliexpressAffiliateFeaturedpromoGetResponse?
              aliexpressAffiliateFeaturedpromoGetResponse}) =
      _$FeaturedPromoResponseImpl;

  factory _FeaturedPromoResponse.fromJson(Map<String, dynamic> json) =
      _$FeaturedPromoResponseImpl.fromJson;

  @override
  @JsonKey(name: 'aliexpress_affiliate_featuredpromo_get_response')
  AliexpressAffiliateFeaturedpromoGetResponse?
      get aliexpressAffiliateFeaturedpromoGetResponse;
  @override
  @JsonKey(ignore: true)
  _$$FeaturedPromoResponseImplCopyWith<_$FeaturedPromoResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AliexpressAffiliateFeaturedpromoGetResponse
    _$AliexpressAffiliateFeaturedpromoGetResponseFromJson(
        Map<String, dynamic> json) {
  return _AliexpressAffiliateFeaturedpromoGetResponse.fromJson(json);
}

/// @nodoc
mixin _$AliexpressAffiliateFeaturedpromoGetResponse {
  @JsonKey(name: 'resp_result')
  RespResult? get respResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  String? get requestId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<
          AliexpressAffiliateFeaturedpromoGetResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res> {
  factory $AliexpressAffiliateFeaturedpromoGetResponseCopyWith(
          AliexpressAffiliateFeaturedpromoGetResponse value,
          $Res Function(AliexpressAffiliateFeaturedpromoGetResponse) then) =
      _$AliexpressAffiliateFeaturedpromoGetResponseCopyWithImpl<$Res,
          AliexpressAffiliateFeaturedpromoGetResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'resp_result') RespResult? respResult,
      @JsonKey(name: 'request_id') String? requestId});

  $RespResultCopyWith<$Res>? get respResult;
}

/// @nodoc
class _$AliexpressAffiliateFeaturedpromoGetResponseCopyWithImpl<$Res,
        $Val extends AliexpressAffiliateFeaturedpromoGetResponse>
    implements $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res> {
  _$AliexpressAffiliateFeaturedpromoGetResponseCopyWithImpl(
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
abstract class _$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWith<$Res>
    implements $AliexpressAffiliateFeaturedpromoGetResponseCopyWith<$Res> {
  factory _$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWith(
          _$AliexpressAffiliateFeaturedpromoGetResponseImpl value,
          $Res Function(_$AliexpressAffiliateFeaturedpromoGetResponseImpl)
              then) =
      __$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'resp_result') RespResult? respResult,
      @JsonKey(name: 'request_id') String? requestId});

  @override
  $RespResultCopyWith<$Res>? get respResult;
}

/// @nodoc
class __$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWithImpl<$Res>
    extends _$AliexpressAffiliateFeaturedpromoGetResponseCopyWithImpl<$Res,
        _$AliexpressAffiliateFeaturedpromoGetResponseImpl>
    implements
        _$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWith<$Res> {
  __$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWithImpl(
      _$AliexpressAffiliateFeaturedpromoGetResponseImpl _value,
      $Res Function(_$AliexpressAffiliateFeaturedpromoGetResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? respResult = freezed,
    Object? requestId = freezed,
  }) {
    return _then(_$AliexpressAffiliateFeaturedpromoGetResponseImpl(
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
class _$AliexpressAffiliateFeaturedpromoGetResponseImpl
    with DiagnosticableTreeMixin
    implements _AliexpressAffiliateFeaturedpromoGetResponse {
  const _$AliexpressAffiliateFeaturedpromoGetResponseImpl(
      {@JsonKey(name: 'resp_result') this.respResult,
      @JsonKey(name: 'request_id') this.requestId});

  factory _$AliexpressAffiliateFeaturedpromoGetResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AliexpressAffiliateFeaturedpromoGetResponseImplFromJson(json);

  @override
  @JsonKey(name: 'resp_result')
  final RespResult? respResult;
  @override
  @JsonKey(name: 'request_id')
  final String? requestId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AliexpressAffiliateFeaturedpromoGetResponse(respResult: $respResult, requestId: $requestId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'AliexpressAffiliateFeaturedpromoGetResponse'))
      ..add(DiagnosticsProperty('respResult', respResult))
      ..add(DiagnosticsProperty('requestId', requestId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AliexpressAffiliateFeaturedpromoGetResponseImpl &&
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
  _$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWith<
          _$AliexpressAffiliateFeaturedpromoGetResponseImpl>
      get copyWith =>
          __$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWithImpl<
                  _$AliexpressAffiliateFeaturedpromoGetResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AliexpressAffiliateFeaturedpromoGetResponseImplToJson(
      this,
    );
  }
}

abstract class _AliexpressAffiliateFeaturedpromoGetResponse
    implements AliexpressAffiliateFeaturedpromoGetResponse {
  const factory _AliexpressAffiliateFeaturedpromoGetResponse(
          {@JsonKey(name: 'resp_result') final RespResult? respResult,
          @JsonKey(name: 'request_id') final String? requestId}) =
      _$AliexpressAffiliateFeaturedpromoGetResponseImpl;

  factory _AliexpressAffiliateFeaturedpromoGetResponse.fromJson(
          Map<String, dynamic> json) =
      _$AliexpressAffiliateFeaturedpromoGetResponseImpl.fromJson;

  @override
  @JsonKey(name: 'resp_result')
  RespResult? get respResult;
  @override
  @JsonKey(name: 'request_id')
  String? get requestId;
  @override
  @JsonKey(ignore: true)
  _$$AliexpressAffiliateFeaturedpromoGetResponseImplCopyWith<
          _$AliexpressAffiliateFeaturedpromoGetResponseImpl>
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
  @JsonKey(name: 'promos')
  Promos? get promos => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'promos') Promos? promos});

  $PromosCopyWith<$Res>? get promos;
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
    Object? promos = freezed,
  }) {
    return _then(_value.copyWith(
      currentRecordCount: freezed == currentRecordCount
          ? _value.currentRecordCount
          : currentRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      promos: freezed == promos
          ? _value.promos
          : promos // ignore: cast_nullable_to_non_nullable
              as Promos?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PromosCopyWith<$Res>? get promos {
    if (_value.promos == null) {
      return null;
    }

    return $PromosCopyWith<$Res>(_value.promos!, (value) {
      return _then(_value.copyWith(promos: value) as $Val);
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
      @JsonKey(name: 'promos') Promos? promos});

  @override
  $PromosCopyWith<$Res>? get promos;
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
    Object? promos = freezed,
  }) {
    return _then(_$ResultImpl(
      currentRecordCount: freezed == currentRecordCount
          ? _value.currentRecordCount
          : currentRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      promos: freezed == promos
          ? _value.promos
          : promos // ignore: cast_nullable_to_non_nullable
              as Promos?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResultImpl with DiagnosticableTreeMixin implements _Result {
  const _$ResultImpl(
      {@JsonKey(name: 'current_record_count') this.currentRecordCount,
      @JsonKey(name: 'promos') this.promos});

  factory _$ResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResultImplFromJson(json);

  @override
  @JsonKey(name: 'current_record_count')
  final int? currentRecordCount;
  @override
  @JsonKey(name: 'promos')
  final Promos? promos;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result(currentRecordCount: $currentRecordCount, promos: $promos)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result'))
      ..add(DiagnosticsProperty('currentRecordCount', currentRecordCount))
      ..add(DiagnosticsProperty('promos', promos));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultImpl &&
            (identical(other.currentRecordCount, currentRecordCount) ||
                other.currentRecordCount == currentRecordCount) &&
            (identical(other.promos, promos) || other.promos == promos));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentRecordCount, promos);

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
      @JsonKey(name: 'promos') final Promos? promos}) = _$ResultImpl;

  factory _Result.fromJson(Map<String, dynamic> json) = _$ResultImpl.fromJson;

  @override
  @JsonKey(name: 'current_record_count')
  int? get currentRecordCount;
  @override
  @JsonKey(name: 'promos')
  Promos? get promos;
  @override
  @JsonKey(ignore: true)
  _$$ResultImplCopyWith<_$ResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Promos _$PromosFromJson(Map<String, dynamic> json) {
  return _Promos.fromJson(json);
}

/// @nodoc
mixin _$Promos {
  @JsonKey(name: 'promo')
  List<Promo>? get promo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromosCopyWith<Promos> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromosCopyWith<$Res> {
  factory $PromosCopyWith(Promos value, $Res Function(Promos) then) =
      _$PromosCopyWithImpl<$Res, Promos>;
  @useResult
  $Res call({@JsonKey(name: 'promo') List<Promo>? promo});
}

/// @nodoc
class _$PromosCopyWithImpl<$Res, $Val extends Promos>
    implements $PromosCopyWith<$Res> {
  _$PromosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promo = freezed,
  }) {
    return _then(_value.copyWith(
      promo: freezed == promo
          ? _value.promo
          : promo // ignore: cast_nullable_to_non_nullable
              as List<Promo>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromosImplCopyWith<$Res> implements $PromosCopyWith<$Res> {
  factory _$$PromosImplCopyWith(
          _$PromosImpl value, $Res Function(_$PromosImpl) then) =
      __$$PromosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'promo') List<Promo>? promo});
}

/// @nodoc
class __$$PromosImplCopyWithImpl<$Res>
    extends _$PromosCopyWithImpl<$Res, _$PromosImpl>
    implements _$$PromosImplCopyWith<$Res> {
  __$$PromosImplCopyWithImpl(
      _$PromosImpl _value, $Res Function(_$PromosImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promo = freezed,
  }) {
    return _then(_$PromosImpl(
      promo: freezed == promo
          ? _value._promo
          : promo // ignore: cast_nullable_to_non_nullable
              as List<Promo>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromosImpl with DiagnosticableTreeMixin implements _Promos {
  const _$PromosImpl({@JsonKey(name: 'promo') final List<Promo>? promo})
      : _promo = promo;

  factory _$PromosImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromosImplFromJson(json);

  final List<Promo>? _promo;
  @override
  @JsonKey(name: 'promo')
  List<Promo>? get promo {
    final value = _promo;
    if (value == null) return null;
    if (_promo is EqualUnmodifiableListView) return _promo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Promos(promo: $promo)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Promos'))
      ..add(DiagnosticsProperty('promo', promo));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromosImpl &&
            const DeepCollectionEquality().equals(other._promo, _promo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_promo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromosImplCopyWith<_$PromosImpl> get copyWith =>
      __$$PromosImplCopyWithImpl<_$PromosImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromosImplToJson(
      this,
    );
  }
}

abstract class _Promos implements Promos {
  const factory _Promos({@JsonKey(name: 'promo') final List<Promo>? promo}) =
      _$PromosImpl;

  factory _Promos.fromJson(Map<String, dynamic> json) = _$PromosImpl.fromJson;

  @override
  @JsonKey(name: 'promo')
  List<Promo>? get promo;
  @override
  @JsonKey(ignore: true)
  _$$PromosImplCopyWith<_$PromosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Promo _$PromoFromJson(Map<String, dynamic> json) {
  return _Promo.fromJson(json);
}

/// @nodoc
mixin _$Promo {
  @JsonKey(name: 'promo_name')
  String? get promoName => throw _privateConstructorUsedError;
  @JsonKey(name: 'promo_desc')
  String? get promoDesc => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_num')
  int? get productNum => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromoCopyWith<Promo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromoCopyWith<$Res> {
  factory $PromoCopyWith(Promo value, $Res Function(Promo) then) =
      _$PromoCopyWithImpl<$Res, Promo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'promo_name') String? promoName,
      @JsonKey(name: 'promo_desc') String? promoDesc,
      @JsonKey(name: 'product_num') int? productNum});
}

/// @nodoc
class _$PromoCopyWithImpl<$Res, $Val extends Promo>
    implements $PromoCopyWith<$Res> {
  _$PromoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promoName = freezed,
    Object? promoDesc = freezed,
    Object? productNum = freezed,
  }) {
    return _then(_value.copyWith(
      promoName: freezed == promoName
          ? _value.promoName
          : promoName // ignore: cast_nullable_to_non_nullable
              as String?,
      promoDesc: freezed == promoDesc
          ? _value.promoDesc
          : promoDesc // ignore: cast_nullable_to_non_nullable
              as String?,
      productNum: freezed == productNum
          ? _value.productNum
          : productNum // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromoImplCopyWith<$Res> implements $PromoCopyWith<$Res> {
  factory _$$PromoImplCopyWith(
          _$PromoImpl value, $Res Function(_$PromoImpl) then) =
      __$$PromoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'promo_name') String? promoName,
      @JsonKey(name: 'promo_desc') String? promoDesc,
      @JsonKey(name: 'product_num') int? productNum});
}

/// @nodoc
class __$$PromoImplCopyWithImpl<$Res>
    extends _$PromoCopyWithImpl<$Res, _$PromoImpl>
    implements _$$PromoImplCopyWith<$Res> {
  __$$PromoImplCopyWithImpl(
      _$PromoImpl _value, $Res Function(_$PromoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promoName = freezed,
    Object? promoDesc = freezed,
    Object? productNum = freezed,
  }) {
    return _then(_$PromoImpl(
      promoName: freezed == promoName
          ? _value.promoName
          : promoName // ignore: cast_nullable_to_non_nullable
              as String?,
      promoDesc: freezed == promoDesc
          ? _value.promoDesc
          : promoDesc // ignore: cast_nullable_to_non_nullable
              as String?,
      productNum: freezed == productNum
          ? _value.productNum
          : productNum // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromoImpl with DiagnosticableTreeMixin implements _Promo {
  const _$PromoImpl(
      {@JsonKey(name: 'promo_name') this.promoName,
      @JsonKey(name: 'promo_desc') this.promoDesc,
      @JsonKey(name: 'product_num') this.productNum});

  factory _$PromoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromoImplFromJson(json);

  @override
  @JsonKey(name: 'promo_name')
  final String? promoName;
  @override
  @JsonKey(name: 'promo_desc')
  final String? promoDesc;
  @override
  @JsonKey(name: 'product_num')
  final int? productNum;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Promo(promoName: $promoName, promoDesc: $promoDesc, productNum: $productNum)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Promo'))
      ..add(DiagnosticsProperty('promoName', promoName))
      ..add(DiagnosticsProperty('promoDesc', promoDesc))
      ..add(DiagnosticsProperty('productNum', productNum));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromoImpl &&
            (identical(other.promoName, promoName) ||
                other.promoName == promoName) &&
            (identical(other.promoDesc, promoDesc) ||
                other.promoDesc == promoDesc) &&
            (identical(other.productNum, productNum) ||
                other.productNum == productNum));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, promoName, promoDesc, productNum);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromoImplCopyWith<_$PromoImpl> get copyWith =>
      __$$PromoImplCopyWithImpl<_$PromoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromoImplToJson(
      this,
    );
  }
}

abstract class _Promo implements Promo {
  const factory _Promo(
      {@JsonKey(name: 'promo_name') final String? promoName,
      @JsonKey(name: 'promo_desc') final String? promoDesc,
      @JsonKey(name: 'product_num') final int? productNum}) = _$PromoImpl;

  factory _Promo.fromJson(Map<String, dynamic> json) = _$PromoImpl.fromJson;

  @override
  @JsonKey(name: 'promo_name')
  String? get promoName;
  @override
  @JsonKey(name: 'promo_desc')
  String? get promoDesc;
  @override
  @JsonKey(name: 'product_num')
  int? get productNum;
  @override
  @JsonKey(ignore: true)
  _$$PromoImplCopyWith<_$PromoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
