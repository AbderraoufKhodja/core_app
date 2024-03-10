import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import './bloc.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final itemsRef = Post.ref
      .where(PoLabels.privacy.name, isEqualTo: PostPrivacyType.public.name)
      .where(PoLabels.isActive.name, isEqualTo: true);

  final textController = TextEditingController();

  Query<Post> searchRef = Post.ref
      .where(PoLabels.privacy.name, isEqualTo: PostPrivacyType.public.name)
      .where(PoLabels.isActive.name, isEqualTo: true)
      .orderBy(PoLabels.timestamp.name, descending: true);

  String? sortedBy;
  String? countryCode;

  bool isDescending = true;
  bool showRail = false;

  String? selectedCategory;

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

  DiscoverCubit() : super(DiscoverInitial());

  void initNearbyCubit({required GeoFirePoint center, required double radius}) async {
    emit(DiscoverLoading());
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
    emit(DiscoverRefUpdated());
  }

  void refreshSearchRef() async {
    emit(DiscoverLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    searchRef = itemsRef;

    if (selectedCategory?.isNotEmpty == true) {
      searchRef = searchRef.where(PoLabels.category.name, isEqualTo: selectedCategory);
    }

    if (countryCode?.isNotEmpty == true) {
      searchRef = searchRef.where(PoLabels.country.name, isEqualTo: countryCode);
    }

    if (textController.text.isNotEmpty) {
      searchRef = searchRef.where(PoLabels.tags.name,
          arrayContains: textController.text.split(' ').toList());
    }

    if (sortedBy?.isNotEmpty == true) {
      FirebaseAnalytics.instance.logSearch(searchTerm: textController.text);
      searchRef = searchRef.orderBy(sortedBy!, descending: isDescending);
    } else {
      searchRef = searchRef.orderBy(PoLabels.timestamp.name, descending: isDescending);
    }

    emit(DiscoverRefUpdated());
  }

  void resetFilters() {
    selectedCategory = null;
    sortedBy = null;
    isDescending = true;
  }

  void updateCategoriesWidget() {
    emit(DiscoverLoading());
    emit(DiscoverCategoryUpdated());
  }
}
