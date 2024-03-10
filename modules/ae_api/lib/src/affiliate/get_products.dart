part of affiliate_api;

extension GetProductsExtension on AffiliateAPI {
  Future<List<Product>> getProducts({
    String? categoryIds,
    String? fields,
    String? keywords,
    String? maxSalePrice,
    String? minSalePrice,
    String? pageNo,
    String? pageSize,
    String? platformProductType,
    String? sort,
    String? targetCurrency,
    String? targetLanguage,
    String? trackingId,
    String? shipToCountry,
    String? deliveryDays,
  }) async {
    final url = Uri.parse(_baseUrl);
    const apiMethod = 'aliexpress.affiliate.product.query';
    final headers = {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'};

    final body = {
      'app_key': _appKey,
      'sign_method': _signMethod,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'method': apiMethod,
      'keywords': 'phone',
      if (categoryIds?.isNotEmpty == true) 'category_ids': categoryIds,
      if (fields?.isNotEmpty == true) 'fields': fields,
      if (keywords?.isNotEmpty == true) 'keywords': keywords,
      if (maxSalePrice?.isNotEmpty == true) 'max_sale_price': maxSalePrice,
      if (minSalePrice?.isNotEmpty == true) 'min_sale_price': minSalePrice,
      if (pageNo?.isNotEmpty == true) 'page_no': pageNo,
      if (pageSize?.isNotEmpty == true) 'page_size': pageSize,
      if (platformProductType?.isNotEmpty == true) 'platform_product_type': platformProductType,
      if (sort?.isNotEmpty == true) 'sort': sort,
      if (targetCurrency?.isNotEmpty == true) 'target_currency': targetCurrency,
      if (targetLanguage?.isNotEmpty == true) 'target_language': targetLanguage,
      if (trackingId?.isNotEmpty == true) 'tracking_id': trackingId,
      if (shipToCountry?.isNotEmpty == true) 'ship_to_country': shipToCountry,
      if (deliveryDays?.isNotEmpty == true) 'delivery_days': deliveryDays,
    };

    final signID = Utils.sign(
      _appSecret,
      apiMethod,
      body,
    );

    body.addEntries([MapEntry('sign', signID)]);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final productsJson = jsonBody['aliexpress_affiliate_product_query_response']['resp_result']
          ['result']['products']['product'] as List<dynamic>;
      return productsJson.map((productJson) => Product.fromJson(productJson)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
