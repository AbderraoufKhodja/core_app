class PromoCodeInfo {
  // Promotion code
  final String? promoCode;

  // Campaigntype of promotion 0 means get X$ off from XX, 1 means get X% off from XX.
  final String? codeCampaignType;

  // Value of promotion
  final String? codeValue;

  // Start time of expiry date, PST time
  final String? codeAvailableTimeStart;

  // End time of expiry date, PST time
  final String? codeAvailableTimeEnd;

  // Code minimum threshold 0 means unlimited
  final String? codeMiniSpend;

  // Code remaining usable quantity
  final String? codeQuantity;

  // Product&code in one promotion url
  final String? codePromotionUrl;

  PromoCodeInfo({
    required this.codeCampaignType,
    required this.codeAvailableTimeEnd,
    required this.codeQuantity,
    required this.codeAvailableTimeStart,
    required this.codeValue,
    required this.promoCode,
    required this.codeMiniSpend,
    required this.codePromotionUrl,
  });

  factory PromoCodeInfo.fromJson(Map<String, dynamic> json) {
    return PromoCodeInfo(
      codeCampaignType: json['code_campaigntype'],
      codeAvailableTimeEnd: json['code_availabletime_end'],
      codeQuantity: json['code_quantity'],
      codeAvailableTimeStart: json['code_availabletime_start'],
      codeValue: json['code_value'],
      promoCode: json['promo_code'],
      codeMiniSpend: json['code_mini_spend'],
      codePromotionUrl: json['code_promotionurl'],
    );
  }
}
