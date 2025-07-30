part of 'address_bloc.dart';

abstract class AddressState {}

class AddressInitialState extends AddressState {}
class AddressLoadingState extends AddressState {}
class AddressLoadedState extends AddressState {}
class AddressUpdatedState extends AddressState {
  final String message;
  AddressUpdatedState(this.message);
}
class AddressErrorState extends AddressState {
  final String message;
  AddressErrorState(this.message);
}
