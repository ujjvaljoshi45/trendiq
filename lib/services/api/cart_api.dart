import 'package:dio/dio.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/services/api/api_constants.dart';

import 'api.dart';

mixin CartApi on Api {
  Future<ApiResponse> createCart(Map<String, String> jsonData) async {
    try {
      final response = await api.post(ApiConstants.userCart, data: jsonData);
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown()..data = e;
    }
  }

  Future<ApiResponse> updateCart(Map<String, String> jsonData) async {
    try {
      final response = await api.patch(ApiConstants.userCart, data: jsonData);
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown()..data = e;
    }
  }

  Future<ApiResponse> deleteCart(String id) async {
    try {
      final response = await api.delete("${ApiConstants.userCart}/$id");
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown()..data = e;
    }
  }

  Future<ApiResponse> getCart() async {
    try {
      final response = await api.get(ApiConstants.userCart);
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown()..data = e;
    }
  }
}
