part of affiliate_api;

extension OrdersFromAliExpress on AffiliateAPI {
  /// Fetches orders from AliExpress. This function sends a POST request to the AliExpress API and returns a parsed response. If the request fails, it throws an exception.
  /// #### The parameters are:
  /// - appKey: The application key.
  /// - timestamp: The timestamp of the request.
  /// - signMethod: The method used to sign the request.
  /// - sign: The signature of the request.
  /// - appSignature: The application signature.
  /// - fields: The fields to be returned in the response.
  /// - orderIds: The IDs of the orders to fetch.
  Future<ApiResponse> fetchOrdersFromAliExpress({
    required String appKey,
    required String timestamp,
    required String signMethod,
    required String sign,
    required String appSignature,
    required String fields,
    required String orderIds,
  }) async {
    final response = await http.post(
      Uri.parse('https://api-sg.aliexpress.com/sync'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
      body: {
        'app_key': appKey,
        'timestamp': timestamp,
        'sign_method': signMethod,
        'sign': sign,
        'app_signature': appSignature,
        'fields': fields,
        'order_ids': orderIds,
      },
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

/// Represents the response received from an API call.
class ApiResponse {
  /// The [code] represents the response code.
  final String code;

  /// The [result] contains the result of the API call.
  final OrdersResult result;

  /// The [requestId] is the unique identifier of the request.
  final String requestId;

  /// Creates a new instance of [ApiResponse].
  ApiResponse({required this.code, required this.result, required this.requestId});

  /// Creates a new instance of [ApiResponse] from a JSON object.
  ///
  /// The [json] parameter is a JSON object containing the response data.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      result: OrdersResult.fromJson(json['resp_result']['result']),
      requestId: json['request_id'],
    );
  }
}
