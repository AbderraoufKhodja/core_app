import 'package:bloc/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/repository/interested_user_swap_items_repository.dart';
import 'bloc.dart';

class InterestedUserSwapItemsBloc
    extends Bloc<InterestedUserSwapItemsEvent, InterestedUserSwapItemsState> {
  final interestedUsersItemsRepository = InterestedUserSwapItemsRepository();

  InterestedUserSwapItemsBloc() : super(InterestedUserSwapItemsInitialState()) {
    on<LoadInterestedUserSwapItemsEvent>((event, emit) {
      emit(LoadingInterestedUsersItemsState());

      final interestedUsersItems =
          interestedUsersItemsRepository.getInterestedUsersItems(userID: event.userID);

      emit(InterestedUserSwapItemsLoadedState(otherUserSwapItems: interestedUsersItems));
    });
    on<PassItemEvent>((event, emit) {
      interestedUsersItemsRepository.passItem(
        currentUserID: event.currentUserId,
        otherItemID: event.otherItemId,
        otherUserID: event.otherUserId,
      );
    });
    on<AcceptItemEvent>((event, emit) {
      interestedUsersItemsRepository.acceptItem(
        currentUserID: event.currentUserId,
        otherItemID: event.otherItemId,
        otherUserID: event.otherUserId,
      );
    });
  }
}
