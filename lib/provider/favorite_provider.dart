import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<ProductModel> _favoriteProducts = [];
  bool _isLoading = false;

  List<ProductModel> get favoriteProducts => _favoriteProducts;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await fetchFavoriteProducts();
  }

  Future<void> fetchFavoriteProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("jwtToken")!;
      String userId = prefs.getString("userId")!;
      Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/favorites");
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _favoriteProducts =  List<ProductModel>.from(jsonData.map((product) => ProductModel.fromJson(product)));
      } else {
        // Handle API error or empty response
        _favoriteProducts = [];
      }
    } catch (error) {
      // Handle network or other errors
      _favoriteProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isProductFavorite(int productId) {
    return _favoriteProducts.any((product) => product.id == productId);
  }

  Future<void> addToFavorites(ProductModel product) async {
    String productId = product.id.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/favorites/add");
    final response = await http.post(
      uri,
      body: jsonEncode({"productId": productId}), // Add the productId to the request body
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json", // Set the content type to JSON
      },
    );
    if (response.statusCode == 200) {
      // Add the product to the local list of favorite products
      _favoriteProducts.add(product);
      notifyListeners();
    } else {
      throw Exception('Failed to add to favorites');
    }

  }

  Future<void> removeFromFavorites(ProductModel product) async {
    String productId = product.id.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/favorites/$productId");
    final response = await http.delete(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      // Remove the product from the local list of favorite products
      _favoriteProducts.removeWhere((favoriteProduct) => favoriteProduct.id == product.id);
      notifyListeners();    } else {
      throw Exception('Failed to remove from favorites');
    }

  }


}
