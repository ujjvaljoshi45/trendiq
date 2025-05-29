import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_state.dart';

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
    return BlocBuilder<ThemeBloc,ThemeState>(builder: (context, state) {
      return AppBar(
        backgroundColor: backgroundColor ?? appColors.surface,
        elevation: elevation,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,color: appColors.onSecondary,),
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
        centerTitle: false,
        actions: actions,
      );
    },);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
