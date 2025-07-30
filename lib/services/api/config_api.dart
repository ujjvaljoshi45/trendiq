import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'package:trendiq/services/payment/payment_service.dart';
import 'package:trendiq/services/storage_service.dart';
import 'package:trendiq/services/toast_service.dart';

import 'api.dart';

mixin ConfigApi on Api {
  Future<ApiResponse> getConfigs() async {
    String? configPass;
    try {
      await dotenv.load(fileName: ".env");
      configPass =
          dotenv.env['CONFIG_PASS'] != null
              ? utf8.decode(base64Decode(dotenv.env['CONFIG_PASS']!))
              : '';
    } catch (e) {
      toast("Unable to connect to servers");
      return ApiResponse.unknown();
    }
    try {
      final response = await api.post(
        ApiConstants.configs,
        data: {"pass": configPass},
      );
      final base64publicKey = response.data["publicKey"]?.toString() ?? "";
      PaymentService().strStripPublishableKey = utf8.decode(base64Decode(base64publicKey));
      StorageService().saveVersion(response.data["version"] ?? "");
      return ApiResponse(isError: false, data: null);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  final kPass = jsonEncode(r"*123$321$key@private");
}
