class AeCategory {
  final String parentCategoryId;
  final String categoryName;
  final String categoryId;

  AeCategory(
      {required this.parentCategoryId, required this.categoryName, required this.categoryId});

  factory AeCategory.fromJson(Map<String, dynamic> json) {
    return AeCategory(
      parentCategoryId: json['parent_category_id'],
      categoryName: json['category_name'],
      categoryId: json['category_id'],
    );
  }
}
