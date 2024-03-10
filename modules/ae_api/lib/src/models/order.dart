/// Represents an order in the response from the AliExpress API.
class Order {
  /// The estimated commission for the paid order. This is likely calculated based on the total order amount and the commission rate.
  final String estimatedFinishedCommission;

  /// The URL of the product detail page. This URL can be used to view detailed information about the product.
  final String productDetailUrl;

  /// The estimated commission for the paid order. This is likely calculated based on the total order amount and the commission rate.
  final String estimatedPaidCommission;

  /// The number of products in the order.
  final num productCount;

  /// The order number. This field is discarded, please use subOrderId instead.
  final String orderNumber;

  /// Indicates whether the product is a hot product. Possible values are 'Y' or 'N'.
  final String isHotProduct;

  /// The parent order number. This field is discarded, please use orderId instead.
  final String parentOrderNumber;

  /// The main image URL of the product.
  final String productMainImageUrl;

  /// The status of the order. Possible values are 'Payment Completed', 'Buyer Confirmed Receipt', 'Completed Settlement', and 'Invalid'.
  final String orderStatus;

  /// The currency in which the order is settled.
  final String settledCurrency;

  /// The ID of the category that the product belongs to.
  final String categoryId;
  // generate all the rest of the fields
  /// The ID of the product.
  final String productId;

  /// The type of the order. Possible values are 'global', 'ru_site', 'es_site', and 'it_site'.
  final String orderType;

  /// The tracking ID of the order.
  final String trackingId;

  /// The time when the order was created.
  final String createdTime;

  /// The time when the buyer confirmed receipt.
  final String finishedTime;

  /// The time when the commission was paid into the Account Balance.
  final String completedSettlementTime;

  /// The time of payment for the order.
  final String paidTime;

  /// Custom parameters for the order.
  final String customParameters;

  /// Indicates whether the buyer is a new buyer. Possible values are 'Y' or 'N'.
  final String isNewBuyer;

  /// The country/region to which the order is shipped.
  final String shipToCountry;

  /// The sub order ID.
  final String subOrderId;

  /// The title of the product.
  final String productTitle;

  /// The incentive commission rate. This field is discarded.
  final String incentiveCommissionRate;

  /// The new buyer bonus commission.
  final String newBuyerBonusCommission;

  /// The estimated incentive paid commission. This field is discarded.
  final String estimatedIncentivePaidCommission;

  /// Indicates whether the product is an affiliate product.
  final String isAffiliateProduct;

  /// The payment amount of the order.
  final num paidAmount;

  /// The order detail status. This field is discarded, please use `orderStatus` instead.
  final String effectDetailStatus;

  /// The estimated incentive finished commission. This field is discarded.
  final num estimatedIncentiveFinishedCommission;

  /// The commission rate.
  final String commissionRate;

  /// The amount of the finished order.
  final num finishedAmount;

  /// The order ID.
  final String orderId;

  Order({
    required this.orderNumber,
    required this.parentOrderNumber,
    required this.estimatedFinishedCommission,
    required this.productDetailUrl,
    required this.estimatedPaidCommission,
    required this.productCount,
    required this.isHotProduct,
    required this.productMainImageUrl,
    required this.orderStatus,
    required this.categoryId,
    required this.settledCurrency,
    required this.productId,
    required this.orderType,
    required this.trackingId,
    required this.createdTime,
    required this.finishedTime,
    required this.completedSettlementTime,
    required this.paidTime,
    required this.isNewBuyer,
    required this.subOrderId,
    required this.customParameters,
    required this.shipToCountry,
    required this.productTitle,
    required this.incentiveCommissionRate,
    required this.newBuyerBonusCommission,
    required this.estimatedIncentivePaidCommission,
    required this.isAffiliateProduct,
    required this.paidAmount,
    required this.effectDetailStatus,
    required this.estimatedIncentiveFinishedCommission,
    required this.commissionRate,
    required this.finishedAmount,
    required this.orderId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['order_number'],
      parentOrderNumber: json['parent_order_number'],
      estimatedFinishedCommission: json['estimated_finished_commission'],
      productDetailUrl: json['product_detail_url'],
      estimatedPaidCommission: json['estimated_paid_commission'],
      productCount: num.parse(json['product_count']),
      isHotProduct: json['is_hot_product'],
      productMainImageUrl: json['product_main_image_url'],
      orderStatus: json['order_status'],
      categoryId: json['category_id'],
      settledCurrency: json['settled_currency'],
      productId: json['product_id'],
      orderType: json['order_type'],
      trackingId: json['tracking_id'],
      createdTime: json['created_time'],
      finishedTime: json['finished_time'],
      completedSettlementTime: json['completed_settlement_time'],
      paidTime: json['paid_time'],
      isNewBuyer: json['is_new_buyer'],
      subOrderId: json['sub_order_id'],
      customParameters: json['custom_parameters'],
      shipToCountry: json['ship_to_country'],
      productTitle: json['product_title'],
      incentiveCommissionRate: json['incentive_commission_rate'],
      newBuyerBonusCommission: json['new_buyer_bonus_commission'],
      estimatedIncentivePaidCommission: json['estimated_incentive_paid_commission'],
      isAffiliateProduct: json['is_affiliate_product'],
      paidAmount: num.parse(json['paid_amount']),
      effectDetailStatus: json['effect_detail_status'],
      estimatedIncentiveFinishedCommission:
          num.parse(json['estimated_incentive_finished_commission']),
      commissionRate: json['commission_rate'],
      finishedAmount: num.parse(json['finished_amount']),
      orderId: json['order_id'],
    );
  }
}
