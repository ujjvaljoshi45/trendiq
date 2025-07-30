import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/models/cart.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/views/cart/bloc/cart_bloc.dart';

import '../../../services/app_colors.dart';

class CartAddressCard extends StatelessWidget {
  final List<Address> addresses;
  final void Function(int index) onAddressChange;
  final int selectedAddressIndex;

  const CartAddressCard({
    super.key,
    required this.addresses,
    required this.onAddressChange,
    required this.selectedAddressIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = appColors.isDark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appColors.cardBg, appColors.surface],
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
        border: Border.all(color: appColors.borderColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            addresses.isEmpty
                ? _buildEmptyAddress(context)
                : _buildAddressContent(context),
      ),
    );
  }

  Widget _buildEmptyAddress(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RoutesKey.address).whenComplete(() {
              onAddressChange(0);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Please Add Address to continue", style: commonTextStyle()),
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressContent(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.location_on,
                color: appColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Delivery Address",
              style: commonTextStyle().copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: appColors.onTertiaryContainer,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: appColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () => showAddressSelectionModal(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: appColors.primary.withOpacity(0.05),
                ),
                child: Text(
                  "Change",
                  style: commonTextStyle().copyWith(
                    color: appColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appColors.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 0.5),
          ),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addresses[selectedAddressIndex].name ?? "Unknown",
                style: commonTextStyle().copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.place_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "${addresses[selectedAddressIndex].address ?? ""} - ${addresses[selectedAddressIndex].pincode ?? ""}",
                      style: commonTextStyle().copyWith(
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showAddressSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Addresses',
                      style: commonTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                for (int i = 0; i < addresses.length; i++)
                  _buildAddressCard(context, addresses[i], i),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              index == selectedAddressIndex
                  ? appColors.primary.withValues(alpha: 0.4)
                  : appColors.mediumGrey,
          width: index == selectedAddressIndex ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name ?? "",
                      style: commonTextStyle(
                        fontSize: 18,
                        fontFamily: Fonts.fontSemiBold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    4.sBh,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "PIN: ${address.pincode}",
                        style: commonTextStyle(
                          fontSize: 12,
                          fontFamily: Fonts.fontMedium,
                          color: appColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.sBw,
              Checkbox(
                value: selectedAddressIndex == index,
                shape: CircleBorder(),
                onChanged: (value) {
                  BlocProvider.of<CartBloc>(
                    context,
                  ).add(CartAddressUpdateEvent(newIndex: index));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          16.sBh,
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                8.sBw,
                Expanded(
                  child: Text(
                    address.address ?? "",
                    style: commonTextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
