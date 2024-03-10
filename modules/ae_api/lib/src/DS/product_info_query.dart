part of ds_api;

extension ProductInfoExtension on DsAPI {
  Future<AeDSProductGetResponse> getProductInfo(ProductInfoQuery query) async {
    final parameters = query.toJson()
      ..addAll({
        'app_key': _appKey,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'sign_method': _signMethod,
        'method': 'aliexpress.ds.product.get',
      });

    final _sign = Utils.sign(_appSecret, 'aliexpress.ds.product.get', parameters);
    parameters.addAll({'sign': _sign});

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
      body: parameters,
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.

      final productGetResponse = jsonDecode(response.body);

      final aeDSProductGetResponse =
          AeDSProductGetResponse.fromJson(productGetResponse['aliexpress_ds_product_get_response']);
      return aeDSProductGetResponse;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load product info');
    }
  }
}

class ProductInfoQuery {
  /// Country to which the product is shipped
  String? shipToCountry;

  /// ID of the product
  String productId;

  /// Target currency for the product price
  String? targetCurrency;

  /// Target language for the product information
  String? targetLanguage;

  ProductInfoQuery({
    this.shipToCountry,
    required this.productId,
    this.targetCurrency,
    this.targetLanguage,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      if (shipToCountry != null) 'ship_to_country': shipToCountry,
      if (targetCurrency != null) 'target_currency': targetCurrency,
      if (targetLanguage != null) 'target_language': targetLanguage,
      'product_id': productId,
    };
    return data;
  }
}

class AeDSProductGetResponse {
  final ProductInfo result;
  final int rspCode;
  final String rspMsg;
  final String requestId;

  AeDSProductGetResponse({
    required this.result,
    required this.rspCode,
    required this.rspMsg,
    required this.requestId,
  });

  factory AeDSProductGetResponse.fromJson(Map<String, dynamic> json) {
    return AeDSProductGetResponse(
      result: ProductInfo.fromJson(json['result']),
      rspCode: json['rsp_code'],
      rspMsg: json['rsp_msg'],
      requestId: json['request_id'],
    );
  }
}

class ProductInfo {
  final MultimediaInfoDto? aeMultimediaInfoDto;
  final PackageInfoDto? packageInfoDto;
  final AeStoreInfo? aeStoreInfo;
  final ProductIdConverterResult? productIdConverterResult;
  final LogisticsInfoDto? logisticsInfoDto;
  final AeItemBaseInfoDto? aeItemBaseInfoDto;
  final List<AeItemProperties>? aeItemProperties;
  final List<AeItemSkuInfoDtos>? aeItemSkuInfoDtos;
  final List<AeSkuPropertyDtos>? aeSkuPropertyDtos;

  ProductInfo({
    required this.aeMultimediaInfoDto,
    required this.packageInfoDto,
    required this.aeStoreInfo,
    required this.productIdConverterResult,
    required this.logisticsInfoDto,
    required this.aeItemBaseInfoDto,
    required this.aeItemProperties,
    required this.aeItemSkuInfoDtos,
    required this.aeSkuPropertyDtos,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    final aeItemPropertiesJson = json['ae_item_properties']['ae_item_property'] as List?;
    final aeItemProperties = aeItemPropertiesJson
        ?.map((aeItemProperty) => AeItemProperties.fromJson(aeItemProperty))
        .toList();

    final aeItemSkuInfoDtosJson = json['ae_item_sku_info_dtos']['ae_item_sku_info_d_t_o'] as List?;
    final aeItemSkuInfoDtos = aeItemSkuInfoDtosJson
        ?.map((aeItemSkuInfoDto) => AeItemSkuInfoDtos.fromJson(aeItemSkuInfoDto))
        .toList();

    final aeSkuPropertyDtosJson = json['ae_sku_property_dtos'] as List?;
    final aeSkuPropertyDtos = aeSkuPropertyDtosJson
        ?.map((aeSkuPropertyDto) => AeSkuPropertyDtos.fromJson(aeSkuPropertyDto))
        .toList();

    return ProductInfo(
      aeMultimediaInfoDto: MultimediaInfoDto.fromJson(json['ae_multimedia_info_dto']),
      packageInfoDto: PackageInfoDto.fromJson(json['package_info_dto']),
      aeStoreInfo: AeStoreInfo.fromJson(json['ae_store_info']),
      productIdConverterResult:
          ProductIdConverterResult.fromJson(json['product_id_converter_result']),
      logisticsInfoDto: LogisticsInfoDto.fromJson(json['logistics_info_dto']),
      aeItemBaseInfoDto: AeItemBaseInfoDto.fromJson(json['ae_item_base_info_dto']),
      aeItemProperties: aeItemProperties,
      aeItemSkuInfoDtos: aeItemSkuInfoDtos,
      aeSkuPropertyDtos: aeSkuPropertyDtos,
    );
  }
}

class AeSkuPropertyDtos {
  final String? skuPropertyValue;
  final int? propertyValueId;
  final String? skuPropertyName;
  final int? skuPropertyId;
  final String? propertyValueDefinitionName;
  final String? skuImage;
  final String? barcode;
  final String? skuCode;
  final String? skuId;
  final int? ipmSkuStock;
  final String? offerBulkSalePrice;
  final int? skuAvailableStock;
  final int? skuBulkOrder;

