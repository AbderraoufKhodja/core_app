import 'dart:typed_data';

import 'package:ae_api/affiliate_api.dart';
import 'package:ae_api/ds_api.dart';
import 'package:ae_api/ae_api.dart';

class AeRepository {
  static Future<AeDsRecommendFeedGetResponse> getRecommendedFeed({
    String feedName = FeedName.DS_France_fastdelivery_20231123,
    String? country,
    String? pageNo,
    String? pageSize,
    String? targetCurrency,
    String? targetLanguage,
    String? timestamp,
    String? sort,
    String? categoryId,
  }) {
    return AliExpress.dsAPI.getRecommendFeed(
      feedName: feedName,
      country: country,
      pageNo: pageNo,
      pageSize: pageSize,
      targetCurrency: targetCurrency,
      targetLanguage: targetLanguage,
      timestamp: timestamp,
      sort: sort,
      categoryId: categoryId,
    );
  }

  static Future<ImageSearchResponse> imageSearch({
    required Uint8List imageFileBytes,
    required String shpt_to,
    String? targetCurrency,
    String? targetLanguage,
    String? sort,
  }) {
    return AliExpress.dsAPI.imageSearch(
      targetCurrency: targetCurrency,
      targetLanguage: targetLanguage,
      sort: sort,
      shpt_to: shpt_to,
      imageFileBytes: imageFileBytes,
    );
  }

  static Future<HotProductsResponse> getHotProducts(
      HotProductRequestParams hotProductRequestParams) {
    return AliExpress.affiliateAPI.getHotProduct(hotProductRequestParams);
  }

  static Future<FeaturedPromoResponse> getFeaturedPromos() {
    return AliExpress.affiliateAPI.getFeaturedPromos();
  }

  static Future<FeaturedPromoProductsResponse> getFeaturedPromoProducts(
      FeaturedPromoProductsRequestParams params) {
    return AliExpress.affiliateAPI.getFeaturedPromoProducts(params);
  }

  static Future<AeDSProductGetResponse> getProductInfo(ProductInfoQuery infoQuery) {
    return AliExpress.dsAPI.getProductInfo(infoQuery);
  }
}
