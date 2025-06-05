import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/log_service.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState()) {
    on<CartLoadEvent>(_loadCartEvent);
    on<CartCreateEvent>(_createCartEvent);
    on<CartUpdateEvent>(_updateCartEvent);
    on<CartDeleteItemEvent>(_deleteCartEvent);

  }

  void _loadCartEvent(CartLoadEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    final result = await apiController.getCart();
    LogService().logMessage(result.data.toString());
    if (result.isError) {
      emit(CartErrorState());
    } else {
      emit(CartLoadedState());
    }
  }
  void _createCartEvent(CartCreateEvent event, Emitter<CartState> emit) {}
  void _updateCartEvent(CartUpdateEvent event, Emitter<CartState> emit) {}
  void _deleteCartEvent(CartDeleteItemEvent event, Emitter<CartState> emit) {}

}
