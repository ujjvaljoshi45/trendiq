class TrendingProductsModel {
  int statusCode;
  List<Datum> data;
  List<Banner> banner;
  String message;

  TrendingProductsModel({
    required this.statusCode,
    required this.data,
    required this.banner,
    required this.message,
  });

  factory TrendingProductsModel.fromJson(Map<String, dynamic> json) =>
      TrendingProductsModel(
        statusCode: json["statusCode"] ?? 0,
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        banner:
            json["banner"] == null
                ? []
                : List<Banner>.from(
                  json["banner"].map((x) => Banner.fromJson(x)),
                ),
        message: json["message"] ?? "-",
      );

  factory TrendingProductsModel.dummy() => TrendingProductsModel(
    statusCode: 200,
    message: "loading",
    banner: List.generate(
      3,
      (index) => Banner(
        id: '',
        mobileImage: 'https://placehold.co/300x400.png',
        // This is important
        defaultImage: 'https://placehold.co/300x400.png',
        mobilePublicId: '',
        defaultPublicId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        gender: '',
      ),
    ),
    data: List.generate(
      3,
      (index) => Datum(
        id: '',
        title: '',
        description: '',
        markupDescription: '',
        categoryId: '',
        color: '',
        gender: '',
        isTrending: true,
        adminId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        publicId: '',
        imageUrl: 'https://placehold.co/300x400.png',
        // Important
        productInventory: [],
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
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
    "message": message,
  };
}

class Banner {
  String id;
  String mobileImage;
  String defaultImage;
  String mobilePublicId;
  String defaultPublicId;
  DateTime createdAt;
  DateTime updatedAt;
  String gender;

  Banner({
    required this.id,
    required this.mobileImage,
    required this.defaultImage,
    required this.mobilePublicId,
    required this.defaultPublicId,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    mobileImage: json["mobileImage"],
    defaultImage: json["defaultImage"],
    mobilePublicId: json["mobilePublicId"],
    defaultPublicId: json["defaultPublicId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobileImage": mobileImage,
    "defaultImage": defaultImage,
    "mobilePublicId": mobilePublicId,
    "defaultPublicId": defaultPublicId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "gender": gender,
  };
}

class Datum {
  String id;
  String title;
  String description;
  String markupDescription;
  String categoryId;
  String color;
  String gender;
  bool isTrending;
  String adminId;
  DateTime createdAt;
  DateTime updatedAt;
  String publicId;
  String imageUrl;
  List<ProductInventory> productInventory;
  Category category;

  Datum({
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
    required this.productInventory,
    required this.category,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? "-",
    title: json["title"] ?? "-",
    description: json["description"] ?? "-",
    markupDescription: json["markupDescription"] ?? "-",
    categoryId: json["categoryId"] ?? "-",
    color: json["color"] ?? "-",
    gender: json["gender"] ?? "-",
    isTrending: json["isTrending"] ?? "-",
    adminId: json["adminId"] ?? "-",
    createdAt: DateTime.parse(json["createdAt"] ?? "-"),
    updatedAt: DateTime.parse(json["updatedAt"] ?? "-"),
    publicId: json["publicId"] ?? "-",
    imageUrl: json["imageUrl"] ?? "-",
    productInventory:
        json["product_inventory"] == null
            ? []
            : List<ProductInventory>.from(
              json["product_inventory"].map(
                (x) => ProductInventory.fromJson(x),
              ),
            ),
    category: Category.fromJson(json["category"]),
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
    "product_inventory": List<dynamic>.from(
      productInventory.map((x) => x.toJson()),
    ),
    "category": category.toJson(),
  };
}

class Category {
  String id;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  String publicId;
  String imageUrl;
  String gender;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publicId,
    required this.imageUrl,
    required this.gender,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? "-",
    name: json["name"] ?? "-",
    description: json["description"] ?? "-",
    createdAt: DateTime.parse(json["createdAt"] ?? "-"),
    updatedAt: DateTime.parse(json["updatedAt"] ?? "-"),
    publicId: json["publicId"] ?? "-",
    imageUrl: json["imageUrl"] ?? "-",
    gender: json["gender"] ?? "-",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "publicId": publicId,
    "imageUrl": imageUrl,
    "gender": gender,
  };
}

class ProductInventory {
  String id;
  String sizeId;
  String productId;
  int price;
  int stock;
  int minimumStock;
  int discount;

  ProductInventory({
    required this.id,
    required this.sizeId,
    required this.productId,
    required this.price,
    required this.stock,
    required this.minimumStock,
    required this.discount,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) =>
      ProductInventory(
        id: json["id"] ?? "-",
        sizeId: json["sizeId"] ?? "-",
        productId: json["productId"] ?? "-",
        price: json["price"] ?? 0,
        stock: json["stock"] ?? 0,
        minimumStock: json["minimum_stock"] ?? 0,
        discount: json["discount"] ?? 0,
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
