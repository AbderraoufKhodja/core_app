import 'package:equatable/equatable.dart';

abstract class TranslatorDashboardState extends Equatable {
  const TranslatorDashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends TranslatorDashboardState {}

class DashboardCategoryUpdated extends TranslatorDashboardState {}

class DashboardUpdated extends TranslatorDashboardState {}

class DashboardLoading extends TranslatorDashboardState {}
