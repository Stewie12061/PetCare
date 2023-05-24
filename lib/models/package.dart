import 'dart:convert';

List<Package> packageFromJson(String str) => List<Package>.from(json.decode(str).map((x) => Package.fromJson(x)));

String packageToJson(List<Package> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Package {
  Package({
    required this.name,
    required this.service,
    required this.price,
  });

  final String name;
  final int service;
  final double price;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
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
