import 'package:dio/dio.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/product.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/services/storage_service.dart';

mixin ProductsApi on Api {
  // Get all trending products
  Future<ApiResponse<TrendingProductsModel?>> getUserProductTrending(
    Map<String, String> jsonData,
  ) async {
    try {
      final response = await api.get(
        ApiConstants.userProductTrending,
        queryParameters: jsonData,
      );
      return ApiResponse.fromJson(
        response.data,
        TrendingProductsModel.fromJson(response.data),
      );
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e, s) {
      LogService().logError("Trending", e, s);
      return ApiResponse.unknown();
    }
  }

  // Get all products
  Future<ApiResponse<List<Product>?>> getAllProducts(
    Map<String, String> jsonData,
  ) async {
    try {
      final response = await api.get(
        ApiConstants.userProduct,
        queryParameters: jsonData,
      );
      final List<Product> product =
          response.data[Keys.data] == null
              ? <Product>[]
              : ((response.data[Keys.data] as List)
                  .map((e) => Product.fromJson(e))
                  .toList()
                  .cast<Product>());
      return ApiResponse.fromJson(response.data, product);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e, s) {
      LogService().logError("model", e, s);
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse<Product?>> getSingleProduct(
    Map<String, String> jsonData,
  ) async {
    try {
      final response = await api.get(
        "${ApiConstants.userProduct}/${jsonData[Keys.name]}?email=${StorageService().getEmail() ?? ""}",
      );
      return ApiResponse.fromJson(
        response.data,
        Product.fromJson(response.data[Keys.data]),
      );
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse> addToCart(Map<String, dynamic> jsonData) async {
    try {
      final response = await api.post(ApiConstants.userCart, data: jsonData);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (error) {
      return ApiResponse.fromDioException(error);
    } catch (error) {
      return ApiResponse.unknown()..data = error;
    }
  }
}
