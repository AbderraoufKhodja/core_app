import 'package:cloud_functions/cloud_functions.dart';

class CallMethods {
  static Future<Map<String, dynamic>?> makeCloudCall({
    required int uid,
    required String channelName,
  }) async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('createCallsWithToken');
      dynamic response = await callable.call({
        'channelName': channelName,
        'uid': uid,
      });

      final result = {
        'token': response.data['data']['token'],
        'channelId': response.data['data']['channelId'],
      };

      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
