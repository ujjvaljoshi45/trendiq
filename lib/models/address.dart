class Address {
  final String id;
  final String name;
  final String pincode;
  final String address;
  final String userId;
  final bool isDeleted;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.name,
    required this.pincode,
    required this.address,
    required this.userId,
    required this.isDeleted,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      pincode: json['pincode'],
      address: json['address'],
      userId: json['userId'],
      isDeleted: json['isDeleted'],
      isDefault: json['isDefault'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pincode': pincode,
      'address': address,
      'userId': userId,
      'isDeleted': isDeleted,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
