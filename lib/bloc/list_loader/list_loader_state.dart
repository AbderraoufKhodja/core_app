part of 'list_loader_bloc.dart';

abstract class ListLoaderState extends Equatable {
  const ListLoaderState();
  
  @override
  List<Object> get props => [];
}

class ListLoaderInitial extends ListLoaderState {}
