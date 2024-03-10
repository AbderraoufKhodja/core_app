import 'package:ae_api/affiliate_api.dart';
import 'package:ae_api/ds_api.dart';

export 'package:ae_api/ae_categories.dart';
export 'package:ae_api/src/models/featured_promo_products_request_params.dart';
export 'package:ae_api/src/models/featured_promo_products_response.dart'
    hide RespResult, $RespResultCopyWith, Result, $ResultCopyWith;
export 'package:ae_api/src/models/featured_promo_response.dart'
    hide RespResult, $RespResultCopyWith, Result, $ResultCopyWith;
export 'package:ae_api/src/models/hot_product_request_params.dart';
export 'package:ae_api/src/models/hot_products_response.dart'
    hide RespResult, $RespResultCopyWith, Result, $ResultCopyWith;
export 'package:ae_api/src/models/product.dart';
export 'package:ae_api/src/utils/feed_name.dart';

class AliExpress {
  static final affiliateAPI = AffiliateAPI();
  static final dsAPI = DsAPI();
}
