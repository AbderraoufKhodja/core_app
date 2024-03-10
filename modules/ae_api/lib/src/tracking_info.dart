part of ae_api;

// A model class to represent the response from the API
class TrackingInfo {
  final String? officialWebsite;
  final String? code;
  final String? errorDesc;
  final List<Detail?>? details;
  final bool? resultSuccess;
  final String? requestId;

  TrackingInfo(
      {this.officialWebsite,
      this.code,
      this.errorDesc,
      this.details,
      this.resultSuccess,
      this.requestId});

  // A factory method to create a TrackingInfo instance from a JSON map
  factory TrackingInfo.fromJson(Map<String, dynamic> json) {
    return TrackingInfo(
        officialWebsite: json['official_website'],
        code: json['code'],
        errorDesc: json['error_desc'],
        details: (json['details'] as List)
            .map((e) => e == null ? null : Detail.fromJson(e as Map<String, dynamic>))
            .toList(),
        resultSuccess: json['result_success'],
        requestId: json['request_id']);
  }

  // A method to convert a TrackingInfo instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'official_website': officialWebsite,
      'code': code,
      'error_desc': errorDesc,
      'details': details?.map((e) => e?.toJson()).toList(),
      'result_success': resultSuccess,
      'request_id': requestId
    };
  }
}

// A model class to represent the details of the tracking information
class Detail {
  final String? eventDesc;
  final String? signedName;
  final String? address;
  final String? eventDate;
  final String? status;

  Detail({this.eventDesc, this.signedName, this.address, this.eventDate, this.status});

  // A factory method to create a Detail instance from a JSON map
  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
        eventDesc: json['event_desc'],
        signedName: json['signed_name'],
        address: json['address'],
        eventDate: json['event_date'],
        status: json['status']);
  }

  // A method to convert a Detail instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'event_desc': eventDesc,
      'signed_name': signedName,
      'address': address,
      'event_date': eventDate,
      'status': status
    };
  }
}

// // An API method to query logistics tracking information using HTTP POST
// Future<TrackingInfo> queryTrackingInfo(
//     String logisticsNo, String origin, String outRef, String serviceName, String toArea) async {
//   // The base URL of the API
//   String url = 'https://api.aliexpress.com/aliexpress.logistics.ds.trackinginfo.query';

//   // The parameters of the API request
//   Map<String, String> params = {
//     'app_key': '12345678', // Replace with your own app key
//     'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//     'access_token': '37c66819338b4562e17675b8c5c4dbd0', // Replace with your own access token
//     'sign_method': 'sha256',
//     'sign': '', // Replace with your own sign
//     'logistics_no': logisticsNo,
//     'origin': origin,
//     'out_ref': outRef,
//     'service_name': serviceName,
//     'to_area': toArea
//   };

//   // TODO: Implement the queryTrackingInfo method
//   // // The HTTP response from the API
//   // http.Response response = await http.post(url, body: params);

//   // // The JSON data from the response
//   // Map<String, dynamic> data = json.decode(response.body);

//   // // Return a TrackingInfo instance from the data
//   // return TrackingInfo.fromJson(data);
// }
