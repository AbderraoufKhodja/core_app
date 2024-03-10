import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_params.freezed.dart';
part 'request_params.g.dart';

@freezed
class RequestParams with _$RequestParams {
  factory RequestParams({
    String? device,
    @JsonKey(name: 'device_id') required String? deviceId,
    String? fields,
    String? keywords,
    @JsonKey(name: 'page_no') int? pageNo,
    @JsonKey(name: 'product_id') String? productId,
    String? site,
    @JsonKey(name: 'target_currency') String? targetCurrency,
    @JsonKey(name: 'target_language') String? targetLanguage,
    @JsonKey(name: 'tracking_id') String? trackingId,
    String? user,
    String? country,
  }) = _RequestParams;

  factory RequestParams.fromJson(Map<String, dynamic> json) => _$RequestParamsFromJson(json);
}
