import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/views/cart/bloc/cart_bloc.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    BlocProvider.of<CartBloc>(context).add(CartLoadEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc,CartState>(builder: (context, state) {
      if (state is CartLoadedState || state is CartLoadingState) {
        return Skeletonizer(
            enabled: state is CartLoadingState,
            child: Container());
      } else {
        return Center(child: Text(
          state.runtimeType.toString()
        ));
      }
    }, listener: (context, state) {
      LogService().logMessage("state: ${state.runtimeType}");
    },);
  }
}
