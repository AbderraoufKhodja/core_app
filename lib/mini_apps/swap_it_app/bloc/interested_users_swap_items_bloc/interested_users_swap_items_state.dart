import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class InterestedUserSwapItemsState extends Equatable {
  const InterestedUserSwapItemsState();

  @override
  List<Object> get props => [];
}

class InterestedUserSwapItemsInitialState extends InterestedUserSwapItemsState {}

class LoadingInterestedUsersItemsState extends InterestedUserSwapItemsState {}

class InterestedUserSwapItemsLoadedState extends InterestedUserSwapItemsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> otherUserSwapItems;

  const InterestedUserSwapItemsLoadedState({
    required this.otherUserSwapItems,
  });

  @override
  List<Object> get props => [
        otherUserSwapItems,
      ];
}
