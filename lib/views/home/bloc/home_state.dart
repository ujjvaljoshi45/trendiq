part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final String gender;
  HomeLoading(this.gender);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeLoaded extends HomeState {
  final String gender;

  HomeLoaded(this.gender);
}
