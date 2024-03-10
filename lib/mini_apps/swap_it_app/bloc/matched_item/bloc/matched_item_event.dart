part of 'matched_item_bloc.dart';

abstract class MatchedItemsEvent extends Equatable {
  const MatchedItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchedItemsEvent extends MatchedItemsEvent {
  final String userID;

  const LoadMatchedItemsEvent({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}
