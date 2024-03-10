part of 'reviews_bloc.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object> get props => [];
}

class LoadReviews extends ReviewsEvent {
  final String itemID;

  const LoadReviews({required this.itemID});

  @override
  List<Object> get props => [itemID];
}
