import 'dart:convert';

import 'package:http/http.dart' as http;

Future<LicenseResponse> getLicense() async {
  var url = Uri.parse('url/aliexpress/xinghe/merchant/license/get');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'},
    body: {
      'app_key': '12345678',
      'timestamp': '1706153923498',
      'sign_method': 'sha256',
      'sign': 'D13F2A03BE94D9AAE9F933FFA7B13E0A5AD84A3DAEBC62A458A3C382EC2E91EC',
      'param0':
          '%7B%22sellerAdminSeq%22%3A%22%5C%22200689478%5C%22%22%2C%22channel%22%3A%22%5C%22FACEBOOK%5C%22%22%7D',
    },
  );

  if (response.statusCode == 200) {
    return LicenseResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load license');
  }
}

class LicenseResponse {
  final String code;
  final License result;
  final String requestId;

  LicenseResponse({required this.code, required this.result, required this.requestId});

  factory LicenseResponse.fromJson(Map<String, dynamic> json) {
    return LicenseResponse(
      code: json['code'],
      result: License.fromJson(json['result']),
      requestId: json['request_id'],
    );
  }
}

class License {
  final String retryAble;
  final Data data;
  final String resultMessage;
  final String success;
  final String resultCode;

  License(
      {required this.retryAble,
      required this.data,
      required this.resultMessage,
      required this.success,
      required this.resultCode});

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      retryAble: json['retry_able'],
      data: Data.fromJson(json['data']),
      resultMessage: json['result_message'],
      success: json['success'],
      resultCode: json['result_code'],
    );
  }
}

class Data {
  final String fileName;
  final String content;

  Data({required this.fileName, required this.content});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      fileName: json['file_name'],
      content: json['content'],
    );
  }
}
