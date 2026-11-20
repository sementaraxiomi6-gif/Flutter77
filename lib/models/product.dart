
import 'dart:convert';

class Product {
  final int? id;
  final String? name;
  final String? description;
  final int? price;
  final String? image;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromRawJson(String str) =>
      Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image: json["image"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "image": image,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
