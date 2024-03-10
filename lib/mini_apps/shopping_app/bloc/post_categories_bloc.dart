import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_categories_event.dart';
part 'post_categories_state.dart';

class PostCategoriesBloc
    extends Bloc<PostCategoriesEvent, PostCategoriesState> {
  final List<String> _listCategories = [
    'Food',
    'Fiction',
    'Drama',
    'Art',
    'Programming',
    'Astrology',
    'Biology',
  ];

  final StreamController<List<String>> _categoriesStreamCtrl =
      StreamController<List<String>>.broadcast();

  final StreamController<PostCategoriesEvent?> _eventsStreamCtrl =
      StreamController<PostCategoriesEvent?>.broadcast();

  Stream<List<String>> get categoriesStream => _categoriesStreamCtrl.stream;

  Sink<PostCategoriesEvent?> get eventsSink => _eventsStreamCtrl.sink;

  PostCategoriesBloc() : super(PostCategoriesInitial()) {
    on<PostCategoriesEvent>((event, emit) {
      if (event is AddCategoryEvent) {
        _listCategories.add(event.category);
      }
      if (event is RemoveCategoryEvent) {
        _listCategories.remove(event.category);
      }
      _categoriesStreamCtrl.add(_listCategories);
    });
  }

  void dispose() {
    _categoriesStreamCtrl.close();
    _eventsStreamCtrl.close();
  }
}
