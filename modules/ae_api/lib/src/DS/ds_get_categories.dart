part of ds_api;

extension DsGetCategoriesExtension on DsAPI {
// Define a function to get the category data
  Future<ApiResponse> getCategory() async {
    // Construct the full URL with the query parameters
    final url =
        '${_baseUrl}aliexpress.ds.category.get?app_key=$_appKey&timestamp=${DateTime.now().millisecondsSinceEpoch.toString()}&sign_method=$_signMethod&';

    http.Response? response = await http.get(Uri.parse(url));

    // Check if the response is successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load category');
    }
  }
}

class ApiResponse {
  final String code;
  final RespResult respResult;
  final String requestId;

  ApiResponse({required this.code, required this.respResult, required this.requestId});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      respResult: RespResult.fromJson(json['resp_result']),
      requestId: json['request_id'],
    );
  }
}

class RespResult {
  final CategoriesResult result;
  final String respCode;
  final String respMsg;

  RespResult({required this.result, required this.respCode, required this.respMsg});

  factory RespResult.fromJson(Map<String, dynamic> json) {
    return RespResult(
      result: CategoriesResult.fromJson(json['result']),
      respCode: json['resp_code'],
      respMsg: json['resp_msg'],
    );
  }
}

class CategoriesResult {
  final String totalResultCount;
  final List<Category> categories;

  CategoriesResult({required this.totalResultCount, required this.categories});

  factory CategoriesResult.fromJson(Map<String, dynamic> json) {
    return CategoriesResult(
      totalResultCount: json['total_result_count'],
      categories: (json['categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
    );
  }
}

class Category {
  final String parentCategoryId;
  final String categoryName;
  final String categoryId;

  Category({required this.parentCategoryId, required this.categoryName, required this.categoryId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      parentCategoryId: json['parent_category_id'],
      categoryName: json['category_name'],
      categoryId: json['category_id'],
    );
  }
}
