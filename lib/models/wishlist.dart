class Wishlist {
  final String id;
  final String productId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductMetadata? products;

  Wishlist({
    required this.id,
    required this.productId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      products:
          json['product'] == null
              ? null
              : ProductMetadata.fromJson(json['product']),
    );
  }
}

class ProductMetadata {
  final String id;
  final String title;
  final String description;
  final String markupDescription;
  final String categoryId;
  final String color;
  final String gender;
  final bool isTrending;
  final String adminId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String publicId;
  final String imageUrl;

  ProductMetadata({
    required this.id,
    required this.title,
    required this.description,
    required this.markupDescription,
    required this.categoryId,
    required this.color,
    required this.gender,
    required this.isTrending,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
    required this.publicId,
    required this.imageUrl,
  });

  factory ProductMetadata.fromJson(Map<String, dynamic> json) =>
      ProductMetadata(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        markupDescription: json["markupDescription"],
        categoryId: json["categoryId"],
        color: json["color"],
        gender: json["gender"],
        isTrending: json["isTrending"],
        adminId: json["adminId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publicId: json["publicId"],
        imageUrl: json["imageUrl"],
      );
}
