import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/log_service.dart';

class PaymentService {
  static final _instance = PaymentService._();

  PaymentService._();

  factory PaymentService() => _instance;

  String secret = "";
  late final String strStripPublishableKey;

  Future<ApiResponse> startStripPaymentIntent({
    required String shipmentId,
  }) async {
    final createPaymentIntentResponse = await apiController.createPaymentIntent(
      shipmentId: shipmentId,
      isMobile: true,
    );
    final intentId =
    createPaymentIntentResponse.data?["clientSecret"]?.toString();
    final transactionId =
    createPaymentIntentResponse.data?["transactionId"]?.toString();
    if (createPaymentIntentResponse.isError ||
        intentId == null ||
        transactionId == null) {
      return ApiResponse(
        isError: true,
        message: createPaymentIntentResponse.message,
      );
    }
    final initPaymentSheetResponse = await initPaymentSheet(intentId);

    if (initPaymentSheetResponse.isError) {
      return ApiResponse(
        isError: true,
        message: initPaymentSheetResponse.message,
      );
    }

    final paymentSheetResponse = await presentPaymentSheet();

    if (paymentSheetResponse.isError) {
      return ApiResponse(isError: true, message: paymentSheetResponse.message);
    }

    return await apiController.completePayment(tranId: transactionId);
  }

  // Strip Impl
  Future<ApiResponse> initPaymentSheet(String intentId) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "TrendiQ",
          paymentIntentClientSecret: intentId,
          style: appColors.isDark ? ThemeMode.dark : ThemeMode.light,
        ),
      );
      return ApiResponse(isError: false);
    } on StripeError catch (error) {
      return ApiResponse(isError: true, message: error.message);
    }
  }

  Future<ApiResponse> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return ApiResponse(isError: false);
    } on StripeException catch (error) {
      String errorMessage;
      switch (error.error.code) {
        case FailureCode.Failed:
          errorMessage =
          "Payment Is Failed, if money is debited from your account it will be refunded shortly";
          break;
        case FailureCode.Canceled:
          errorMessage = "Payment Canceled";
          break;
        case FailureCode.Timeout:
          errorMessage = "Payment Timeout";
          break;
        case FailureCode.Unknown:
          errorMessage = "Unknown Error Occurred.";
          break;
      }
      return ApiResponse(
          isError: true, message: errorMessage);
    } catch (error) {
      return ApiResponse.unknown();
    }
  }

  Future<String?> confirmPayment(String intentId) async {
    try {
      return (await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: intentId,
      )).id;
    } catch (error, stackTrace) {
      LogService().logError("confirm Error", error, stackTrace);
      return null;
    }
  }
}
