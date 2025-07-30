
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/api_response.dart';
import 'package:trendiq/services/api/api_controller.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  List<dynamic> addresses = [];

  AddressBloc() : super(AddressInitialState()) {
    on<AddressLoadEvent>(onLoadEvent);
    on<AddressCreateEvent>(onCreateEvent);
    on<AddressUpdateEvent>(onUpdateEvent);
    on<AddressDeleteEvent>(onDeleteEvent);
    on<AddressDefaultEvent>(onDefaultEvent);
  }

  onLoadEvent(AddressLoadEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoadingState());
    final apiResponse = await apiController.getAddresses();
    if (apiResponse.isError) {
      emit(AddressErrorState(apiResponse.message));
    } else {
      addresses = apiResponse.data ?? [];
      emit(AddressLoadedState());
    }
  }

  onDefaultEvent(AddressDefaultEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoadingState());
    final ApiResponse apiResponse = await apiController.setDefaultAddress(event.id);
    if (apiResponse.isError) {
      emit(AddressErrorState(apiResponse.message));
    } else {
      emit(AddressUpdatedState(apiResponse.message));
    }
  }

  onCreateEvent(AddressCreateEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoadingState());
    final ApiResponse apiResponse = await apiController.createAddress({
      Keys.name: event.name,
      Keys.pinCode: event.pinCode,
      Keys.address: event.address,
    });

    if (apiResponse.isError) {
      emit(AddressErrorState(apiResponse.message));
    } else {
      emit(AddressUpdatedState(apiResponse.message));
    }
  }

  onUpdateEvent(AddressUpdateEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoadingState());
    final ApiResponse apiResponse = await apiController.updateAddress({
      Keys.addressId:event.addressId,
      Keys.name: event.name,
      Keys.pinCode: event.pinCode,
      Keys.address: event.address,
    });

    if (apiResponse.isError) {
      emit(AddressErrorState(apiResponse.message));
    } else {
      emit(AddressUpdatedState(apiResponse.message));
    }
  }

  onDeleteEvent(AddressDeleteEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoadingState());
    final ApiResponse apiResponse = await apiController.deleteAddress(event.id);
    if (apiResponse.isError) {
      emit(AddressErrorState(apiResponse.message));
    } else {
      emit(AddressUpdatedState(apiResponse.message));
    }
  }
}
