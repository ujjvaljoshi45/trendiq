import 'package:dio/dio.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/product_category_model.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';

mixin CategoryApi on Api {
  Future<ApiResponse<ProductCategoryModel?>> getCategories(Map<String,String> jsonData) async {
    try {
      final response = await api.get(ApiConstants.userCategory,queryParameters: jsonData);
      return ApiResponse.fromJson(response.data, ProductCategoryModel.fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }
}