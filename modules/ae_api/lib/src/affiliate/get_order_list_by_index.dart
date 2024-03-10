part of affiliate_api;

extension OrderListByIndex on AffiliateAPI {
  /// Fetches the order list from the AliExpress API using an index-based approach.
  ///
  /// This method is particularly useful when dealing with large datasets, as it allows for efficient
  /// pagination by retrieving orders based on their index rather than their page number.
  ///
  /// The method takes the following parameters:
  /// - `appKey`: The application key for the API.
  /// - `timestamp`: The timestamp for the request.
  /// - `signMethod`: The signing method for the request.
  /// - `sign`: The sign for the request.
  /// - `timeType`: The time type for the request.
  /// - `appSignature`: The application signature for the request.
  /// - `endTime`: The end time for the request.
  /// - `fields`: The fields to be included in the response.
  /// - `pageSize`: The page size for the request.
  /// - `startTime`: The start time for the request.
  /// - `status`: The status for the request.
  /// - `startQueryIndexId`: The starting index for the request. This is the index of the first order to be retrieved.
  ///
  /// Returns a [Future<OrderListResponse>] object containing the response data.
  /// This object includes information about the total number of records, the current record count,
  /// the total number of pages, the current page number, and a list of orders.
  ///
  /// Throws an [Exception] if the request fails, for example, due to network issues or if the server returns a non-200 status code.
  Future<OrderListResponse> getOrderListByIndex({
    required String appKey,
    required String timestamp,
    required String signMethod,
    required String sign,
    required String timeType,
    required String appSignature,
    required String endTime,
    required String fields,
    required String pageSize,
    required String startTime,
    required String status,
    required String startQueryIndexId,
  }) async {
    final url = 'url + aliexpress.affiliate.order.listbyindex';
    final headers = {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'};
    final body = {
      'app_key': appKey,
      'timestamp': timestamp,
      'sign_method': signMethod,
      'sign': sign,
      'time_type': timeType,
      'app_signature': appSignature,
      'end_time': endTime,
      'fields': fields,
      'page_size': pageSize,
      'start_time': startTime,
      'status': status,
      'start_query_index_id': startQueryIndexId,
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OrderListResponse.fromJson(json);
    } else {
      throw Exception('Failed to fetch order list');
    }
  }
}

class OrderListResponse {
  /// `code`: A string representing the status code of the response. This is typically used to
  /// determine whether the request was successful or not. A code of '200' usually indicates
  /// a successful request, while other codes may indicate various types of errors.
  final String code;

  /// `respCode`: A string representing the response code from the API. This is similar to `code`,
  /// but it's specific to the API's own set of response codes. It can provide more detailed
  /// information about the result of the request.
  final String respCode;

  /// `respMsg`: A string representing the response message from the API. This is a human-readable
  /// message that describes the result of the request. It can provide useful information for
  /// debugging if the request fails.
  final String respMsg;

  /// `currentRecordCount`: An integer representing the number of records in the current page.
  /// This is the count of orders in the current page.
  final int currentRecordCount;

  /// `orders`: A list of `Order` objects. Each `Order` object represents an individual order
  /// with its own set of properties like order number, product count, estimated commission, etc.
  final List<Order> orders;

  OrderListResponse({
    required this.code,
    required this.respCode,
    required this.respMsg,
    required this.currentRecordCount,
    required this.orders,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      code: json['code'],
      respCode: json['resp_result']['resp_code'],
      respMsg: json['resp_result']['resp_msg'],
      currentRecordCount: int.parse(json['resp_result']['result']['current_record_count']),
      orders:
          List<Order>.from(json['resp_result']['result']['orders'].map((x) => Order.fromJson(x))),
    );
  }
}
