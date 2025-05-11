import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trendiq/common/routes.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

class ApiService {
  ApiService._();

  static final _instance = ApiService._();

  factory ApiService() => _instance;

  late final Dio _dio;

  void initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        contentType: "application/json",
      ),
    );
    _dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(
          error: true,
          responseBody: true,
          request: true,
          requestBody: true,
          responseHeader: true,
          requestHeader: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      RenderInterceptor()
    ]);
  }

  /// Perform a GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        url,
        options: options,
        queryParameters: queryParameters,
      );
    } on DioException catch(e) {
      return Response(requestOptions: RequestOptions(),data: {
        "message": "Error $e"
      });
    }
    catch (e) {
      rethrow; // Re-throw exception for better debugging
    }
  }

  /// Perform a POST request
  Future<Response> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.post(
        url,
        options: options,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Perform a PUT request
  Future<Response> put(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.put(
        url,
        options: options,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Perform a DELETE request
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.delete(
        url,
        options: options,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class RenderInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if ((err.response?.statusCode ?? 0) >= 500) {
      try {
        showDialog(
          context: Routes().navigatorKey.currentContext!,
          builder: (context) {
            return Dialog(
              backgroundColor: appColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Render is offline please wait for 60 seconds and retry"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("Back")),8.sBw,
                      ElevatedButton(onPressed: (){}, child: Text("Retry"))
                    ],)
                  ],
                ),
              ),
            );
          },
        );
      } catch (e) {
        ToastService().showToast("Render is Down please wait");
      }
    }
    super.onError(err, handler);
  }
}
