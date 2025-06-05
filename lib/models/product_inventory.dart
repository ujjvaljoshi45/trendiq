part of 'product.dart';

class ProductInventory {
  final String id;
  final String sizeId;
  final String productId;
  final int price;
  final int stock;
  final int minimumStock;
  final int discount;
  final Size size;

  ProductInventory({
    required this.id,
    required this.sizeId,
    required this.productId,
    required this.price,
    required this.stock,
    required this.minimumStock,
    required this.discount,
    required this.size,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) =>
      ProductInventory(
        id: json["id"],
        sizeId: json["sizeId"],
        productId: json["productId"],
        price: json["price"],
        stock: json["stock"],
        minimumStock: json["minimum_stock"],
        discount: json["discount"],
        size: json["size"] == null ? Size.dummy() : Size.fromJson(json["size"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sizeId": sizeId,
    "productId": productId,
    "price": price,
    "stock": stock,
    "minimum_stock": minimumStock,
    "discount": discount,
  };
}

class Size {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Size({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    categoryId: json["categoryId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  factory Size.dummy() => Size(
    id: "-",
    name: "-",
    description: "-",
    categoryId: "-",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "categoryId": categoryId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
