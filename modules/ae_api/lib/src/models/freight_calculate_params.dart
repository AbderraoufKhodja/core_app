class FreightCalculateParams {
  final String countryCode;
  final String price;
  final String productId;
  final String cityCode;
  final String sendGoodsCountryCode;
  final String productNum;
  final String skuId;
  final String provinceCode;
  final String priceCurrency;

  FreightCalculateParams(
      {required this.countryCode,
      required this.price,
      required this.productId,
      required this.cityCode,
      required this.sendGoodsCountryCode,
      required this.productNum,
      required this.skuId,
      required this.provinceCode,
      required this.priceCurrency});

  // Convert the parameters to a JSON string
  String toJson() {
    return '{"country_code":"$countryCode","price":"$price","product_id":"$productId","city_code":"$cityCode","send_goods_country_code":"$sendGoodsCountryCode","product_num":"$productNum","sku_id":"$skuId","province_code":"$provinceCode","price_currency":"$priceCurrency"}';
  }
}
