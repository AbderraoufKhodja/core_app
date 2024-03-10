import 'package:bloc/bloc.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

import './bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  final _analytics = FirebaseAnalytics.instance;

  List<String>? selectedSubCategories;
  List<String>? selectedRegions;
  String? sortedBy;
  bool isDecending = true;
  bool teamChoice = false;
  final textController = TextEditingController();

  SearchCubit() : super(SearchInitial());

  void loadItems() {
    if (sortedBy != null) {
      _analytics.logSearch(searchTerm: textController.text);
      final items = Item.ref
          .where(ItemLabels.category1.name,
              isEqualTo:
                  selectedSubCategories?.isNotEmpty == true ? selectedSubCategories![0] : null)
          .where(ItemLabels.province.name,
              isEqualTo: selectedRegions?.isNotEmpty == true ? selectedRegions![0] : null)
          .where(ItemLabels.keywords.name,
              arrayContainsAny: textController.text.split(' ').toList())
          .where(ItemLabels.isActive.name, isEqualTo: true)
          .where(ItemLabels.teamChoice.name, isEqualTo: teamChoice)
          .orderBy(sortedBy!, descending: isDecending)
          .get();
      emit(SearchLoaded(items: items));
    } else {
      _analytics.logSearch(searchTerm: textController.text);
      final items = Item.ref
          .where(ItemLabels.category1.name,
              isEqualTo:
                  selectedSubCategories?.isNotEmpty == true ? selectedSubCategories![0] : null)
          .where(ItemLabels.province.name,
              isEqualTo: selectedRegions?.isNotEmpty == true ? selectedRegions![0] : null)
          .where(ItemLabels.keywords.name,
              arrayContainsAny: textController.text.split(' ').toList())
          .where(ItemLabels.teamChoice.name, isEqualTo: teamChoice)
          .where(ItemLabels.isActive.name, isEqualTo: true)
          .get();
      emit(SearchLoaded(items: items));
    }
  }

  void restetFilters() {
    selectedSubCategories = null;
    selectedRegions = null;
    sortedBy = null;
    isDecending = true;
    teamChoice = false;
  }
}
