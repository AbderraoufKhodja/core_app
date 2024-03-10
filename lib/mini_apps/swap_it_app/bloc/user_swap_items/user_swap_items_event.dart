import 'package:equatable/equatable.dart';

abstract class UserSwapItemsEvent extends Equatable {
  const UserSwapItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadUserSwapItemsEvent extends UserSwapItemsEvent {
  final String userID;

  const LoadUserSwapItemsEvent({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}

class SetInitUserSwapItemsEvent extends UserSwapItemsEvent {}
