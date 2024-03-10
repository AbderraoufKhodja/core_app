import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/shopping_review.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  ReviewsBloc() : super(ReviewsInitial()) {
    on<ReviewsEvent>((event, emit) {
      if (event is LoadReviews) {
        emit(ReviewsLoading());

        final reviews =
            ShoppingReview.ref.where(SRLabels.itemID.name, isEqualTo: event.itemID).get();

        emit(ReviewsLoaded(reviews: reviews));
      }
    });
  }
}
