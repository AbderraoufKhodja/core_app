part of ds_api;

extension DsFreightCalculateExtension on DsAPI {
// Define the API method for freight calculation interface provided for buyers
  Future<FreightCalculateResponse> freightCalculate(
      Map<String, dynamic> paramAeopFreightCalculateForBuyerDTO) async {
    // Create an instance of the http client
    http.Client client = http.Client();

    // Create a map for the request parameters
    final requestParams = {
      'apiName': 'aliexpress.logistics.buyer.freight.calculate',
      'param_aeop_freight_calculate_for_buyer_d_t_o':
          jsonEncode(paramAeopFreightCalculateForBuyerDTO),
    };

    // Create the request URL with the app key and app secret
    var requestUrl = '$_baseUrl?appkey=$_appKey&appSecret=$_appSecret';

    // Add the request parameters to the request URL
    requestParams.forEach((key, value) {
      requestUrl += '&$key=$value';
    });

    // Make a GET request to the API and get the response
    // TODO: Replace the access token with your own
    final _accessToken = 'TODO';
    http.Response response =
        await client.get(Uri.parse(requestUrl), headers: {'Authorization': 'Bearer $_accessToken'});

    // Close the client
    client.close();

    // Parse the response body as JSON
    final responseBody = jsonDecode(response.body);

    // Create an instance of the model class from the response body
    final freightCalculateResponse = FreightCalculateResponse.fromJson(responseBody);

    // Return the model instance
    return freightCalculateResponse;
  }
}
