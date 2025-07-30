import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/order.dart';
import 'package:trendiq/services/app_colors.dart';

class OrderDetailView extends StatefulWidget {
  final Order order;

  const OrderDetailView({super.key, required this.order});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Order Details", showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            SizedBox(height: 20),
            _buildShippingInfo(),
            SizedBox(height: 20),
            _buildOrderItems(),
            SizedBox(height: 20),
            _buildOrderSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Status',
                style: commonTextStyle(
                  fontSize: 16,
                  fontFamily: Fonts.fontSemiBold,
                  color: appColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: appColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.order.status ?? '-',
                  style: commonTextStyle(
                    color: appColors.primary,
                    fontSize: 12,
                    fontFamily: Fonts.fontSemiBold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: appColors.textSecondary,
              ),
              SizedBox(width: 8),
              Text(
                'Ordered on ${DateFormat('MMM dd, yyyy').format(widget.order.createdAt ?? DateTime.now())}',
                style: commonTextStyle(
                  color: appColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: commonTextStyle(
              fontSize: 16,
              fontFamily: Fonts.fontSemiBold,
              color: appColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: appColors.textSecondary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.address?.name ?? '-',
                      style: commonTextStyle(
                        fontSize: 14,
                        fontFamily: Fonts.fontMedium,
                        color: appColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.order.address?.address ?? '',
                      style: commonTextStyle(
                        fontSize: 14,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${widget.order.products.length})',
            style: commonTextStyle(
              fontSize: 16,
              fontFamily: Fonts.fontSemiBold,
              color: appColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.order.products.length,
            separatorBuilder:
                (context, index) =>
                    Divider(color: appColors.divider, height: 24),
            itemBuilder: (context, index) {
              final product = widget.order.products[index];
              return Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appColors.divider),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        product.imageUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: appColors.primary.withOpacity(0.05),
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
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title ?? '-',
                          style: commonTextStyle(
                            fontSize: 14,
                            fontFamily: Fonts.fontMedium,
                            color: appColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Size: ${product.size?.name ?? "-"}',
                          style: commonTextStyle(
                            fontSize: 12,
                            color: appColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        //TODO: get QTY
                        Text(
                          'Qty: -',
                          style: commonTextStyle(
                            fontSize: 12,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${Keys.inr}${(product.price ?? 0).toStringAsFixed(2)}',
                    style: commonTextStyle(
                      fontSize: 14,
                      fontFamily: Fonts.fontSemiBold,
                      color: appColors.primary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: commonTextStyle(
              fontSize: 16,
              fontFamily: Fonts.fontSemiBold,
              color: appColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildSummaryRow(
            'Subtotal',
            '${Keys.inr}${(widget.order.finalAmount ?? 0).toStringAsFixed(2)}',
          ),
          SizedBox(height: 12),
          Container(height: 1, color: appColors.divider),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: commonTextStyle(
                  fontSize: 16,
                  fontFamily: Fonts.fontBold,
                  color: appColors.textPrimary,
                ),
              ),
              Text(
                '${Keys.inr}${(widget.order.finalAmount ?? 0).toStringAsFixed(2)}',
                style: commonTextStyle(
                  fontSize: 18,
                  fontFamily: Fonts.fontBold,
                  color: appColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: commonTextStyle(fontSize: 14, color: appColors.textSecondary),
        ),
        Text(
          value,
          style: commonTextStyle(
            fontSize: 14,
            fontFamily: Fonts.fontMedium,
            color: appColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
