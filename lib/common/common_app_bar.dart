import 'package:flutter/material.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? appColors.surface,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        color: titleColor,
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,
      title: Text(
        title,
        style: commonTextStyle(
          color: titleColor ?? MyColors.primaryColor,
          fontFamily: Fonts.fontSemiBold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
