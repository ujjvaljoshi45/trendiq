import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/address.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';

mixin AddressApi on Api {
  Future<ApiResponse<List<Address>?>> getAddresses() async {
    try {
      final response = await api.get(ApiConstants.userAddress);
      return ApiResponse.fromJson(
        response.data,
        response.data[Keys.data] == null
            ? []
            : List<Address>.from(
              response.data[Keys.data].map((e) => Address.fromJson(e)),
            ),
      );
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      log("Address", error: e);
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse> createAddress(Map<String, String> jsonData) async {
    try {
      final response = await api.post(ApiConstants.userAddress, data: jsonData);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse> updateAddress(Map<String, String> jsonData) async {
    try {
      final response = await api.patch(ApiConstants.userAddress, data: jsonData);
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse> setDefaultAddress(String id) async {
    try {
      final response = await api.patch(
        "${ApiConstants.userAddressDefault}/$id",
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }


  Future<ApiResponse> deleteAddress(String id) async {
    try {
      final response = await api.delete(
        "${ApiConstants.userAddress}/$id",
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }
}
