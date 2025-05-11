import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

Widget commonPriceTag({
  int spacingW = 5,
  required String price,
  int spacingC = 5,
  String? strikeOutPrice,
  double fontSize = 12,
  Color fontColor = Colors.black,
  String? fontStyle,
  double strikePriceSize = 10,
}) {
  return Row(
    children: [
      Text(
        Keys.inr,
        style: commonTextStyle(fontFamily: fontStyle ?? Fonts.fontMedium),
      ),
      spacingW.sBw,
      Text(
        price,
        style: commonTextStyle(fontFamily: fontStyle ?? Fonts.fontMedium),
      ),
      if (strikeOutPrice != null) ...[
        spacingC.sBw,
        Text(
          strikeOutPrice.toString(),
          style: commonTextStyle(
            fontSize: strikePriceSize,
          ).copyWith(decoration: TextDecoration.lineThrough),
        ),
      ],
    ],
  );
}

Widget loadingIndicator() {
  return CircularProgressIndicator.adaptive(
    backgroundColor: appColors.white,
    valueColor: AlwaysStoppedAnimation<Color>(appColors.onPrimary),
  );
}

Widget bottomBarTab({required Widget icon, required String label}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(child: icon),
      6.sBh,
      Text(
        label,
        style: commonTextStyle(fontSize: 8, fontFamily: Fonts.fontSemiBold),
      ),
    ],
  );
}

Widget shopByCategoryButton() {
  return InkWell(
    onTap: () => ToastService().showToast("Coming Soon",isInformation: true,seconds: 200),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: appColors.primary.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Shop By Category',
            style: commonTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: appColors.white,
            size: 20.0,
          ),
        ],
      ),
    ),
  );
}