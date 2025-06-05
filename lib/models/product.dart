part 'category.dart';

part 'product_inventory.dart';

part 'wishlist.dart';

class Product {
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
  final Category category;
  final List<ProductImage> productImages;
  final List<ProductInventory> productInventory;
  final List<Wishlist> wishlist;
  final List<AvailableColor> availableColors;

  Product({
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
    required this.category,
    required this.productInventory,
    required this.wishlist,
    required this.productImages,
    required this.availableColors,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    category: Category.fromJson(json["category"]),
    productInventory: List<ProductInventory>.from(
      (json["product_inventory"] ?? []).map(
        (x) => ProductInventory.fromJson(x),
      ),
    ),
    wishlist: List<Wishlist>.from(
      (json["wishlist"] ?? []).map((x) => Wishlist.fromJson(x)),
    ),
    availableColors: List<AvailableColor>.from(
      (json["availableColors"] ?? []).map((e) => AvailableColor.fromJson(e)),
    ),
    productImages: List<ProductImage>.from(
      (json["product_images"] ?? []).map((e) => ProductImage.fromJson(e)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "markupDescription": markupDescription,
    "categoryId": categoryId,
    "color": color,
    "gender": gender,
    "isTrending": isTrending,
    "adminId": adminId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "publicId": publicId,
    "imageUrl": imageUrl,
    "category": category.toJson(),
    "product_inventory": List<dynamic>.from(
      productInventory.map((x) => x.toJson()),
    ),
    "wishlist": List<dynamic>.from(wishlist.map((x) => x.toJson())),
  };

  factory Product.dummy() => Product(
    id: '-1',
    title: '',
    description: '',
    markupDescription: '',
    categoryId: '',
    color: '',
    gender: '',
    isTrending: false,
    adminId: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    publicId: '',
    imageUrl: '',
    category: Category(
      id: '',
      name: '',
      description: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      publicId: '',
      imageUrl: '',
      gender: '',
    ),
    productInventory: [],
    wishlist: [],
    productImages: [],
    availableColors: [],
  );
}

class AvailableColor {
  final String id;
  final String color;
  final String imageUrl;

  AvailableColor({
    required this.id,
    required this.color,
    required this.imageUrl,
  });

  factory AvailableColor.fromJson(Map<String, dynamic> json) => AvailableColor(
    id: json["id"],
    color: json["color"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "color": color,
    "imageUrl": imageUrl,
  };
}

class ProductImage {
  final String id;
  final String imageUrl;
  final String publicId;
  final String productId;

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.publicId,
    required this.productId,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json["id"],
    imageUrl: json["imageUrl"],
    publicId: json["publicId"],
    productId: json["productId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imageUrl": imageUrl,
    "publicId": publicId,
    "productId": productId,
  };
}
