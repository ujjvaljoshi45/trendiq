import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/models/order.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/views/profile/orders/bloc/order_event.dart';
import 'package:trendiq/views/profile/orders/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  List<Order> orders = [];

  OrderBloc() : super(OrderInitialState()) {
    on<OrderLoadEvent>(_getAllOrders);
  }

  void _getAllOrders(OrderLoadEvent event, Emitter<OrderState> emit) async {
    orders = Order.getOrderList({
      "data":List.generate(10, (index) => {
        "orderId": index
      })
    });
    emit(OrderLoadingState());
    final response = await apiController.getAllOrders();
    if (response.isError) {
      orders = [];
      emit(OrderErrorState(message: response.message));
    } else {
      orders = response.data ?? [];
      emit(OrderLoadedState());
    }
  }
}
