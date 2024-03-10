import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

const mainCategories = {
  "en": [
    "food & beverages",
    "toys & games",
    "home improvement",
    "sporting goods",
    "pet supplies",
    "patio & garden",
    "office supplies",
    "musical instruments",
    "media",
    "travel & luggage",
    "arts & crafts",
    "auto parts & accessories",
    "antiques & collectibles",
    "baby products",
    "electronics",
    "health & beauty",
    "jewelry & watches",
    "home",
    "clothing & accessories",
    "other"
  ],
  "fr": [
    "alimentation et boissons",
    "jeux et jouets",
    "bricolage",
    "articles de sport",
    "fournitures pour animaux",
    "patio et jardin",
    "fournitures de bureau",
    "instruments de musique",
    "médias",
    "voyage et bagages",
    "art et artisanat",
    "pièces et accessoires d'automobiles",
    "antiquités et objets de collection",
    "produits pour bébés",
    "appareils électroniques",
    "santé et beauté",
    "bijoux et montres",
    "domicile",
    "vêtements et accessoires",
    "autre"
  ],
  "ar": [
    "أطعمة ومشروبات",
    "ألعاب",
    "تجديد منازل",
    "مستلزمات رياضية",
    "مستلزمات حيوانات أليفة",
    "فناء وحدائق",
    "مستلزمات مكتبية",
    "آلات موسيقية",
    "وسائط",
    "سفر وأمتعة",
    "فنون وحرف يدوية",
    "قطع غيار وإكسسوارات سيارات",
    "تحف ومقتنيات",
    "منتجات للأطفال",
    "أجهزة إلكترونية",
    "صحة وجمال",
    "مجوهرات وساعات يد",
    "منازل",
    "ملابس وإكسسوارات",
    "غير ذلك",
  ]
};

getLocalCategories() {
  final local = BlocProvider.of<SettingsCubit>(Get.context!).state.appLanguage;
  if (mainCategories.containsKey(local)) {
    return mainCategories[local];
  }

  return mainCategories['en'];
}
