class Cart {
  Cart({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.addresses,
    required this.cartSummary,
  });

  final int? statusCode;
  final String? message;
  final List<Datum> data;
  final List<Address> addresses;
  final CartSummary? cartSummary;
  int selectedCartAddress = 0;

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      statusCode: json["statusCode"],
      message: json["message"],
      data:
          json["data"] == null
              ? []
              : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      addresses:
          json["addresses"] == null
              ? []
              : List<Address>.from(
                json["addresses"]!.map((x) => Address.fromJson(x)),
              ),
      cartSummary:
          json["cartSummary"] == null
              ? null
              : CartSummary.fromJson(json["cartSummary"]),
    );
  }

  factory Cart.dummy() {
    return Cart(
      statusCode: 200,
      message: "Success",
      data: [Datum.dummy()],
      addresses: [Address.dummy()],
      cartSummary: CartSummary.dummy(),
    );
  }
}

class Address {
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

  final String? id;
  final String? name;
  final String? pincode;
  final String? address;
  final String? userId;
  final bool? isDeleted;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      name: json["name"],
      pincode: json["pincode"],
      address: json["address"],
      userId: json["userId"],
      isDeleted: json["isDeleted"],
      isDefault: json["isDefault"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  factory Address.dummy() {
    return Address(
      id: "addr-1",
      name: "John Doe",
      pincode: "123456",
      address: "123, Dummy Street, City",
      userId: "user-1",
      isDeleted: false,
      isDefault: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class CartSummary {
  CartSummary({
    required this.amount,
    required this.discount,
    required this.finalAmount,
    required this.gst,
  });

  final int? amount;
  final int? discount;
  final int? finalAmount;
  final int? gst;

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      amount: json["amount"],
      discount: json["discount"],
      finalAmount: json["finalAmount"],
      gst: json["gst"],
    );
  }

  factory CartSummary.dummy() {
    return CartSummary(amount: 1500, discount: 200, finalAmount: 1300, gst: 50);
  }
}

class Datum {
  Datum({
    required this.id,
    required this.productId,
    required this.userId,
    required this.quantity,
    required this.productInventoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.productInventory,
  });

  final String? id;
  final String? productId;
  final String? userId;
  final int? quantity;
  final String? productInventoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;
  final ProductInventory? productInventory;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      productId: json["productId"],
      userId: json["userId"],
      quantity: json["quantity"],
      productInventoryId: json["product_inventoryId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      product:
          json["product"] == null ? null : Product.fromJson(json["product"]),
      productInventory:
          json["product_inventory"] == null
              ? null
              : ProductInventory.fromJson(json["product_inventory"]),
    );
  }
  factory Datum.dummy() {
    return Datum(
      id: "item-1",
      productId: "prod-1",
      userId: "user-1",
      quantity: 2,
      productInventoryId: "inv-1",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      product: Product.dummy(),
      productInventory: ProductInventory.dummy(),
    );
  }
}

class Product {
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
  });

  final String? id;
  final String? title;
  final String? description;
  final String? markupDescription;
  final String? categoryId;
  final String? color;
  final String? gender;
  final bool? isTrending;
  final String? adminId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? publicId;
  final String? imageUrl;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      markupDescription: json["markupDescription"],
      categoryId: json["categoryId"],
      color: json["color"],
      gender: json["gender"],
      isTrending: json["isTrending"],
      adminId: json["adminId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      publicId: json["publicId"],
      imageUrl: json["imageUrl"],
    );
  }

  factory Product.dummy() {
    return Product(
      id: "prod-1",
      title: "Dummy T-Shirt",
      description: "A dummy product used for testing",
      markupDescription: "<p>Dummy T-Shirt</p>",
      categoryId: "cat-1",
      color: "Blue",
      gender: "Unisex",
      isTrending: true,
      adminId: "admin-1",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      publicId: "public-id",
      imageUrl: "https://dummyimage.com/600x400/000/fff",
    );
  }
}

class ProductInventory {
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

  final String? id;
  final String? sizeId;
  final String? productId;
  final int? price;
  final int? stock;
  final int? minimumStock;
  final int? discount;
  final ItemSize? size;

  factory ProductInventory.fromJson(Map<String, dynamic> json) {
    return ProductInventory(
      id: json["id"],
      sizeId: json["sizeId"],
      productId: json["productId"],
      price: json["price"],
      stock: json["stock"],
      minimumStock: json["minimum_stock"],
      discount: json["discount"],
      size: json["size"] == null ? null : ItemSize.fromJson(json["size"]),
    );
  }

  factory ProductInventory.dummy() {
    return ProductInventory(
      id: "inv-1",
      sizeId: "size-1",
      productId: "prod-1",
      price: 750,
      stock: 20,
      minimumStock: 5,
      discount: 10,
      size: ItemSize.dummy(),
    );
  }
}

class ItemSize {
  ItemSize({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ItemSize.fromJson(Map<String, dynamic> json) {
    return ItemSize(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      categoryId: json["categoryId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
  factory ItemSize.dummy() {
    return ItemSize(
      id: "size-1",
      name: "M",
      description: "Medium Size",
      categoryId: "cat-1",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
