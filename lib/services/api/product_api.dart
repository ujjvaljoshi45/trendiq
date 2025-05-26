import 'package:dio/dio.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'package:trendiq/services/log_service.dart';

mixin ProductsApi on Api {
  Future<ApiResponse<TrendingProductsModel?>> getUserProductTrending(Map<String,String> jsonData) async {
    try {
      final response = await api.get(ApiConstants.userProductTrending,queryParameters: jsonData);
      return ApiResponse.fromJson(response.data, TrendingProductsModel.fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e,s) {
      LogService().logError("Trending", e, s);
      return ApiResponse.unknown();
    }
  }
}