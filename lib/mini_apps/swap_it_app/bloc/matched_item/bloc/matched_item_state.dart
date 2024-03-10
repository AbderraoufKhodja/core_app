part of 'matched_item_bloc.dart';

abstract class MatchedItemsState extends Equatable {
  const MatchedItemsState();

  @override
  List<Object> get props => [];
}

class MatchedItemsInitialState extends MatchedItemsState {}

class MatchedItemsLoadingState extends MatchedItemsState {}

class MatchedItemsLoadedState extends MatchedItemsState {
  final Stream<QuerySnapshot<SwapItem>> items;

  const MatchedItemsLoadedState({required this.items});

  @override
  List<Object> get props => [
        items,
      ];
}
