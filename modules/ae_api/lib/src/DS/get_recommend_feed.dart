part of ds_api;

extension DsRecommendFeedExtension on DsAPI {
  /// `getRecommendFeed` is a method that fetches a recommended feed from the AliExpress API.
  ///
  /// Parameters:
  /// - `feedName`: The name of the feed to fetch. This is a required parameter.
  /// - `appKey`: The application key provided by AliExpress for API access. This is a required parameter.
  /// - `timestamp` (optional): The current timestamp. If not provided, the current time will be used.
  /// - `country` (optional): Screens the subject product library for the target country.
  /// - `targetCurrency` (optional): The currency in which the product price should be displayed.
  /// - `targetLanguage` (optional): The language in which the product details should be displayed.
  /// - `pageSize` (optional): The record count of each page. The possible values are integers from 1 to 50.
  /// - `pageNo` (optional): The page number. The possible values are integers representing the page number.
  ///
  /// Returns:
  /// A `Future` that completes with an `AliExpressResponse` object containing the response from the AliExpress API.
  ///
  /// Throws:
  /// An `Exception` if the server did not return a 200 OK response.
  Future<AeDsRecommendFeedGetResponse> getRecommendFeed({
    String? timestamp,
    String? country,
    String? targetCurrency,
    String? targetLanguage,
    required String feedName,
    String? pageSize,
    String? pageNo,
    String? sort,
    String? categoryId,
  }) async {
    const apiMethod = 'aliexpress.ds.recommend.feed.get';
    final parameters = <String, dynamic>{
      'app_key': _appKey,
      'feed_name': feedName,
      'sign_method': 'sha256',
      'timestamp': timestamp ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'method': apiMethod,
      if (country != null) 'country': country,
      if (targetCurrency != null) 'target_currency': targetCurrency,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (pageSize != null) 'page_size': pageSize,
      if (pageNo != null) 'page_no': pageNo,
      if (sort != null) 'sort': sort,
      if (categoryId != null) 'category_id': categoryId,
    };
    final signID = Utils.sign(
      _appSecret,
      apiMethod,
      parameters,
    );
    parameters.addEntries([MapEntry('sign', signID)]);

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
      body: parameters,
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      return AeDsRecommendFeedGetResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load feed');
    }
  }
}
