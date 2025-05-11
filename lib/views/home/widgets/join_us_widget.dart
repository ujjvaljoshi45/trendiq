import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';

class JoinUsWidget extends StatelessWidget {
  const JoinUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Join Our Rebel Team",
            style: commonTextStyle(
              fontSize: 18,
              fontFamily: Fonts.fontSemiBold,
              color: appColors.primary,
            ),
          ),
          2.sBh,
          Text(
            "Are you passionate about fashion and want to be part of a dynamic, innovative team? We're always looking for talented individuals to join our fashion revolution.",
            textAlign: TextAlign.center,
            style: commonTextStyle(
              fontSize: 14,
              fontFamily: Fonts.fontMedium,
              color: appColors.onTertiary,
            ),
          ),
          2.sBh,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "View Open Positions",
              style: commonTextStyle(
                fontFamily: Fonts.fontSemiBold,
                fontSize: 14,
                color: appColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
