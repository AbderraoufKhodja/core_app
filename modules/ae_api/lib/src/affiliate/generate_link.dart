part of affiliate_api;

extension PromotionLinks on AffiliateAPI {
  /// Defines a method that generates promotion links using the AliExpress API
  /// The method takes the following parameters:
  /// - url: the base URL of the API
  /// - appKey: the app key of the API
  /// - timestamp: the timestamp of the request
  /// - signMethod: the sign method of the request
  /// - sign: the sign of the request
  /// - appSignature: the app signature of the request
  /// - promotionLinkType: the promotion link type of the request
  /// - sourceValues: the source values of the request
  /// - trackingId: the tracking id of the request
  /// - accessToken: the access token of the API
  /// The method returns a Future of an AliExpressResponse object
  Future<AliExpressResponse> generatePromotionLinks(
      {required String url,
      required String appKey,
      required String timestamp,
      required String signMethod,
      required String sign,
      required String appSignature,
      required String promotionLinkType,
      required String sourceValues,
      required String trackingId,
      required String accessToken}) async {
    // Creates a map of the request parameters
    final params = {
      'app_key': appKey,
      'timestamp': timestamp,
      'sign_method': signMethod,
      'method': 'aliexpress.marketing.promotion.links.generate',
      'accessToken': accessToken,
      'sign': sign,
      'app_signature': appSignature,
      'promotion_link_type': promotionLinkType,
      'source_values': sourceValues,
      'tracking_id': trackingId
    };

    // Encodes the request parameters as a URL query string
    final query = Uri(queryParameters: params).query;

    // Appends the query string to the base URL
    final apiUrl = '$url$query';

    // Creates a map of the request headers
    final headers = {'Content-Type': 'application/json'};

    // Tries to make a POST request to the API endpoint
    try {
      // Sends the request and awaits for the response
      http.Response response = await http.post(Uri.parse(apiUrl), headers: headers);

      // Checks if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parses the response body as a JSON map
        Map<String, dynamic> data = jsonDecode(response.body);

        // Constructs an AliExpressResponse object from the JSON map
        AliExpressResponse aliExpressResponse = AliExpressResponse.fromJson(data);

        // Returns the AliExpressResponse object
        return aliExpressResponse;
      } else {
        // Throws an exception with the response status code
        throw Exception('Failed to generate promotion links: ${response.statusCode}');
      }
    } catch (e) {
      // Prints the error message
      print(e.toString());

      // Re-throws the exception
      rethrow;
    }
  }
}
