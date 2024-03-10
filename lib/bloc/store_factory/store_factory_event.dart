import 'package:equatable/equatable.dart';

abstract class StoreFactoryEvent extends Equatable {
  const StoreFactoryEvent();

  @override
  List<Object> get props => [];
}

class LoadUserStores extends StoreFactoryEvent {
  final String userID;

  const LoadUserStores({required this.userID});

  @override
  List<Object> get props => [userID];
}
