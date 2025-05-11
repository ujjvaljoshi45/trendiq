import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/api/api_service.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryLoadEvent>(_onCategoryLoadEvent);
  }

  void _onCategoryLoadEvent(
    CategoryLoadEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(CategoryLoading(event.gender));
    apiController
        .getCategories({"gender": event.gender})
        .whenComplete(() {
          emit(CategoryLoaded(event.gender));
        })
        .catchError((err) {
          emit(CategoryError("Something Went Wrong!"));
        });
  }
}
