import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/mini_apps/swap_it_app/repository/swap_item_repository.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';

part 'matched_item_event.dart';
part 'matched_item_state.dart';

class MatchedItemBloc extends Bloc<MatchedItemsEvent, MatchedItemsState> {
  final _swapItemRepository = SwapItemRepository();

  MatchedItemBloc() : super(MatchedItemsInitialState()) {
    on<LoadMatchedItemsEvent>((event, emit) {
      emit(MatchedItemsLoadingState());

      Stream<QuerySnapshot<SwapItem>> item =
          _swapItemRepository.getMatchedItems(userID: event.userID);

      emit(MatchedItemsLoadedState(items: item));
    });
  }

  void addViewMatch({required String matchID, required String userID}) {
    _swapItemRepository.addViewMatch(matchID: matchID, userID: userID);
  }
}
