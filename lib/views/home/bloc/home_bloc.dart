import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageController pageController = PageController();
  String gender = 'male';
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>(_homeUpdate);
    on<HomeLoadedEvent>(_homeLoaded);
  }

  void _homeUpdate(LoadHome event, Emitter<HomeState> emit) {
    gender = event.gender;
    emit(HomeLoading());
  }

  void _homeLoaded(HomeLoadedEvent event, Emitter<HomeState> emit) {
    emit(HomeLoaded());
  }

}
