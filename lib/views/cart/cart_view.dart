import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/payment/payment_service.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/cart/bloc/cart_bloc.dart';
import 'package:trendiq/views/cart/widget/cart_address_view.dart';
import 'package:trendiq/common/empty_bag_view.dart';
import 'package:trendiq/views/cart/widget/cart_product_view.dart';
import 'package:trendiq/views/cart/widget/cart_summary_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late final CartBloc cartBloc;

  @override
  void initState() {
    cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(CartLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Shopping Cart", showBackButton: true),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (cartBloc.cart.data.isEmpty && state is! CartLoadingState) {
            return SizedBox();
          }
          return Skeletonizer(
            enabled: state is CartLoadingState,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (cartBloc.cart.cartSummary?.finalAmount != null) {
                    final shipmentId =
                        cartBloc
                            .cart
                            .addresses[cartBloc.cart.selectedCartAddress]
                            .id;
                    if (shipmentId == null) {
                      toast("Please add address to continue", isError: true);
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return PopScope(canPop: false, child: SizedBox());
                        },
                      );
                      final response = await PaymentService()
                          .startStripPaymentIntent(shipmentId: shipmentId);

                      Navigator.pop(context);
                      showOrderDialog(
                        context,
                        !response.isError,
                        response.message,
                      );
                    }
                    // PaymentService()
                    //     .startStripeCheckout(
                    //       shipmentId:
                    //           cartBloc
                    //               .cart
                    //               .addresses[cartBloc.cart.selectedCartAddress]
                    //               .id ??
                    //           "",context: context
                    //     )
                    //     .then((value) {
                    //       if (value) {
                    //         LogService().logMessage("Payment is done");
                    //         Navigator.popUntil(
                    //           context,
                    //           (route) => route.isFirst,
                    //         );
                    //       }
                    //     });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),
                child: Text(
                  "Proceed to Checkout",
                  style: commonTextStyle(
                    fontSize: 16,
                    fontFamily: Fonts.fontSemiBold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: BlocConsumer<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadedState || state is CartLoadingState) {
            return Skeletonizer(
              enabled: state is CartLoadingState,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child:
                    cartBloc.cart.data.isEmpty
                        ? EmptyBagView(
                          title: "Your cart is empty",
                          subtitle:
                              "Looks like you haven't added any items to your cart yet.",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                        : // In your CartView's build method, replace the SingleChildScrollView content:
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // Replace the for loop with this:
                              for (
                                int i = 0;
                                i < cartBloc.cart.data.length;
                                i++
                              )
                                CartProductCard(
                                  item: cartBloc.cart.data[i],
                                  onDelete: () {
                                    cartBloc.add(
                                      CartDeleteItemEvent(
                                        itemId: cartBloc.cart.data[i].id!,
                                      ),
                                    );
                                  },
                                  onIncrement: () {
                                    cartBloc.add(
                                      CartUpdateEvent(
                                        cartId: cartBloc.cart.data[i].id!,
                                        inventoryId:
                                            cartBloc
                                                .cart
                                                .data[i]
                                                .productInventoryId!,
                                        productId:
                                            cartBloc.cart.data[i].productId!,
                                        quantity:
                                            cartBloc.cart.data[i].quantity! + 1,
                                      ),
                                    );
                                  },
                                  onDecrement: () async {
                                    final item = cartBloc.cart.data[i];
                                    if (item.quantity == 1) {
                                      final bool?
                                      isUpdate = await showAdaptiveDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (context) => AlertDialog(
                                              title: Text("Delete Item"),
                                              content: Text(
                                                "Do you want to remove this item?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: Text("Yes"),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (isUpdate == true) {
                                        cartBloc.add(
                                          CartDeleteItemEvent(itemId: item.id!),
                                        );
                                      }
                                      return;
                                    }
                                    cartBloc.add(
                                      CartUpdateEvent(
                                        cartId: item.id!,
                                        inventoryId: item.productInventoryId!,
                                        productId: item.productId!,
                                        quantity: item.quantity! - 1,
                                      ),
                                    );
                                  },
                                ),
                              10.sBh,
                              CartAddressCard(
                                addresses: cartBloc.cart.addresses,
                                onAddressChange: (int index) {
                                  cartBloc.add(CartLoadEvent());
                                },
                                selectedAddressIndex:
                                    cartBloc.cart.selectedCartAddress,
                              ),
                              10.sBh,
                              CartSummaryCard(
                                cartSummary: cartBloc.cart.cartSummary,
                              ),
                            ],
                          ),
                        ),
              ),
            );
          } else {
            return Center(child: Text(state.runtimeType.toString()));
          }
        },
        listener: (context, state) {
          if (state is CartErrorState) {
            toast(state.message, isError: true);
          }

          if (state is CartReloadState) {
            cartBloc.add(CartLoadEvent());
          }
        },
      ),
    );
  }

  void showOrderDialog(BuildContext context, bool isSuccess, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  isSuccess ? 'Order Placed!' : 'Order Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green[800] : Colors.red[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: commonTextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(RoutesKey.home, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isSuccess ? 'Continue Shopping' : 'Go to Home'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
