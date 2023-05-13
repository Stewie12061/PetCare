import 'dart:convert';

import 'package:pet_care/models/category_model.dart';
import 'package:pet_care/models/product_model.dart';
import 'package:http/http.dart' as http;

class Utilities {
  String url = "http://10.0.2.2:3000/api/";
  static Utilities? _instance;
  List<ProductModel> data = [];

  factory Utilities() {
    _instance ??= Utilities._internal();
    return _instance!;
  }

  Utilities._internal();

  Utilities._();

  Future<List<ProductModel>> getProducts() async {
    var res = await http.get(Uri.parse("${url}foods"));
    if (res.statusCode == 200) {
      var content = res.body;
      var arr = json.decode(content)['food'];
      if (arr != null) {
        return (arr as List).map((e) => ProductModel.fromJson(e)).toList();
      }
    }
    return [];
  }
  Future<List<CategoryModel>> getCate() async {
    var resCate = await http.get(Uri.parse("${url}categories"));
    if (resCate.statusCode == 200) {
      var content = resCate.body;
      var arr = json.decode(content)['category'];
      if (arr != null) {
        return (arr as List).map((e) => CategoryModel.fromJson(e)).toList();
      }
    }
    return [];
  }
  Future<List<ProductModel>> getFavorites() async {
    var resFav = await http.get(Uri.parse("${url}foods/favorite"));
    if (resFav.statusCode == 200) {
      var content = resFav.body;
      var arr = json.decode(content)['favorite'];
      if (arr != null) {
        return (arr as List).map((e) => ProductModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  Future<void> addProductToFavorites(ProductModel product) async {
    var res = await http.post(
      Uri.parse("${url}foods/${product.id}/favorite"),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update product.');
    }
  }

  Future<void> removeProductFromFavorites(ProductModel product) async {
    var res = await http.post(
      Uri.parse("${url}foods/${product.id}/unfavorite"),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update product.');
    }
  }

}
