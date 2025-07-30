import 'package:flutter/material.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/models/cart.dart';
import 'package:trendiq/services/app_colors.dart';

class CartSummaryCard extends StatelessWidget {
  final CartSummary? cartSummary;

  const CartSummaryCard({
    super.key,
    required this.cartSummary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.cardBg,
            appColors.surface,
          ]
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: appColors.shadow.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: appColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: commonTextStyle(
                fontSize: 18,
                fontFamily: Fonts.fontMedium,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow("Subtotal", cartSummary?.amount, context: context),
            _buildSummaryRow("Discount", cartSummary?.discount, color: Colors.green, fontFamily: Fonts.fontSemiBold, context: context),
            _buildSummaryRow("Tax (CGST + SGST)", cartSummary?.gst, context: context),
            Divider(height: 24, color: appColors.mediumGrey),
            _buildSummaryRow(
              "Order Total",
              cartSummary?.finalAmount,
              isTotal: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, dynamic value, {bool isTotal = false, Color? color, String? fontFamily, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: commonTextStyle(
              fontSize: isTotal ? 16 : 14,
              fontFamily: fontFamily ?? (isTotal ? Fonts.fontMedium : Fonts.fontRegular),
            ),
          ),
          commonPriceTag(
            price: value?.toString() ?? "-",
            fontSize: isTotal ? 16 : 14,
            fontStyle: isTotal ? Fonts.fontMedium : Fonts.fontRegular,
            fontColor: color,
          )
        ],
      ),
    );
  }
}