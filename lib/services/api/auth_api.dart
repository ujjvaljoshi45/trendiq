import 'package:dio/dio.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/user_model.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'package:trendiq/services/storage_service.dart';

import '../messaging_service.dart';

mixin UserAuthApis on Api {
  Future<ApiResponse<UserModel?>> userLogin(Map<String,String> jsonData) async {
    try {
      jsonData.addAll({
        Keys.fcmToken: (await FCMService().generateNewToken()) ?? ""
      });
      final response = await api.post(ApiConstants.userSignIn,data: jsonData);
      final result = ApiResponse.fromJson(response.data, UserModel.fromJson(response.data[Keys.user])..token=response.data[Keys.token]);
      StorageService().saveToken(result.data?.token ?? "");
      StorageService().saveEmail(result.data?.email ?? "");
      return result;
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse<UserModel?>> userRegister(
      Map<String, String> jsonData) async {
    try {
      jsonData.addAll({
        Keys.fcmToken: (await FCMService().generateNewToken()) ?? ""
      });
      final response = await api.post(ApiConstants.userSignUp, data: jsonData);
      final result = ApiResponse.fromJson(
          response.data, UserModel.fromJson(response.data[Keys.user])..token = response.data?[Keys.token]);
      StorageService().saveToken(result.data?.token ?? "");
      StorageService().saveEmail(result.data?.email ?? "");
      return result;
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse<Map<String,dynamic>?>> updatePassword(Map<String,String> jsonData) async {
    try {
      final response = await api.post(ApiConstants.userUpdatePassword,data: jsonData);
      return ApiResponse.fromJson(response.data, response.data[Keys.data]);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse<UserModel>> getAppUser() async {
    try {
      final response = await api.get(ApiConstants.userGetUserDetails);
      final result = ApiResponse.fromJson(
        response.data,
        UserModel.fromJson(response.data["data"])
      );
      StorageService().saveEmail(result.data?.email ?? "");
      return result;
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }
}
