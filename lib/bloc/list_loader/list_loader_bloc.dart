import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_loader_event.dart';
part 'list_loader_state.dart';

class ListLoaderBloc extends Bloc<ListLoaderEvent, ListLoaderState> {
  ListLoaderBloc() : super(ListLoaderInitial()) {
    on<ListLoaderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
