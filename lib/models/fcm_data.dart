import 'dart:convert';

import 'package:trendiq/constants/keys.dart';

class FcmData {
  String token;
  DateTime createdAt;

  FcmData({required this.token, required this.createdAt});

  factory FcmData.fromString(String data) {
    final json = jsonDecode(data);
    return FcmData(
      token: json[Keys.token],
      createdAt: DateTime.parse(json[Keys.createdAt]),
    );
  }

  Map<String, dynamic> toJson() => {
    Keys.token: token,
    Keys.createdAt: createdAt.toIso8601String(),
  };
  @override
  String toString() => jsonEncode(toJson());
}
