import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import './bloc.dart';

class NearbyCubit extends Cubit<NearbyState> {
  final _analytics = FirebaseAnalytics.instance;
  final textController = TextEditingController();

  late Query<Post> searchRef;
  late Query<Post> itemsRef;

  NearbyCubit() : super(NearbyInitial());

  String? sortedBy;

  bool isDescending = true;
  bool showRail = false;

  String? selectedCategory;
  String? selectedRegion;
  String? selectedCountry;

  int? selectedIndex;

  AnimationController? controller;

  final categories = [
    'fashion',
    'beauty',
    'travel',
    'food',
    'family',
    'health',
    'fitness',
    'music',
    'movies',
    'specialEvents',
    'hobbies',
    'technology',
    'homeDecor',
    'dIY',
    'gardening',
    'finance',
    'studentLife',
    'pets',
    'currentNews',
    'science',
  ];

  void initNearbyCubit({required GeoFirePoint center, required double radius}) async {
    emit(NearbyLoading());
    itemsRef = GeoFlutterFire()
        .collection(collectionRef: FirebaseFirestore.instance.collection(postsCollection))
        .precisionFiveBlockSixtyThree(center: center, radius: radius, field: 'location')
        .withConverter<Post>(
          fromFirestore: (snapshot, options) => Post.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where(PoLabels.privacy.name, isEqualTo: PostPrivacyType.public.name)
        .where(PoLabels.isActive.name, isEqualTo: true);

    searchRef = GeoFlutterFire()
        .collection(collectionRef: FirebaseFirestore.instance.collection(postsCollection))
        .precisionFiveBlockSixtyThree(center: center, radius: radius, field: 'location')
        .withConverter<Post>(
          fromFirestore: (snapshot, options) => Post.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where(PoLabels.privacy.name, isEqualTo: PostPrivacyType.public.name)
        .where(PoLabels.isActive.name, isEqualTo: true)
        .orderBy(PoLabels.timestamp.name, descending: true);
    await Future.delayed(const Duration(seconds: 1));
    emit(NearbyRefUpdated());
  }

  void refreshSearchRef() {
    emit(NearbyLoading());
    searchRef = itemsRef;

    if (selectedCategory?.isNotEmpty == true) {
      searchRef = searchRef.where(PoLabels.category.name, isEqualTo: selectedCategory);
    }

    if (selectedRegion?.isNotEmpty == true) {
      searchRef = searchRef.where(PoLabels.province.name, isEqualTo: selectedRegion);
    }

    if (selectedCountry?.isNotEmpty == true) {
      searchRef = searchRef.where(PoLabels.country.name, isEqualTo: selectedCountry);
    }

    if (textController.text.isNotEmpty) {
      searchRef = searchRef.where(PoLabels.tags.name,
          arrayContains: textController.text.split(' ').toList());
    }

    if (sortedBy?.isNotEmpty == true) {
      _analytics.logSearch(searchTerm: textController.text);
      searchRef = searchRef.orderBy(sortedBy!, descending: isDescending);
    } else {
      searchRef = searchRef.orderBy(PoLabels.timestamp.name, descending: isDescending);
    }

    emit(NearbyRefUpdated());
  }

  void resetFilters() {
    selectedCategory = null;
    selectedRegion = null;
    sortedBy = null;
    isDescending = true;
  }

  void updateCategoriesWidget() {
    emit(NearbyLoading());
    emit(NearbyCategoryUpdated());
  }

  void updateRefWidget() {
    emit(NearbyLoading());
    emit(NearbyRefUpdated());
  }
}
