part of 'wishlist_bloc.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {}

class WishlistErrorState extends WishlistState {
  final String message;

  WishlistErrorState({required this.message});
}
