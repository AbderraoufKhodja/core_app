// Imports the http package

class AliExpressResponse {
  // The code of the API response
  final String code;
  // The result of the API response
  final List<PromotionLink> result;
  // The tracking id of the API response
  final String trackingId;
  // The request id of the API response
  final String requestId;

  // Constructs an AliExpressResponse object from a JSON map
  AliExpressResponse.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        result = (json['resp_result']['result']['promotion_links'] as List)
            .map((e) => PromotionLink.fromJson(e))
            .toList(),
        trackingId = json['resp_result']['result']['tracking_id'],
        requestId = json['request_id'];
}

class PromotionLink {
  // The URL of the promotion link
  final String promotionLink;
  // The URL of the promotion link
  final String promotionShortLink;

  // Constructs a PromotionLink object from a JSON map
  PromotionLink.fromJson(Map<String, dynamic> json)
      : promotionLink = json['promotion_link'],
        promotionShortLink = json['promotion_short_link'];
}
