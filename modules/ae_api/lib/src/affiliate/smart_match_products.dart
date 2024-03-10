part of affiliate_api;

extension AffiliateSmartMatchProductsExtension on AffiliateAPI {
  Future<SmartMatchProductsResponse> getSmartMatchProducts(RequestParams requestParams) async {
    final url = Uri.parse('https://api-sg.aliexpress.com/sync');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'};
    const apiMethod = 'aliexpress.affiliate.product.smartmatch';
    final body = {
      'app_key': _appKey,
      'sign_method': _signMethod,
      'method': apiMethod,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'app': app,
      // 'app_signature': appSignature,
      ...requestParams.toJson()..removeWhere((key, value) => value == null),
    };

    final sign = Utils.sign(_appSecret, apiMethod, body);

    body['sign'] = sign;

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return SmartMatchProductsResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to fetch smart match products');
    }
  }
}
