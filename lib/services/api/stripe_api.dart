import 'package:dio/dio.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/models/order.dart';
import 'package:trendiq/services/api/api_constants.dart';
import 'api.dart';

mixin StripeApi on Api {
  Future<ApiResponse<Map<String, dynamic>?>> createPaymentIntent({
    required String shipmentId,
    bool isMobile = true,
  }) async {
    try {
      final response = await api.post(
        isMobile
            ? ApiConstants.stripCreatePaymentIntentMobile
            : ApiConstants.stripCreatePaymentIntent,
        data: {"shippingId": shipmentId},
      );
      return ApiResponse.fromJson(response.data, response.data);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse> completePayment({
    required String tranId,
    bool isMobile = true,
  }) async {
    try {
      final response = await api.post(
        isMobile
            ? ApiConstants.stripCompletePaymentMobile
            : ApiConstants.stripCompletePayment,
        data: {"transactionId": tranId},
      );
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }

  Future<ApiResponse<List<Order>?>> getAllOrders() async {
    try {
      final response = await api.get(ApiConstants.stripMyOrders);
      return ApiResponse.fromJson(response.data, Order.getOrderList(response.data));
    } on DioException catch (e) {
      return ApiResponse.fromDioException(e);
    } catch (e) {
      return ApiResponse.unknown();
    }
  }
}
