import 'package:equatable/equatable.dart';

abstract class AeBusinessState extends Equatable {
  const AeBusinessState();
  @override
  List<Object> get props => [];
}

class AeBusinessInitial extends AeBusinessState {}

class AeBusinessCategoryUpdated extends AeBusinessState {}

class NoMoreProducts extends AeBusinessState {}

class AeMainProductsLoaded extends AeBusinessState {}

class AeQueryProductsLoaded extends AeBusinessState {}

class AeBusinessError extends AeBusinessState {
  final String message;

  const AeBusinessError({required this.message});

  @override
  List<Object> get props => [message];
}

class GlobalBusinessRefUpdated extends AeBusinessState {}

class AeBusinessLoading extends AeBusinessState {}
