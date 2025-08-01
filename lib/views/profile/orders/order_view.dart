import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/order.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/views/profile/orders/bloc/order_bloc.dart';
import 'package:trendiq/views/profile/orders/bloc/order_event.dart';
import 'package:trendiq/views/profile/orders/bloc/order_state.dart';
import 'package:trendiq/views/profile/orders/order_detail_view.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late final OrderBloc orderBloc;

  @override
  void initState() {
    orderBloc = BlocProvider.of<OrderBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => orderBloc.add(OrderLoadEvent()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Orders", showBackButton: true),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadedState || state is OrderLoadingState) {
            if (orderBloc.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    12.sBh,
                    Text(
                      'No orders yet',
                      style: commonTextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return Skeletonizer(
              enabled: state is OrderLoadingState,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: orderBloc.orders.length,
                itemBuilder: (context, index) {
                  final order = orderBloc.orders[index];
                  return _buildOrderCard(order);
                },
              ),
            );
          }

          return Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.divider, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to order details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailView(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: appColors.textSecondary,
                      ),
                      6.sBw,
                      Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(order.createdAt ?? DateTime.now()),
                        style: commonTextStyle(
                          color: appColors.textPrimary,
                          fontSize: 14,
                          fontFamily: Fonts.fontMedium,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: appColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      order.status ?? '-',
                      style: commonTextStyle(
                        color: appColors.primary,
                        fontSize: 10,
                        fontFamily: Fonts.fontSemiBold,
                      ),
                    ),
                  ),
                ],
              ),
              8.sBh,

              // Address and item count
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: appColors.textSecondary,
                  ),
                  6.sBw,
                  Expanded(
                    child: Text(
                      order.address?.name ?? "-",
                      style: commonTextStyle(
                        color: appColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  6.sBw,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: appColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${order.products.length} items',
                      style: commonTextStyle(
                        color: appColors.textSecondary,
                        fontSize: 10,
                        fontFamily: Fonts.fontMedium,
                      ),
                    ),
                  ),
                ],
              ),

              // Product thumbnails
              if (order.products.isNotEmpty) ...[
                12.sBh,
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              order.products.length > 4
                                  ? 4
                                  : order.products.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: appColors.divider,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.network(
                                        order.products[index].imageUrl ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: appColors.primary
                                                .withOpacity(0.05),
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 24,
                                              color: appColors.textSecondary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (index == 3 && order.products.length > 4)
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: appColors.textPrimary
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${order.products.length - 4}',
                                          style: commonTextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: Fonts.fontBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              8.sBh,
              Container(height: 1, color: appColors.divider),
              6.sBh,
              // Total amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: commonTextStyle(
                      fontFamily: Fonts.fontMedium,
                      color: appColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${Keys.inr}${order.finalAmount}',
                    style: commonTextStyle(
                      fontFamily: Fonts.fontSemiBold,
                      fontSize: 14,
                      color: appColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
