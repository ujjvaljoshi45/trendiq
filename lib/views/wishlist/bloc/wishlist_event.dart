part of 'wishlist_bloc.dart';

abstract class WishlistEvent {}

class WishlistLoadEvent extends WishlistEvent {}

class WishlistUpdateEvent extends WishlistEvent {
  final String productId;
  final bool isDelete;

  WishlistUpdateEvent({required this.productId, required this.isDelete});
}
