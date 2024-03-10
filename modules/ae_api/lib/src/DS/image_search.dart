part of ds_api;

extension AliExpressApiClientExtension on DsAPI {
  /// Sends a POST request to the `aliexpress.ds.image.search` endpoint to search for products using an image.
  ///
  /// The [appKey] is the application key.
  /// The [timestamp] is the current timestamp.
  /// The [signMethod] is the method used for signing the request (e.g., 'sha256').
  /// The [sign] is the signed value of the request.
  /// The [targetLanguage] is the target language for the product information (e.g., 'EN', 'RU', 'PT', etc.). This is optional.
  /// The [targetCurrency] is the target currency for the product prices (e.g., 'USD', 'GBP', 'CAD', etc.). This is optional.
  /// The [productCnt] is the number of products to return, up to a maximum of 150. This is optional.
  /// The [sort] is the sorting method for the products (e.g., 'SALE_PRICE_ASC', 'SALE_PRICE_DESC', etc.). This is optional.
  /// The [shptTo] is the country to which the product will be shipped. This is optional.
  /// The [imageFileBytes] is the byte array of the image used for searching.
  ///
  /// Returns a `Future` that completes with a map containing the response data.
  ///
  /// Throws an `Exception` if the request fails.
  Future<ImageSearchResponse> imageSearch({
    String? targetLanguage,
    String? targetCurrency,
    String? productCnt,
    String? sort,
    String? shptTo,
    required String shpt_to,
    required Uint8List imageFileBytes,
  }) async {
    const apiMethod = 'aliexpress.ds.image.search';
    final parameters = <String, String>{
      'app_key': _appKey,
      'sign_method': 'sha256',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'method': apiMethod,
      'shpt_to': shpt_to,
      if (targetCurrency != null) 'target_currency': targetCurrency,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (productCnt != null) 'product_cnt': productCnt,
      if (sort != null) 'sort': sort,
    };

    final signID = Utils.sign(
      _appSecret,
      apiMethod,
      parameters,
    );

    parameters.addEntries([MapEntry('sign', signID)]);

    final request = http.MultipartRequest('POST', Uri.parse(_baseUrl))
      ..fields.addAll(parameters)
      ..files.add(http.MultipartFile.fromBytes(
          'image_file_bytes', imageFileBytes,
          filename: 'IopSdk.img'));

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final searchResponse = body['aliexpress_ds_image_search_response'];
      return ImageSearchResponse.fromJson(searchResponse);
    } else {
      throw Exception('Failed to load image search');
    }
  }
}

class ImageSearchResponse {
  final String? totalRecordCount;

  final Data? data;
  final String? rspCode;
  final String? rspMsg;

  ImageSearchResponse({
    required this.totalRecordCount,
    required this.data,
    required this.rspCode,
    required this.rspMsg,
  });

  factory ImageSearchResponse.fromJson(Map<String, dynamic> json) {
    return ImageSearchResponse(
      totalRecordCount: json['total_record_count'],
      data: Data.fromJson(json['data']),
      rspCode: json['rsp_code'],
      rspMsg: json['rsp_msg'],
    );
  }
}

class Data {
  final int? totalRecordCount;
  final List<Product> products;

  Data({
    required this.totalRecordCount,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final productsJson =
        json['products']['traffic_image_product_d_t_o'] as List;
    final products =
        productsJson.map((product) => Product.fromJson(product)).toList();
    return Data(
      totalRecordCount: json['total_record_count'],
      products: products,
    );
  }
}
