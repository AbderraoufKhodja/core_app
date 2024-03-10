import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_hot_products_result.freezed.dart';
part 'get_hot_products_result.g.dart';

@freezed
class GetHotProductsResult with _$GetHotProductsResult {
  const factory GetHotProductsResult({
    int? currentRecordCount,
    int? totalRecordCount,
    int? currentPageNo,
    Map<String, dynamic>? products,
  }) = _GetHotProductsResult;

  factory GetHotProductsResult.fromJson(Map<String, Object?> json) =>
      _$GetHotProductsResultFromJson(json);
}
