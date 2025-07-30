abstract class OrderState {}

class OrderInitialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderLoadedState extends OrderState {}

class OrderErrorState extends OrderState {
  final String message;

  OrderErrorState({required this.message});
}
