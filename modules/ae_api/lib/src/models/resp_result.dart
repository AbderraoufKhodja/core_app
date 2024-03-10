abstract class JsonSerializable {
  factory JsonSerializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

class RespResult {
  final JsonSerializable result;
  final String respCode;
  final String respMsg;

  RespResult({required this.result, required this.respCode, required this.respMsg});

  factory RespResult.fromJson(Map<String, dynamic> json) {
    return RespResult(
      result: JsonSerializable.fromJson(json['result']),
      respCode: json['resp_code'],
      respMsg: json['resp_msg'],
    );
  }
}
