import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/mini_apps/swap_it_app/repository/user_swap_items_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class UserSwapItemsBloc extends Bloc<UserSwapItemsEvent, UserSwapItemsState> {
  final _userSwapItemsRepository = UserSwapItemsRepository();

  bool isSubmitting = false;

  late Future<AggregateQuerySnapshot> _userItemsCount;

  UserSwapItemsBloc() : super(UserSwapItemsInitialState()) {
    on<LoadUserSwapItemsEvent>((event, emit) {
      emit(LoadingUserSwapItemsState());

      _userItemsCount =
          SwapItem.ref.where(SILabels.uid.name, isEqualTo: event.userID).count().get();

      final Stream<QuerySnapshot<Map<String, dynamic>>> matchedList = BehaviorSubject()
        ..addStream(_userSwapItemsRepository.getMatchedList(userID: event.userID));

      final Stream<QuerySnapshot<SwapItem>> userItems = BehaviorSubject()
        ..addStream(_userSwapItemsRepository.getUserItems(userId: event.userID));

      final Stream<QuerySnapshot<Appreciation>> chosenList = BehaviorSubject()
        ..addStream(_userSwapItemsRepository.getChosenList(userID: event.userID));

      final Stream<QuerySnapshot<Appreciation>> interestedUsers = BehaviorSubject()
        ..addStream(_userSwapItemsRepository.getInterestedUsers(userID: event.userID));

      emit(UserSwapItemsLoadedState(
        matchedList: matchedList,
        userSwapItems: userItems,
        chosenList: chosenList,
        interestedUsers: interestedUsers,
      ));
    });

    on<SetInitUserSwapItemsEvent>((event, emit) {
      emit(UserSwapItemsInitialState());
    });
  }

  Future<bool> checkHasSwapItems() async {
    try {
      final count = await _userItemsCount;
      if (count.count == 0) {
        return false;
      } else {
        return true;
      }
    } on Exception {
      return true;
    }
  }
}
