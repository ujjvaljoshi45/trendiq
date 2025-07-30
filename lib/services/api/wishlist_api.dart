import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/wishlist.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';

mixin WishlistApi on Api {
  Future<ApiResponse<List<Wishlist>?>> getWishList() async {
    try {
      final response = await api.get(ApiConstants.userWishlist);
      return ApiResponse.fromJson(
        response.data,
        response.data[Keys.data]
            .map<Wishlist>((e) => Wishlist.fromJson(e))
            .toList(),
      );
    } on DioException catch (err) {
      return ApiResponse.fromDioException(err);
    } catch (err, st) {
      log("error", error: err, stackTrace: st);
      return ApiResponse.unknown()..message = err.toString();
    }
  }

  Future<ApiResponse> addToWishList(Map<String, String> jsonData) async {
    try {
      final response = await api.post(
        ApiConstants.userWishlist,
        data: jsonData,
      );
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (err) {
      return ApiResponse.fromDioException(err);
    } catch (err) {
      return ApiResponse.unknown()..message = err.toString();
    }
  }

  Future<ApiResponse> removeFromWishList(String productId) async {
    try {
      final response = await api.delete(
        "${ApiConstants.userWishlist}/$productId",
      );
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (err) {
      return ApiResponse.fromDioException(err);
    } catch (err) {
      return ApiResponse.unknown()..message = err.toString();
    }
  }
}
