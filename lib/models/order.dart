class Order {
  Order({
    required this.orderId,
    required this.finalAmount,
    required this.createdAt,
    required this.status,
    required this.address,
    required this.products,
  });

  final String? orderId;
  final String? finalAmount;
  final DateTime? createdAt;
  final String? status;
  final OrderAddress? address;
  final List<OrderProduct> products;

  static List<Order> getOrderList(Map<String, dynamic> jsonArray) {
    List<Order> order = [];
    for (Map<String, dynamic> data in jsonArray["data"]) {
      order.add(Order.fromJson(data));
    }
    return order;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json["orderId"]?.toString(),
      finalAmount: json["finalAmount"]?.toString(),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      status: json["status"]?.toString(),
      address:
          json["address"] == null
              ? null
              : OrderAddress.fromJson(json["address"]),
      products:
          json["products"] == null
              ? []
              : List<OrderProduct>.from(
                json["products"]!.map((x) => OrderProduct.fromJson(x)),
              ),
    );
  }
}

class OrderAddress {
  OrderAddress({required this.address, required this.name});

  final String? address;
  final String? name;

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(address: json["address"], name: json["name"]);
  }
}

class OrderProduct {
  OrderProduct({
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.color,
    required this.id,
  });

  final OrderProductSize? size;
  final String? price;
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? color;
  final String id;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      size:
          json["size"] == null ? null : OrderProductSize.fromJson(json["size"]),
      price: json["price"]?.toString(),
      imageUrl: json["imageUrl"]?.toString(),
      title: json["title"]?.toString(),
      description: json["description"]?.toString(),
      color: json["color"]?.toString(),
      id: json["id"].toString(),
    );
  }
}

class OrderProductSize {
  OrderProductSize({required this.name});

  final String? name;

  factory OrderProductSize.fromJson(Map<String, dynamic> json) {
    return OrderProductSize(name: json["name"]?.toString());
  }
}
