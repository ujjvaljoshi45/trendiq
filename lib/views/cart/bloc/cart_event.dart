part of 'cart_bloc.dart';


abstract class CartEvent {}
class CartLoadEvent extends CartEvent {}
class CartCreateEvent extends CartEvent {
  final String productId;
  final String inventoryId;
  final int quantity;
  CartCreateEvent({required this.productId, required this.inventoryId , required this.quantity});
}
class CartUpdateEvent extends CartEvent {
  final String? productId;
  final String? inventoryId;
  final int? quantity;
  CartUpdateEvent({this.productId, this.inventoryId, this.quantity});
}
class CartDeleteItemEvent extends CartEvent {
  final String itemId;
  CartDeleteItemEvent({required this.itemId});
}
