library affiliate_api;

import 'dart:convert';

import 'package:ae_api/ae_api.dart';
import 'package:ae_api/src/models/ae_category.dart';
import 'package:ae_api/src/models/ali_express_response.dart';
import 'package:ae_api/src/models/category_response.dart';
import 'package:ae_api/src/models/order.dart';
import 'package:ae_api/src/models/request_params.dart';
import 'package:ae_api/src/models/resp_result.dart';
import 'package:ae_api/src/models/smart_match_products_response.dart';
import 'package:ae_api/src/utils/utils.dart';
import 'package:http/http.dart' as http;

part 'src/affiliate/generate_link.dart';
part 'src/affiliate/get_category.dart';
part 'src/affiliate/get_featured_promo_products.dart';
part 'src/affiliate/get_featured_promos_info.dart';
part 'src/affiliate/get_hot_product.dart';
part 'src/affiliate/get_hot_product_download.dart';
part 'src/affiliate/get_order_info.dart';
part 'src/affiliate/get_order_list.dart';
part 'src/affiliate/get_order_list_by_index.dart';
part 'src/affiliate/get_product_detail_info.dart';
part 'src/affiliate/get_products.dart';
part 'src/affiliate/smart_match_products.dart';

class AffiliateAPI {
  // Define the base URL and the parameters
  final _baseUrl = 'https://api-sg.aliexpress.com/sync';
  final _appKey = '_appKey';
  final _appSecret = '_appSecret';
  final _signMethod = 'sha256';
}
