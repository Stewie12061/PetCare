import 'dart:convert';

import 'package:pet_care/models/category_model.dart';
import 'package:pet_care/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Utilities {
  String url = "http://10.0.2.2:8080/api/v1/";
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

  Future<List<CategoryModel>> getCategories() async {
    Uri uri = Uri.parse("${url}categories/all");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
  Future<List<ProductModel>> getAllProductsForCategory(CategoryModel category) async {
    Uri uri = Uri.parse("${url}product/category/${category.id.toString()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch products for category');
    }
    return [];
  }
  Future<List<ProductModel>> getDogProductsForCategory(CategoryModel category) async {
    Uri uri = Uri.parse("${url}product/dog/category/${category.id.toString()}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch products for category');
    }
    return [];
  }
  Future<List<ProductModel>> getCatProductsForCategory(CategoryModel category) async {
    Uri uri = Uri.parse("${url}product/cat/category/${category.id.toString()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch products for category');
    }
    return [];
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    String url = 'http://10.0.2.2:8080/api/v1/product/';
    Uri uri = Uri.parse("${url}search?query=$query");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    // Make API request to the backend and retrieve search results
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch products for category');
    }

  }

}
