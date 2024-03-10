part of affiliate_api;

extension FetchProduct on AffiliateAPI {
  Future<FeaturedPromoResponse> getFeaturedPromos() async {
    const _apiMethod = "aliexpress.affiliate.featuredpromo.get";
    final parameters = {
      'app_key': _appKey,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'sign_method': _signMethod,
      'method': _apiMethod,
    };

    parameters['sign'] = Utils.sign(_appSecret, _apiMethod, parameters);

    final response = await http.post(
      Uri.parse('https://api-sg.aliexpress.com/sync'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
      body: parameters,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return FeaturedPromoResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load product');
    }
  }
}
