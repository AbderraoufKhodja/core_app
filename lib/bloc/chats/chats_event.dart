import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class LoadChatsEvent extends ChatsEvent {
  final AppUser currentUser;

  const LoadChatsEvent({required this.currentUser});

  @override
  List<Object> get props => [currentUser];
}
