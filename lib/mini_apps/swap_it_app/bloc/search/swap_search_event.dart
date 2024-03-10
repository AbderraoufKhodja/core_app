import 'package:equatable/equatable.dart';
import 'package:fibali/mini_apps/swap_it_app/repository/swap_search_repository.dart';

abstract class SwapSearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSwapItemEvent extends SwapSearchEvent {
  final List<SwapItemRecord> itemBatch;

  LoadSwapItemEvent({
    required this.itemBatch,
  });

  @override
  List<Object?> get props => [
        itemBatch,
      ];
}

class LikeSwapItemEvent extends SwapSearchEvent {
  final String currentUserId;
  final String selectedItemId;
  final String selectedUserId;

  LikeSwapItemEvent({
    required this.currentUserId,
    required this.selectedItemId,
    required this.selectedUserId,
  });

  @override
  List<Object?> get props => [
        currentUserId,
        selectedItemId,
        selectedUserId,
      ];
}

class SkipSwapItemEvent extends SwapSearchEvent {
  final String currentUserId, selectedItemId, selectedUserId;

  SkipSwapItemEvent({
    required this.currentUserId,
    required this.selectedItemId,
    required this.selectedUserId,
  });

  @override
  List<Object> get props => [
        currentUserId,
        selectedItemId,
        selectedUserId,
      ];
}

class NoSwapItemsEvent extends SwapSearchEvent {}
