part of affiliate_api;

extension ProductDetailInfo on AffiliateAPI {
  /// Fetches detailed information about a product from the AliExpress API.
  ///
  /// This method is particularly useful when you need detailed information about a specific product,
  /// such as its price, images, category, shop, and promotional details.
  ///
  /// The method takes the following parameters:
  /// - `appKey`: The application key for the API.
  /// - `timestamp`: The timestamp for the request.
  /// - `signMethod`: The signing method for the request.
  /// - `sign`: The sign for the request.
  /// - `fields`: The fields to be included in the response.
  /// - `productIds`: The IDs of the products to fetch information for.
  /// - `targetCurrency`: The currency to use for the price fields in the response.
  /// - `targetLanguage`: The language to use for the text fields in the response.
  /// - `trackingId`: The tracking ID for the request.
  /// - `country`: The country for the request.
  ///
  /// Returns a [Future<Product>] object containing the detailed information about the product.
  /// This object includes various types of information about the product, including its price, images, category, shop, and promotional details.
  ///
  /// Throws an [Exception] if the request fails, for example, due to network issues or if the server returns a non-200 status code.
  Future<Product> getProductDetailInfo({
    required String appKey,
    required String timestamp,
    required String signMethod,
    required String sign,
    required String fields,
    required String productIds,
    required String targetCurrency,
    required String targetLanguage,
    required String trackingId,
    required String country,
  }) async {
    final url = 'https://api-sg.aliexpress.com/sync';
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'
    };
    final body = {
      'app_key': appKey,
      'timestamp': timestamp,
      'sign_method': signMethod,
      'sign': sign,
      'fields': fields,
      'product_ids': productIds,
      'target_currency': targetCurrency,
      'target_language': targetLanguage,
      'tracking_id': trackingId,
      'country': country,
    };

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['resp_result']['result']['products'][0];
      return Product.fromJson(result);
    } else {
      throw Exception('Failed to get product detail info');
    }
  }
}
