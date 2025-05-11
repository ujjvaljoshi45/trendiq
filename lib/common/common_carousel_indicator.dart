import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class CommonCarouselIndicator extends StatelessWidget {
  const CommonCarouselIndicator({
    super.key,
    required this.length,
    required this.controller,
  });
  final int length;
  final ValueNotifier<int> controller;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (_,value,___) {
        return Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < length; i++)
              AnimatedContainer(
                height: 5,
                width: value == i ? 16 : 5,
                margin: EdgeInsets.symmetric(horizontal: 3),
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color:
                  value == i
                      ? context.theme.primaryColor
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
          ],
        );
      },
    );
  }
}