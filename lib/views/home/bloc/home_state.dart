part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  HomeLoading();
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeLoaded extends HomeState {
  HomeLoaded();
}
