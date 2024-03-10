import 'package:fibali/fibali_core/models/app_user.dart';

class Language {
  static const POST = 'postItem';

  String? name;
  String? isoCode;

  Language({
    required this.name,
    required this.isoCode,
  });

  factory Language.fromFirestore(Map<String, dynamic> doc) {
    return Language(
      name: getField(doc, 'name', String),
      isoCode: getField(doc, 'isoCode', String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'isoCode': isoCode,
    };
  }

  bool isValid() {
    if (name != null && isoCode != null) return true;
    return false;
  }
}
