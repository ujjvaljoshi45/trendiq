import 'package:flutter/widgets.dart';

extension SizeBox on num {
  SizedBox get sBh => SizedBox(height: toDouble());
  SizedBox get sBw => SizedBox(width: toDouble());
}
