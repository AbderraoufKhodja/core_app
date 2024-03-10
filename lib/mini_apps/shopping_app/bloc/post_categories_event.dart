part of 'post_categories_bloc.dart';

abstract class PostCategoriesEvent extends Equatable {
  final String category;
  const PostCategoriesEvent(this.category);

  @override
  List<Object> get props => [category];
}

class AddCategoryEvent extends PostCategoriesEvent {
  const AddCategoryEvent(super.category);
}

class RemoveCategoryEvent extends PostCategoriesEvent {
  const RemoveCategoryEvent(super.category);
}
