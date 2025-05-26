class ProductCategoryModel {
  int? statusCode;
  String? message;
  List<Datum>? data;

  ProductCategoryModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory ProductCategoryModel.dummy() => ProductCategoryModel(
    data: [Datum(
      gender: null,
      createdAt: null,
      updatedAt: null,
      description: null,
      id: null,
      imageUrl: 'https://placehold.co/300x300.png',
      name: "-",
      publicId: null

    )],
    message: "Loading",
    statusCode: -1
  );

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? publicId;
  String? imageUrl;
  String? gender;

  Datum({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.publicId,
    this.imageUrl,
    this.gender,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publicId: json["publicId"],
    imageUrl: json["imageUrl"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publicId": publicId,
    "imageUrl": imageUrl,
    "gender": gender,
  };
}
