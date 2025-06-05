import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/models/product_category_model.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/toast_service.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  ProductCategoryModel get productCategoryModel => isMen ? productCategoryModelMen : productCategoryModelWomen;
  ProductCategoryModel productCategoryModelMen = ProductCategoryModel.dummy();
  ProductCategoryModel productCategoryModelWomen = ProductCategoryModel.dummy();
  bool isMen = true;
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryLoadEvent>(_onCategoryLoadEvent);
  }

  void _onCategoryLoadEvent(
    CategoryLoadEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading(event.gender));
    isMen = event.gender == "male";
    if ((isMen ? productCategoryModelMen : productCategoryModelWomen).statusCode == 200) {
      emit(CategoryLoaded());
      return;
    }
    try {
      final result = await apiController.getCategories({
        "gender": event.gender,
      });
      if (isMen) {
        productCategoryModelMen = result.data ?? ProductCategoryModel.dummy();
      } else {
        productCategoryModelWomen = result.data ?? ProductCategoryModel.dummy();
      }
      if (result.isError) {
        toast(result.message, isError: true);
      }
      emit(CategoryLoaded());
    } catch (e) {
      emit(CategoryError("Something Went Wrong"));
    }
  }
}
