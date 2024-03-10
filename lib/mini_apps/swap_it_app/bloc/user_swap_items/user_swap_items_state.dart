import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';

abstract class UserSwapItemsState extends Equatable {
  const UserSwapItemsState();

  @override
  List<Object> get props => [];
}

class UserSwapItemsInitialState extends UserSwapItemsState {}

class LoadingUserSwapItemsState extends UserSwapItemsState {}

class UserSwapItemsLoadedState extends UserSwapItemsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> matchedList;
  final Stream<QuerySnapshot<SwapItem>> userSwapItems;
  final Stream<QuerySnapshot<Appreciation>> chosenList;
  final Stream<QuerySnapshot<Appreciation>> interestedUsers;

  const UserSwapItemsLoadedState({
    required this.matchedList,
    required this.userSwapItems,
    required this.chosenList,
    required this.interestedUsers,
  });

  @override
  List<Object> get props => [
        matchedList,
        userSwapItems,
        chosenList,
        interestedUsers,
      ];
}
