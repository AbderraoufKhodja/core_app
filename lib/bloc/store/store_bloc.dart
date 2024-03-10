import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/store.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    on<StoreEvent>((event, emit) {
      if (event is LoadStore) {
        emit(StoreLoading());
        final store = Store.ref.doc(event.storeID).get();
        emit(StoreLoaded(store: store));
      }
    });
  }
}
