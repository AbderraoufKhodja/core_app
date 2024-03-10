part of affiliate_api;

extension Categories on AffiliateAPI {
  Future<CategoryResponse> getCategories(String accessToken) async {
    var url = Uri.parse('https://api-sg.aliexpress.com/sync');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return CategoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

class CategoriesResult {
  final String totalResultCount;
  final List<AeCategory> categories;

  CategoriesResult({required this.totalResultCount, required this.categories});

  factory CategoriesResult.fromJson(Map<String, dynamic> json) {
    var list = json['categories'] as List;
    List<AeCategory> categoryList = list.map((i) => AeCategory.fromJson(i)).toList();

    return CategoriesResult(
      totalResultCount: json['total_result_count'],
      categories: categoryList,
    );
  }
}
