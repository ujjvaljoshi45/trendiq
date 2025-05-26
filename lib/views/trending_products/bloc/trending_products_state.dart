abstract class TrendingProductsState {}

class TrendingProductsInitial extends TrendingProductsState {}

class TrendingProductsLoading extends TrendingProductsState {}

class TrendingProductsLoaded extends TrendingProductsState {
  TrendingProductsLoaded();
}

class TrendingProductsError extends TrendingProductsState {
  final String message;
  TrendingProductsError(this.message);
}