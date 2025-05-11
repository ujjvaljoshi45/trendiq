import 'package:trendiq/models/trending_products_model.dart';

abstract class TrendingProductsState {}

class TrendingProductsInitial extends TrendingProductsState {}

class TrendingProductsLoading extends TrendingProductsState {}

class TrendingProductsLoaded extends TrendingProductsState {
  final TrendingProductsModel trendingProductsModel;
  TrendingProductsLoaded(this.trendingProductsModel);
}

class TrendingProductsError extends TrendingProductsState {
  final String message;
  TrendingProductsError(this.message);
}