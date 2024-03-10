import 'package:equatable/equatable.dart';

abstract class InterestedUserSwapItemsEvent extends Equatable {
  const InterestedUserSwapItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadInterestedUserSwapItemsEvent extends InterestedUserSwapItemsEvent {
  final String userID;

  const LoadInterestedUserSwapItemsEvent({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}

class AcceptItemEvent extends InterestedUserSwapItemsEvent {
  final String currentUserId;
  final String otherUserId;
  final String otherItemId;

  const AcceptItemEvent({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherItemId,
  });

  @override
  List<Object> get props => [
        currentUserId,
        otherUserId,
        otherItemId,
      ];
}

class PassItemEvent extends InterestedUserSwapItemsEvent {
  final String currentUserId, otherItemId, otherUserId;

  const PassItemEvent({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherItemId,
  });

  @override
  List<Object> get props => [
        currentUserId,
        otherUserId,
        otherItemId,
      ];
}