  AeSkuPropertyDtos({
    required this.skuPropertyValue,
    required this.propertyValueId,
    required this.skuPropertyName,
    required this.skuPropertyId,
    required this.propertyValueDefinitionName,
    required this.skuImage,
    required this.barcode,
    required this.skuCode,
    required this.skuId,
    required this.ipmSkuStock,
    required this.offerBulkSalePrice,
    required this.skuAvailableStock,
    required this.skuBulkOrder,
  });

  factory AeSkuPropertyDtos.fromJson(Map<String, dynamic> json) {
    return AeSkuPropertyDtos(
      skuPropertyValue: json['sku_property_value'],
      propertyValueId: json['property_value_id'],
      skuPropertyName: json['sku_property_name'],
      skuPropertyId: json['sku_property_id'],
      propertyValueDefinitionName: json['property_value_definition_name'],
      skuImage: json['sku_image'],
      barcode: json['barcode'],
      skuCode: json['sku_code'],
      skuId: json['sku_id'],
      ipmSkuStock: json['ipm_sku_stock'],
      offerBulkSalePrice: json['offer_bulk_sale_price'],
      skuAvailableStock: json['sku_available_stock'],
      skuBulkOrder: json['sku_bulk_order'],
    );
  }
}

class AeItemSkuInfoDtos {
  final bool? skuStock;
  final String? skuPrice;
  final String? offerSalePrice;
  final String? id;

  AeItemSkuInfoDtos({
    required this.skuStock,
    required this.skuPrice,
    required this.offerSalePrice,
    required this.id,
  });

  factory AeItemSkuInfoDtos.fromJson(Map<String, dynamic> json) {
    return AeItemSkuInfoDtos(
      skuStock: json['sku_stock'],
      skuPrice: json['sku_price'],
      offerSalePrice: json['offer_sale_price'],
      id: json['id'],
    );
  }
}

class AeItemProperties {
  final String? attrValueStart;
  final int? attrValueId;
  final String? attrValueEnd;
  final String? attrValue;
  final String? attrValueUnit;
  final String? attrName;
  final int? attrNameId;

  AeItemProperties({
    required this.attrValueStart,
    required this.attrValueId,
    required this.attrValueEnd,
    required this.attrValue,
    required this.attrValueUnit,
    required this.attrName,
    required this.attrNameId,
  });

  factory AeItemProperties.fromJson(Map<String, dynamic> json) {
    return AeItemProperties(
      attrValueStart: json['attr_value_start'],
      attrValueId: json['attr_value_id'],
      attrValueEnd: json['attr_value_end'],
      attrValue: json['attr_value'],
      attrValueUnit: json['attr_value_unit'],
      attrName: json['attr_name'],
      attrNameId: json['attr_name_id'],
    );
  }
}

class AeItemBaseInfoDto {
  final String? gmtModified;
  final int? productId;
  final String? subject;
  final String? productStatusType;
  final String? gmtCreate;
  final String? mobileDetail;
  final String? avgEvaluationRating;
  final String? wsDisplay;
  final String? evaluationCount;
  final String? wsOfflineDate;
  final int? ownerMemberSeqLong;
  final String? detail;
  final String? currencyCode;
  final int? categoryId;
  final String? salesCount;

  AeItemBaseInfoDto({
    required this.gmtModified,
    required this.productId,
    required this.subject,
    required this.productStatusType,
    required this.gmtCreate,
    required this.mobileDetail,
    required this.avgEvaluationRating,
    required this.wsDisplay,
    required this.evaluationCount,
    required this.wsOfflineDate,
    required this.ownerMemberSeqLong,
    required this.detail,
    required this.currencyCode,
    required this.categoryId,
    required this.salesCount,
  });

