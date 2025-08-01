class UserModel {
  String id;
  String username;
  String email;
  String password;
  String token;
  dynamic profile;
  DateTime createdAt;
  DateTime updatedAt;
  bool isVerified;
  String? orderCount;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.token,
    required this.profile,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    required this.orderCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    token: "",
    profile: json["profile"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    isVerified: json["isVerified"],
    orderCount: json["orderCount"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "token": token,
    "profile": profile,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "isVerified": isVerified,
  };
}
