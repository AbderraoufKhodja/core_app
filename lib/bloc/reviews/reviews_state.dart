part of 'reviews_bloc.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object> get props => [];
}

class ReviewsInitial extends ReviewsState {
  @override
  List<Object> get props => [];
}

class ReviewsLoading extends ReviewsState {
  @override
  List<Object> get props => [];
}

class ReviewsLoaded extends ReviewsState {
  final Future<QuerySnapshot<ShoppingReview>> reviews;
  const ReviewsLoaded({required this.reviews});

  @override
  List<Object> get props => [reviews];
}
