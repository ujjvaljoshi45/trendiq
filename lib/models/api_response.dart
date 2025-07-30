import 'package:dio/dio.dart';
import 'package:trendiq/constants/keys.dart';

class ApiResponse<T> {
  T? data;
  String message;
  bool isError;

  ApiResponse({this.data, this.message = "", this.isError = false});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? data) {
    return ApiResponse(
      isError: json[Keys.statusCode] < 200 && json[Keys.statusCode] > 299,
      message: _getErrorMessage(json[Keys.message]),
      data: data,
    );
  }

  factory ApiResponse.fromDioException(DioException error) {
    return ApiResponse(
      isError: true,
      message: _getErrorMessage(error.response?.data[Keys.message]),
      data: error.response?.data[Keys.data],
    );
  }

  static String _getErrorMessage(dynamic response) {
    if (response.runtimeType == String) {
      return response;
    } else if (response.runtimeType == List) {
      return response.first;
    } else {
      return "Something went wrong!";
    }
  }

  factory ApiResponse.unknown() {
    return ApiResponse(
      data: null,
      message: "Unknown Error Occurred.",
      isError: true,
    );
  }
}
