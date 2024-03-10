import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/relation.dart';

abstract class RelationsState extends Equatable {
  const RelationsState();

  @override
  List<Object?> get props => [];

  Map<String, dynamic>? toJson() {
    return null;
  }
}

class RelationsInitial extends RelationsState {}

class RelationsLoading extends RelationsState {}

class RelationsLoaded extends RelationsState {
  final List<Relation>? relations;

  const RelationsLoaded({required this.relations});

  @override
  List<Object?> get props => [relations];

  @override
  Map<String, dynamic> toJson() {
    return {'relations': relations?.map((relation) => relation.toJson()).toList()};
  }
}
