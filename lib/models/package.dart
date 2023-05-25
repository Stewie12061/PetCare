import 'dart:convert';
class Package {
  final int id;
  final String name;
  final int service;
  final double price;

  Package({
    required this.id,
    required this.name,
    required this.service,
    required this.price,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json["id"],
    name: json["name"],
    service: json["service"] != null ? int.parse(json["service"].toString()) : 0,
    price: json["price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "service": service,
    "price": price,
  };
}
