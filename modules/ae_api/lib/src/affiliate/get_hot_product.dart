part of affiliate_api;

extension HotProduct on AffiliateAPI {
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
  Future<HotProductsResponse> getHotProduct(
    HotProductRequestParams params,
  ) async {
    const url = 'https://api-sg.aliexpress.com/sync';
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'
    };

    const _apiMethod = 'aliexpress.affiliate.hotproduct.query';
    final body = {
      'app_key': _appKey,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'sign_method': _signMethod,
      'method': _apiMethod,
      // 'app_signature': _appSignature,
      ...params.toJson(),
    };

    body['sign'] = Utils.sign(_appSecret, _apiMethod, body);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return HotProductsResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load hot product download');
    }
  }
}