  factory AeItemBaseInfoDto.fromJson(Map<String, dynamic> json) {
    return AeItemBaseInfoDto(
      gmtModified: json['gmt_modified'],
      productId: json['product_id'],
      subject: json['subject'],
      productStatusType: json['product_status_type'],
      gmtCreate: json['gmt_create'],
      mobileDetail: json['mobile_detail'],
      avgEvaluationRating: json['avg_evaluation_rating'],
      wsDisplay: json['ws_display'],
      evaluationCount: json['evaluation_count'],
      wsOfflineDate: json['ws_offline_date'],
      ownerMemberSeqLong: json['owner_member_seq_long'],
      detail: json['detail'],
      currencyCode: json['currency_code'],
      categoryId: json['category_id'],
      salesCount: json['sales_count'],
    );
  }
}

class LogisticsInfoDto {
  final String? shipToCountry;
  final int? deliveryTime;

  LogisticsInfoDto({
    required this.shipToCountry,
    required this.deliveryTime,
  });

  factory LogisticsInfoDto.fromJson(Map<String, dynamic> json) {
    return LogisticsInfoDto(
      shipToCountry: json['ship_to_country'],
      deliveryTime: json['delivery_time'],
    );
  }
}

class ProductIdConverterResult {
  final int? mainProductId;
  final String? subProductId;

  ProductIdConverterResult({
    required this.mainProductId,
    required this.subProductId,
  });

  factory ProductIdConverterResult.fromJson(Map<String, dynamic> json) {
    return ProductIdConverterResult(
      mainProductId: json['main_product_id'],
      subProductId: json['sub_product_id'],
    );
  }
}

class AeStoreInfo {
  final String? itemAsDescribedRating;
  final String? communicationRating;
  final String? shippingSpeedRating;
  final String? storeName;
  final int? storeId;
  final String? storeCountryCode;

  AeStoreInfo({
    required this.itemAsDescribedRating,
    required this.communicationRating,
    required this.shippingSpeedRating,
    required this.storeName,
    required this.storeId,
    required this.storeCountryCode,
  });

  factory AeStoreInfo.fromJson(Map<String, dynamic> json) {
    return AeStoreInfo(
      itemAsDescribedRating: json['item_as_described_rating'],
      communicationRating: json['communication_rating'],
      shippingSpeedRating: json['shipping_speed_rating'],
      storeName: json['store_name'],
      storeId: json['store_id'],
      storeCountryCode: json['store_country_code'],
    );
  }
}

class PackageInfoDto {
  final int? baseUnit;
  final int? packageHeight;
  final String? grossWeight;
  final int? packageLength;
  final int? packageWidth;
  final int? productUnit;
  final bool? packageType;

  PackageInfoDto({
    required this.baseUnit,
    required this.packageHeight,
    required this.grossWeight,
    required this.packageLength,
    required this.packageWidth,
    required this.productUnit,
    required this.packageType,
  });

  factory PackageInfoDto.fromJson(Map<String, dynamic> json) {
    return PackageInfoDto(
      baseUnit: json['base_unit'],
      packageHeight: json['package_height'],
      grossWeight: json['gross_weight'],
      packageLength: json['package_length'],
      packageWidth: json['package_width'],
      productUnit: json['product_unit'],
      packageType: json['package_type'],
    );
  }
}

class MultimediaInfoDto {
  final List<VideoDto>? aeVideoDtos;
  final String? imageUrls;

  MultimediaInfoDto({
    required this.aeVideoDtos,
    required this.imageUrls,
  });

  factory MultimediaInfoDto.fromJson(Map<String, dynamic> json) {
    final aeVideoDtosJson = json['ae_video_dtos']?['ae_video_d_t_o'] as List?;
    final aeVideoDtos =
        aeVideoDtosJson?.map((aeVideoDto) => VideoDto.fromJson(aeVideoDto)).toList();
    return MultimediaInfoDto(
      aeVideoDtos: aeVideoDtos,
      imageUrls: json['image_urls'],
    );
  }
}

class VideoDto {
  final String? posterUrl;
  final String? mediaStatus;
  final int? aliMemberId;
  final String? mediaType;
  final int? mediaId;

  VideoDto({
    required this.posterUrl,
    required this.mediaStatus,
    required this.aliMemberId,
    required this.mediaType,
    required this.mediaId,
  });

  factory VideoDto.fromJson(Map<String, dynamic> json) {
    return VideoDto(
      posterUrl: json['poster_url'],
      mediaStatus: json['media_status'],
      aliMemberId: json['ali_member_id'],
      mediaType: json['media_type'],
      mediaId: json['media_id'],
    );
  }
}
