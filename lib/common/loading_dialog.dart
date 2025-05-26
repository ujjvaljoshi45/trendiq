import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trendiq/generated/assets.dart';
import 'package:trendiq/services/app_colors.dart';

class LoadingDialog {
  static Completer<void>? _dialogCompleter;
  static bool get isShowing => _dialogCompleter != null && !_dialogCompleter!.isCompleted;

  static Future<void> show(BuildContext context, {String? message}) async {
    if (isShowing) return _dialogCompleter!.future;

    _dialogCompleter = Completer<void>();

    unawaited(showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: appColors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.assetsLoader),
              if (message != null) ...[
                SizedBox(height: 16),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    ).then((_) {
      if (!_dialogCompleter!.isCompleted) {
        _dialogCompleter!.complete();
      }
    }));

    return _dialogCompleter!.future;
  }

  static void hide(BuildContext context) {
    if (isShowing) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}