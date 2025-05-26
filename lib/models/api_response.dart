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
      message: json[Keys.message],
      data: data,
    );
  }

  factory ApiResponse.fromDioException(DioException error) {

    return ApiResponse(
      isError: true,
      message: error.response?.data[Keys.message] ?? "Something went wrong!",
      data: error.response?.data[Keys.data],
    );
  }

  factory ApiResponse.unknown() {
    return ApiResponse(
      data: null,
      message: "Unknown Error Occurred.",
      isError: true,
    );
  }
}
