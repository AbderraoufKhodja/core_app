part of ds_api;

extension DsCalculateFreightExtension on DsAPI {
// Define a function to calculate the freight using the API
  Future<void> calculateFreight(FreightCalculateParams params) async {
    // Construct the base URL with the API name
    final url = Uri.parse('$_baseUrl/aliexpress.logistics.buyer.freight.get');

    // Construct the parameters
    final parameters = {
      'app_key': _appKey,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'sign_method': _signMethod,
      'aeopFreightCalculateForBuyerDTO': params.toJson(),
    };

    final _sign = Utils.sign(
      _appSecret,
      'aliexpress.logistics.buyer.freight.get',
      parameters,
    );

    parameters.addAll({'sign': _sign});

    // Make a POST request and get the response
    final response = await http.post(url, body: parameters);

    // Print the response body
    print(response.body);
  }
}
