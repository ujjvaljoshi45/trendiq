part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadHome extends HomeEvent {
  final String gender;
  LoadHome(this.gender);
}

class HomeLoadedEvent extends HomeEvent {
  final String gender;
  HomeLoadedEvent(this.gender);
}