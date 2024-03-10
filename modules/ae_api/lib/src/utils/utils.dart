import 'dart:convert';

import 'package:crypto/crypto.dart';

class Utils {
  static num? numNullSafeParser(dynamic value) =>
      value != null ? num.tryParse(value.toString()) : null;

  static String sign(
      String appSecret, String apiMethod, Map<String, dynamic> parameters) {
    parameters.removeWhere((key, value) => value == null);
    // Sort the parameters
    var sortedKeys = parameters.keys.toList(growable: false)
      ..sort((k1, k2) => k1.compareTo(k2));
    Map<String, String> sortedParameters = {
      for (var k in sortedKeys) k: parameters[k]
    };

    // Construct the parameters string
    String parametersStr;
    if (apiMethod.contains('/')) {
      parametersStr = apiMethod +
          sortedParameters.entries.map((e) => e.key + e.value).join();
    } else {
      parametersStr =
          sortedParameters.entries.map((e) => e.key + e.value).join();
    }

    // Calculate the HMAC-SHA256 hash
    var key = utf8.encode(appSecret);
    var bytes = utf8.encode(parametersStr);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    // Return the hash in uppercase hexadecimal
    return digest.toString().toUpperCase();
  }
}
