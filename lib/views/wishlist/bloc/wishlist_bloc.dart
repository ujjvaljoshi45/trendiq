import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/models/wishlist.dart';
import 'package:trendiq/services/api/api_controller.dart';

part 'wishlist_event.dart';

part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  List<Wishlist> wishlist = [];

  WishlistBloc() : super(WishlistInitial()) {
    on<WishlistLoadEvent>(_onWishlistLoadEvent);
    on<WishlistUpdateEvent>(_onWishlistUpdateEvent);
  }

  void _onWishlistLoadEvent(
    WishlistLoadEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());
    final response = await apiController.getWishList();
    if (response.isError) {
      emit(WishlistErrorState(message: response.message));
    } else {
      wishlist = response.data ?? [];
      emit(WishlistLoadedState());
    }
  }

  void _onWishlistUpdateEvent(
    WishlistUpdateEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());
    final response =
        event.isDelete
            ? await apiController.removeFromWishList(event.productId)
            : await apiController.addToWishList({"productId": event.productId});
    if (response.isError) {
      emit(WishlistErrorState(message: response.message));
    } else {
      emit(WishlistLoadedState());
    }
  }
}
