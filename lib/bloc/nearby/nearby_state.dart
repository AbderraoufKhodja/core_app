import 'package:equatable/equatable.dart';

abstract class NearbyState extends Equatable {
  const NearbyState();
  @override
  List<Object> get props => [];
}

class NearbyInitial extends NearbyState {}

class NearbyCategoryUpdated extends NearbyState {}

class NearbyRefUpdated extends NearbyState {}

class NearbyLoading extends NearbyState {}
