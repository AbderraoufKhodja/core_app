import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_loader_state.dart';

class ListLoaderCubit extends Cubit<ListLoaderState> {
  ListLoaderCubit() : super(ListLoaderInitial());
}
