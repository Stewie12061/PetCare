import 'package:flutter/material.dart';

class ProductModel {
  String image, name, description, type;
  double price;
  int id, categoryId;

  ProductModel(
      {required this.price,
      required this.image,
      required this.id,
      required this.categoryId,
      required this.name,
      required this.description,
      required this.type});
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        description: json['description'],
        image: json['image'],
        categoryId: json['category_id'].toInt(),
        type: json['type']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
      'category': categoryId,
      'type': type,
    };
  }

  getColor(String color) {
    return Color(int.parse(color));
  }
}
