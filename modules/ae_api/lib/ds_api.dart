library ds_api;

import 'dart:convert';
import 'dart:typed_data';

import 'package:ae_api/src/models/ds_get_recommend.dart';
import 'package:ae_api/src/models/freight_calculate_params.dart';
import 'package:ae_api/src/models/freight_calculate_response.dart';
import 'package:ae_api/src/models/product.dart';
import 'package:ae_api/src/utils/utils.dart';
import 'package:http/http.dart' as http;

export 'package:ae_api/src/models/ds_get_recommend.dart';
export 'package:ae_api/src/models/freight_calculate_params.dart';
export 'package:ae_api/src/models/freight_calculate_response.dart';

part 'src/DS/calculate_freight.dart';
part 'src/DS/ds_get_categories.dart';
part 'src/DS/freight_calculate.dart';
part 'src/DS/get_recommend_feed.dart';
part 'src/DS/image_search.dart';
part 'src/DS/product_info_query.dart';

class DsAPI {
  // Define the base URL and the parameters
  final _baseUrl = 'https://api-sg.aliexpress.com/sync';
  final _appKey = '504344';
  final _appSecret = '_appSecret';
  final _signMethod = '_signMethod';
}
