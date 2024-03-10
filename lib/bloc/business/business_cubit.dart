import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/categories.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/ui/all_categories.dart';

import './bloc.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final _analytics = FirebaseAnalytics.instance;

  final textController = TextEditingController();

  Query<Item> searchRef = Item.ref;

  String? sortedBy;
  String? countryCode;

  bool isDecending = true;
  bool? teamChoice;
  bool showRail = false;
  bool showGlobalRail = false;

  List<String>? selectedCategories1;
  List<String>? selectedCategories2;
  List<String>? selectedRegions;

  List<String> categories1 = mainCategories['en'] as List<String>;
  List<String> categories2 = [];
  List<String> categories3 = [];
  List<String> categories4 = [];
  List<String> categories5 = [];
  List<String> categories6 = [];

  List<String> categoriesLabels1 = getLocalCategories();
  List<String> categoriesLabels2 = [];
  List<String> categoriesLabels3 = [];
  List<String> categoriesLabels4 = [];
  List<String> categoriesLabels5 = [];
  List<String> categoriesLabels6 = [];

  String? category1;
  String? category2;
  String? category3;
  String? category4;
  String? category5;
  String? category6;

  int? selectedIndex;
  int? selectedAeSubCatIndex;

  AnimationController? controller;
  AnimationController? globalTabController;

  int? aeCategoryID;
  int? aeSubCategoryID;

  BusinessCubit() : super(BusinessInitial());

  void refreshAeSearch() {
    // TODO: implement refreshAeSearch
    debugPrint('refreshAeSearch');
    emit(BusinessLoading());
    emit(BusinessCategoryUpdated());
  }

  void refreshSearchRef() {
    emit(BusinessLoading());

    searchRef = Item.ref;
    searchRef = searchRef.where(ItemLabels.isActive.name, isEqualTo: true);

    if (category1?.isNotEmpty == true) {
      searchRef = searchRef.where(ItemLabels.category1.name, isEqualTo: category1!);
    }

    if (category2?.isNotEmpty == true) {
      searchRef = searchRef.where(ItemLabels.category2.name, isEqualTo: category2!);
    }

    if (selectedRegions?.isNotEmpty == true) {
      searchRef = searchRef.where(ItemLabels.province.name, isEqualTo: selectedRegions![0]);
    }

    if (textController.text.isNotEmpty) {
      _analytics.logSearch(searchTerm: textController.text);
      searchRef = searchRef.where(ItemLabels.keywords.name,
          arrayContainsAny: textController.text.split(' ').toList());
    }

    if (sortedBy?.isNotEmpty == true) {
      searchRef = searchRef.orderBy(sortedBy!, descending: isDecending);
    }

    if (teamChoice != null) {
      searchRef = searchRef.where(ItemLabels.teamChoice.name, isEqualTo: teamChoice);
    }
    if (countryCode != null) {
      searchRef = searchRef.where(ItemLabels.country.name, isEqualTo: countryCode);
    }
    emit(BusinessRefUpdated());
  }

  void restetFilters() {
    selectedCategories1 = null;
    selectedRegions = null;
    sortedBy = null;
    isDecending = true;
    teamChoice = false;
  }

  List<String> getSubCategories(String value) {
    return allCategories.values
        .map((categoryMap) => categoryMap.map(
              (key, value) => MapEntry(key, value!.split(' > ')),
            ))
        .where((e1) => e1.values.any((element) => element.contains(value)))
        .map((e2) {
          final idx = e2["en"]!.indexOf(value) + 1;
          if (e2["en"]!.length == idx) {
            return <String>[];
          } else {
            return e2["en"]!.sublist(idx);
          }
        })
        .where((element) => element.isNotEmpty)
        .map((element) => element.first)
        .toSet()
        .toList();
  }

  List<String> getSubLabelsCategories(context, {required String value}) {
    final myLocale = Localizations.localeOf(context);
    if (myLocale.languageCode == 'fr') {
      return allCategories.values
          .map((categoryMap) => categoryMap.map(
                (key, value) => MapEntry(key, value!.split(' > ')),
              ))
          .where((e1) => e1.values.any((element) => element.contains(value)))
          .map((e2) {
            final idx = e2["en"]!.indexOf(value) + 1;
            if (e2["en"]!.length == idx) {
              return <String>[];
            } else {
              return e2["fr"]!.sublist(idx);
            }
          })
          .where((element) => element.isNotEmpty)
          .map((element) => element.first)
          .toSet()
          .toList();
    } else if (myLocale.languageCode == 'ar') {
      return allCategories.values
          .map((categoryMap) => categoryMap.map(
                (key, value) => MapEntry(key, value!.split(' > ')),
              ))
          .where((e1) => e1.values.any((element) => element.contains(value)))
          .map((e2) {
            final idx = e2["en"]!.indexOf(value) + 1;
            if (e2["en"]!.length == idx) {
              return <String>[];
            } else {
              return e2["ar"]!.sublist(idx);
            }
          })
          .where((element) => element.isNotEmpty)
          .map((element) => element.first)
          .toSet()
          .toList();
    }

    // Default (english)
    return allCategories.values
        .map((categoryMap) => categoryMap.map(
              (key, value) => MapEntry(key, value!.split(' > ')),
            ))
        .where((e1) => e1.values.any((element) => element.contains(value)))
        .map((e2) {
          final idx = e2["en"]!.indexOf(value) + 1;
          if (e2["en"]!.length == idx) {
            return <String>[];
          } else {
            return e2["en"]!.sublist(idx);
          }
        })
        .where((element) => element.isNotEmpty)
        .map((element) => element.first)
        .toSet()
        .toList();
  }

  void updateCategoriesWidget() {
    emit(BusinessLoading());
    emit(BusinessCategoryUpdated());
  }
}
