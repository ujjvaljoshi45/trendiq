part of 'product.dart';
class ProductInventory {
  final String id;
  final String sizeId;
  final String productId;
  final int price;
  final int stock;
  final int minimumStock;
  final int discount;

  ProductInventory({
    required this.id,
    required this.sizeId,
    required this.productId,
    required this.price,
    required this.stock,
    required this.minimumStock,
    required this.discount,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) => ProductInventory(
    id: json["id"],
    sizeId: json["sizeId"],
    productId: json["productId"],
    price: json["price"],
    stock: json["stock"],
    minimumStock: json["minimum_stock"],
    discount: json["discount"],
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