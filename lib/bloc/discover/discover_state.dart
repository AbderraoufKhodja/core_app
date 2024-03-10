import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/post.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();
  @override
  List<Object> get props => [];
}

class DiscoverInitial extends DiscoverState {}

class DiscoverCategoryUpdated extends DiscoverState {}

class DiscoverRefUpdated extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final Future<QuerySnapshot<Post>> posts;

  const DiscoverLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class NearbyInitial extends DiscoverState {}

class NearbyCategoryUpdated extends DiscoverState {}

class NearbyRefUpdated extends DiscoverState {}

class NearbyLoading extends DiscoverState {}

class NearbyLoaded extends DiscoverState {
  final Future<QuerySnapshot<Post>> posts;

  const NearbyLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}
