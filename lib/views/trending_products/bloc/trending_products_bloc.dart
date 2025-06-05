import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_event.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_state.dart';

class TrendingProductsBloc
    extends Bloc<TrendingProductEvent, TrendingProductsState> {
  TrendingProductsModel get trendingProductsModel =>
      isMen ? trendingProductsModelMen : trendingProductsModelWomen;
  TrendingProductsModel trendingProductsModelMen =
      TrendingProductsModel.dummy();
  TrendingProductsModel trendingProductsModelWomen =
      TrendingProductsModel.dummy();
  bool isMen = true;

  TrendingProductsBloc() : super(TrendingProductsInitial()) {
    on<LoadTrendingProductEvent>(_loadTrendingProducts);
  }

  Future<void> _loadTrendingProducts(
    LoadTrendingProductEvent event,
    Emitter<TrendingProductsState> emit,
  ) async {
    emit(TrendingProductsLoading());
    isMen = event.gender == "male";
    if ((isMen ? trendingProductsModelMen : trendingProductsModelWomen)
            .statusCode ==
        200) {
      emit(TrendingProductsLoaded());
      return;
    }
    final result = await apiController.getUserProductTrending({
      "gender": event.gender,
    });

    if (isMen) {
      trendingProductsModelMen = result.data ?? TrendingProductsModel.dummy();
    } else {
      trendingProductsModelWomen = result.data ?? TrendingProductsModel.dummy();
    }
    if (result.isError) {
      toast(result.message, isError: true);
      emit(TrendingProductsError(result.message));
      return;
    }
    emit(TrendingProductsLoaded());
  }
}
