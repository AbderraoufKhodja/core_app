part of affiliate_api;

/// This class represents the AliExpress API and provides a method to fetch the order list.
extension OrderList on AffiliateAPI {
  /// Fetches the order list from the AliExpress API.
  ///
  /// The method takes the following parameters:
  /// - `accessToken`: The access token for the API.
  /// - `appKey`: The application key for the API.
  /// - `timestamp`: The timestamp for the request.
  /// - `signMethod`: The signing method for the request.
  /// - `sign`: The sign for the request.
  /// - `timeType`: The time type for the request.
  /// - `appSignature`: The application signature for the request.
  /// - `endTime`: The end time for the request.
  /// - `fields`: The fields to be included in the response.
  /// - `localeSite`: The locale site for the request.
  /// - `pageNo`: The page number for the request.
  /// - `pageSize`: The page size for the request.
  /// - `startTime`: The start time for the request.
  /// - `status`: The status for the request.
  ///
  /// Returns a [Future<OrderListResponse>] object containing the response data.
  /// This object includes information about the total number of records, the current record count,
  /// the total number of pages, the current page number, and a list of orders.
  ///
  /// Throws an [Exception] if the request fails, for example, due to network issues or if the server returns a non-200 status code.
  Future<_ApiResponse> getOrderList({
    required String accessToken,
    required String appKey,
    required String timestamp,
    required String signMethod,
    required String sign,
    required String timeType,
    required String appSignature,
    required String endTime,
    required String fields,
    required String localeSite,
    required String pageNo,
    required String pageSize,
    required String startTime,
    required String status,
  }) async {
    try {
      final url = Uri.parse(_baseUrl);
      final headers = {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'};
      // Define the body
      final body = {
        'app_key': appKey,
        'timestamp': timestamp,
        'sign_method': signMethod,
        'method': 'aliexpress.affiliate.order.list',
        'sign': sign,
        'time_type': timeType,
        'app_signature': appSignature,
        'end_time': endTime,
        'fields': fields,
        'locale_site': localeSite,
        'page_no': pageNo,
        'page_size': pageSize,
        'start_time': startTime,
        'status': status,
      };

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return _ApiResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch order list');
      }
    } catch (e) {
      throw Exception('Failed to fetch order list: $e');
    }
  }
}

/// This class represents the response from the AliExpress API.
class _ApiResponse {
  final String code;
  final RespResult respResult;
  final String requestId;

  _ApiResponse({required this.code, required this.respResult, required this.requestId});

  /// Creates an [_ApiResponse] object from a JSON map.
  factory _ApiResponse.fromJson(Map<String, dynamic> json) {
    return _ApiResponse(
      code: json['code'],
      respResult: RespResult.fromJson(json['resp_result']),
      requestId: json['request_id'],
    );
  }
}

/// This class represents the response result from the AliExpress API.
class RespResult {
  final String respCode;
  final String respMsg;
  final JsonSerializable result;

  RespResult({required this.respCode, required this.respMsg, required this.result});

  /// Creates a [RespResult] object from a JSON map.
  factory RespResult.fromJson(Map<String, dynamic> json) {
    return RespResult(
      respCode: json['resp_code'],
      respMsg: json['resp_msg'],
      result: JsonSerializable.fromJson(json['result']),
    );
  }
}

/// This class represents the result from the AliExpress API.
class OrdersResult {
  /// A string representing the total number of records in the dataset.
  /// This is the total count of all orders across all pages.
  final String totalRecordCount;

  /// A string representing the number of records in the current page.
  /// This is the count of orders in the current page.
  final String currentRecordCount;

  /// A string representing the total number of pages in the dataset.
  /// This is calculated by dividing the total record count by the number of records per page.
  final String totalPageNo;

  /// A string representing the current page number in the dataset.
  /// This is the page number of the current set of orders.
  final String currentPageNo;

  /// A list of `Order` objects. Each `Order` object represents an individual order
  /// with its own set of properties like order number, product count, estimated commission, etc.
  final List<Order> orders;

  OrdersResult({
    required this.totalRecordCount,
    required this.currentRecordCount,
    required this.totalPageNo,
    required this.currentPageNo,
    required this.orders,
  });

  /// Creates a [OrdersResult] object from a JSON map.
  factory OrdersResult.fromJson(Map<String, dynamic> json) {
    return OrdersResult(
      totalRecordCount: json['total_record_count'],
      currentRecordCount: json['current_record_count'],
      totalPageNo: json['total_page_no'],
      currentPageNo: json['current_page_no'],
      orders: List<Order>.from(json['orders'].map((x) => Order.fromJson(x))),
    );
  }
}
