import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/common/routes.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';

import '../storage_service.dart';

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
    _dio.interceptors.addAll([AuthInterceptor()]);
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
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {"message": "Error $e"},
      );
    } catch (e) {
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
  Future<Response> patch(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.patch(
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

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      "Authorization": "Bearer ${StorageService().getToken()}",
    });
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      StorageService().clear();
      try {
        BlocProvider.of<AuthBloc>(
          Routes().navigatorKey.currentContext!,
        ).add(AuthLogoutEvent());
      } catch (e) {
        log("Error: $e");
      }
      toast("User Not Authorized Logging Out", isError: true);
      try {
        Navigator.of(
          Routes().navigatorKey.currentContext!,
        ).pushNamedAndRemoveUntil(RoutesKey.home, (route) => false);
      } catch (e) {
        toast("Please Login to Continue", isInformation: true);
      }
    }
    super.onError(err, handler);
  }
}
