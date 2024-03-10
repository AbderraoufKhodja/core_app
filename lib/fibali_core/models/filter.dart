import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filter {
  String? category1;
  String? category2;
  String? category3;
  String? category4;
  String? category5;
  String? category6;
  String? province;
  String? subProvince;
  List<dynamic>? keywords;

  Filter({
    required this.category1,
    required this.category2,
    required this.category3,
    required this.category4,
    required this.category5,
    required this.category6,
    required this.province,
    required this.subProvince,
    required this.keywords,
  });

  factory Filter.fromFirestore(Map<String, dynamic> doc) {
    return Filter(
      keywords: getField(doc, 'keywords', List),
      category1: getField(doc, 'category1', String),
      category2: getField(doc, 'category2', String),
      category3: getField(doc, 'category3', String),
      category4: getField(doc, 'category4', String),
      category5: getField(doc, 'category5', String),
      category6: getField(doc, 'category6', String),
      province: getField(doc, 'province', String),
      subProvince: getField(doc, 'subProvince', String),
    );
  }

  factory Filter.empty() {
    return Filter(
      keywords: null,
      category1: null,
      category2: null,
      category3: null,
      category4: null,
      category5: null,
      category6: null,
      province: null,
      subProvince: null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "category1": category1,
      "category2": category2,
      "category3": category3,
      "category4": category4,
      "category5": category5,
      "category6": category6,
      "province": province,
      "subProvince": subProvince,
      "keywords": keywords,
    };
  }

  factory Filter.fromPreferences({required SharedPreferences prefs}) {
    return Filter(
      category1: prefs.getString("category1"),
      category2: prefs.getString("category2"),
      category3: prefs.getString("category3"),
      category4: prefs.getString("category4"),
      category5: prefs.getString("category5"),
      category6: prefs.getString("category6"),
      province: null,
      subProvince: null,
      keywords: prefs.getStringList("keywords"),
    );
  }
}
