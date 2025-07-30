import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/models/cart.dart';
import 'package:trendiq/services/api/api_controller.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  Cart cart = Cart.dummy();
  String? strCartCount;

  CartBloc() : super(CartInitialState()) {
    on<CartLoadEvent>(_loadCartEvent);
    on<CartCreateEvent>(_createCartEvent);
    on<CartUpdateEvent>(_updateCartEvent);
    on<CartDeleteItemEvent>(_deleteCartEvent);
    on<CartAddressUpdateEvent>(_updateCartAddress);
  }

  void _loadCartEvent(CartLoadEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    final result = await apiController.getCart();
    if (result.isError) {
      emit(CartErrorState(result.message));
    } else {
      cart = result.data ?? cart;
      await _refreshCartCount();
      emit(CartLoadedState());
    }
  }

  void _createCartEvent(CartCreateEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    final result = await apiController.createCart({
      "productId": event.productId,
      "inventoryId": event.inventoryId,
      "quantity": event.quantity.toString(),
    });
    if (result.isError) {
      emit(CartErrorState(result.message));
    } else {
      await _refreshCartCount();
      emit(CartReloadState());
    }
  }

  void _updateCartEvent(CartUpdateEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    final result = await apiController.updateCart({
      "cartId": event.cartId,
      "productId": event.productId,
      "inventoryId": event.inventoryId,
      "quantity": event.quantity,
    });
    if (result.isError) {
      emit(CartErrorState(result.message));
    } else {
      await _refreshCartCount();
      emit(CartReloadState());
    }
  }

  void _deleteCartEvent(
    CartDeleteItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoadingState());
    final result = await apiController.deleteCart(event.itemId);
    if (result.isError) {
      emit(CartErrorState(result.message));
    } else {
      await _refreshCartCount();
      emit(CartReloadState());
    }
  }

  void _updateCartAddress(
    CartAddressUpdateEvent event,
    Emitter<CartState> emit,
  ) {
    cart.selectedCartAddress = event.newIndex;
    emit(CartLoadedState());
  }

  Future<void> _refreshCartCount() async {
    strCartCount = (await apiController.getCartCount()).data;
    print(strCartCount.toString());
  }
}
