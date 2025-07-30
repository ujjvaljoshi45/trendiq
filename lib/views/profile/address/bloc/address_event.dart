part of 'address_bloc.dart';

abstract class AddressEvent {}

class AddressLoadEvent extends AddressEvent {}
class AddressCreateEvent extends AddressEvent {
  final String name;
  final String pinCode;
  final String address;
  AddressCreateEvent(this.name,this.pinCode,this.address);
}
class AddressDefaultEvent extends AddressEvent {
  final String id;
  AddressDefaultEvent(this.id);
}
class AddressUpdateEvent extends AddressEvent {
  final String addressId;
  final String name;
  final String pinCode;
  final String address;
  AddressUpdateEvent(this.addressId, this.name,this.pinCode,this.address);
}
class AddressDeleteEvent extends AddressEvent {
  final String id;
  AddressDeleteEvent(this.id);
}

