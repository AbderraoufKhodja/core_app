part of affiliate_api;

extension HotProductDownload on AffiliateAPI {
  /// Retrieves information about a hot product download.
  ///
  /// This method sends a request to the server to get information about a hot product download.
  /// It requires the following parameters:
  /// - [appKey]: The application key.
  /// - [timestamp]: The timestamp of the request.
  /// - [signMethod]: The method used to sign the request.
  /// - [sign]: The signature of the request.
  /// - [appSignature]: The application signature.
  /// - [categoryId]: The ID of the category.
  /// - [fields]: The fields to include in the response.
  /// - [localeSite]: The locale site.
  /// - [pageNo]: The page number.
  /// - [pageSize]: The page size.
  /// - [targetCurrency]: The target currency.
  /// - [targetLanguage]: The target language.
  /// - [trackingId]: The tracking ID.
  /// - [country]: The country.
  ///
  /// Returns a [Future] that resolves to a [GetHotProductsResponse] object.
  Future<HotProductsResponse> getHotProductDownload({
    required String appKey,
    required String timestamp,
    required String signMethod,
    required String sign,
    required String appSignature,
    required String categoryId,
    required String fields,
    required String localeSite,
    required String pageNo,
    required String pageSize,
    required String targetCurrency,
    required String targetLanguage,
    required String trackingId,
    required String country,
  }) async {
    const url = 'https://api-sg.aliexpress.com/sync';
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'
    };
    final body = {
      'app_key': appKey,
      'timestamp': timestamp,
      'sign_method': signMethod,
      'sign': sign,
      'app_signature': appSignature,
      'category_id': categoryId,
      'fields': fields,
      'locale_site': localeSite,
      'page_no': pageNo,
      'page_size': pageSize,
      'target_currency': targetCurrency,
      'target_language': targetLanguage,
      'tracking_id': trackingId,
      'country': country,
    };

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return HotProductsResponse.fromJson(jsonResponse['resp_result']);
      } else {
        throw Exception('Failed to load hot product download');
      }
    } catch (e) {
      throw Exception('Failed to load hot product download: $e');
    }
  }
}
