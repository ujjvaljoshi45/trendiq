import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_event.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_state.dart';

class TrendingProductsBloc
    extends Bloc<TrendingProductEvent, TrendingProductsState> {


  TrendingProductsBloc() : super(TrendingProductsInitial()) {
    on<LoadTrendingProductEvent>(_loadTrendingProducts);
  }

  Future<void> _loadTrendingProducts(
    LoadTrendingProductEvent event,
    Emitter<TrendingProductsState> emit,
  ) async {
    emit(TrendingProductsLoading());
    final result = await apiController.getUserProductTrending({
      "gender": event.gender,
    });
    if (result.statusCode == 200) {
      emit(TrendingProductsLoaded(result));
    } else {
      emit(TrendingProductsError(result.message));
    }
  }
}
