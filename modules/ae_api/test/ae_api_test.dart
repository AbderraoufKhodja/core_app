import 'dart:convert';
import 'dart:io';

import 'package:ae_api/ae_api.dart';
import 'package:ae_api/affiliate_api.dart';
import 'package:ae_api/ds_api.dart';
import 'package:ae_api/src/models/featured_promo_products_request_params.dart';
import 'package:ae_api/src/models/hot_product_request_params.dart';
import 'package:ae_api/src/models/request_params.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test(' Get product info', () async {
    final response = await AliExpress.dsAPI.getProductInfo(
        ProductInfoQuery(productId: '1005005427505304', shipToCountry: 'DZ'));
  });
  test('Image search', () async {
    // Load image from local file
    final imageFileBytes =
        await File('/Users/khodja/Downloads/ds_image_search.jpeg')
            .readAsBytes();

    final response = await AliExpress.dsAPI.imageSearch(
      imageFileBytes: imageFileBytes,
      shpt_to: 'US',
      productCnt: 50.toString(),
    );
  });
  test('Products query', () async {
    final products = await AliExpress.affiliateAPI.getProducts();

    print(products);
  });

  test('Smart products query', () async {
    final products =
        await AliExpress.affiliateAPI.getSmartMatchProducts(RequestParams(
      deviceId: 'socks',
    ));

    print(products);
  });
  test('Hot products query', () async {
    final products = await AliExpress.affiliateAPI
        .getHotProduct(HotProductRequestParams(keywords: 'mp3'));

    print(products);
  });
  test('Featured promos', () async {
    final products = await AliExpress.affiliateAPI.getFeaturedPromos();

    print(products);
  });
  test('featured promo products', () async {
    final products = await AliExpress.affiliateAPI.getFeaturedPromoProducts(
        FeaturedPromoProductsRequestParams(
            promotionName: 'Hot Product', pageSize: '3'));
    print(45 * 978 + 61 * 982 + 48 * 958);

    print(jsonEncode(products));
  });
}
