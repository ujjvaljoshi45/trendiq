
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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


  Future<bool> startStripeCheckout({
    required String shipmentId,
    required BuildContext context,
  }) async {
    final result = await apiController.createPaymentIntent(
      shipmentId: shipmentId,
      isMobile: false,
    );
    final url = result.data?["url"]?.toString();
    final paymentResponse = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Payment"),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            body: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url ?? "")),
              onLoadStop: (controller, url) {
                final urlString = url.toString();
                if (urlString.contains('success')) {
                  Navigator.pop(context, true);
                } else if (urlString.contains('cancel')) {
                  Navigator.pop(context, false);
                }
              },
            ),
          ),
        );
      },
    );
    return paymentResponse ?? false;
  }

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
    await initPaymentSheet(intentId);
    await presentPaymentSheet();
    return await apiController.completePayment(tranId: transactionId);
  }

  // Strip Impl
  Future<void> initPaymentSheet(String intentId) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "TrendiQ",
          paymentIntentClientSecret: intentId,
          style: appColors.isDark ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    } catch (error, stackTrace) {
      LogService().logError("Strip INIT Error", error, stackTrace);
    }
  }

  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (error, stackTrace) {
      LogService().logError("Strip Present Error", error, stackTrace);
      return false;
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

  // Razorpay Impl
  // Future<RazorpayOrder?> createRazorpayOrder({
  //   required int amount,
  //   required String cartId,
  // }) async {
  //   try {
  //     String basicAuth =
  //         'Basic ${base64Encode(utf8.encode('$testKeyId:$secret'))}';
  //     final response = await Dio().post(
  //       "https://api.razorpay.com/v1/orders",
  //       options: Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": basicAuth,
  //         },
  //       ),
  //       data: {
  //         "amount": amount,
  //         "currency": "INR",
  //         "receipt": cartId,
  //         "notes": {"cartId": cartId},
  //       },
  //     );
  //     return RazorpayOrder.fromJson(response.data);
  //   } on DioException catch (_) {
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<void> callRazorpay({
  //   required String amount,
  //   required String cartId,
  //   required String description,
  //   required void Function(PaymentSuccessResponse) onSuccess,
  //   required void Function(PaymentFailureResponse) onFailure,
  // }) async {
  //   final intAmount = getRazorpayOrderAmount(amount);
  //   final String? orderId =
  //       (await createRazorpayOrder(amount: intAmount, cartId: cartId))?.id;
  //
  //   if (orderId == null) {
  //     toast("Unable to Create Order", isError: true);
  //     return;
  //   }
  //   final Map<String, dynamic> options = {
  //     'key': testKeyId,
  //     'amount': intAmount,
  //     'currency': 'INR',
  //     'name': 'TrendiQ',
  //     'order_id': orderId, // Generate order_id using Orders API
  //     'description': description,
  //     'timeout': 300, // in seconds
  //     'prefill': {'contact': null, 'email': StorageService().getEmail() ?? ""},
  //   };
  //   razorpay.open(options);
  //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
  //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
  // }

  // int getRazorpayOrderAmount(String amount) {
  //   return int.parse("${amount}00");
  // }
}
