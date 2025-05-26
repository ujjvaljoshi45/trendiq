import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/generated/assets.dart';
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

Widget bottomBarTab({
  required Widget icon,
  required String label,
  void Function()? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Column(
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
    ),
  );
}

Widget shopByCategoryButton() {
  return InkWell(
    onTap:
        () => ToastService().showToast(
          "Coming Soon",
          isInformation: true,
          seconds: 200,
        ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: appColors.primary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Explore Categories',
            style: commonTextStyle(
              fontSize: 14,
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

Widget appLogoWidget() {
  return Center(
    child: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: appColors.primary),
        shape: BoxShape.circle,
      ),
      child: Center(child: Image.asset(Assets.assetsLogo)),
    ),
  );
}

Widget passwordTextForm({
  required TextEditingController passwordController,
  required bool obscurePassword,
  required void Function() onPressed,
  FormFieldValidator<String?>? validator,
  String? hintText,
}) {
  return TextFormField(
    controller: passwordController,
    obscureText: obscurePassword,
    cursorColor: appColors.primary,
    style: commonTextStyle(
      fontSize: 16,
      color: appColors.onBackground,
      fontFamily: Fonts.fontRegular,
    ),
    decoration: textFieldInputDecoration(
      hintText: hintText ?? "Enter your password",
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: appColors.onBackground.withOpacity(0.6),
        ),
        onPressed: onPressed,
      ),
    ),
    validator:
        validator ??
        (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your password";
          }
          if (value.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
  );
}

InputDecoration textFieldInputDecoration({
  required String hintText,
  IconData? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: commonTextStyle(
      color: appColors.onBackground.withOpacity(0.5),
      fontFamily: Fonts.fontRegular,
    ),
    prefixIcon:
        prefixIcon != null
            ? Icon(prefixIcon, color: appColors.onBackground.withOpacity(0.6))
            : null,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: appColors.surfaceVariant,
    contentPadding:
        prefixIcon != null ? const EdgeInsets.symmetric(vertical: 16) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: appColors.error, width: 1.5),
    ),
  );
}

Widget buildInputLabel(String label, {double? size}) {
  return Text(
    label,
    style: commonTextStyle(
      fontSize: size ?? 14,
      fontWeight: FontWeight.w500,
      color: appColors.onBackground,
      fontFamily: Fonts.fontMedium,
    ),
  );
}

Widget buildSocialButton(
  IconData icon,
  String platform,
  void Function() onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.outline),
      ),
      child: Center(
        child: Icon(
          icon,
          size: platform == "Google" ? 32 : 28,
          color:
              platform == "Google"
                  ? Colors.redAccent
                  : platform == "Facebook"
                  ? Colors.blue
                  : appColors.onBackground,
        ),
      ),
    ),
  );
}

Widget orContinueWithDivider() => Row(
  children: [
    Expanded(child: Divider(color: appColors.outline, thickness: 1)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Or continue with",
        style: commonTextStyle(
          fontSize: 14,
          color: appColors.onBackground.withOpacity(0.6),
          fontFamily: Fonts.fontRegular,
        ),
      ),
    ),
    Expanded(child: Divider(color: appColors.outline, thickness: 1)),
  ],
);
