import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  bool _isLoading = false;

  List<CartModel> get carts => _carts;
  bool get isLoading => _isLoading;


  // set carts(List<CartModel> carts) {
  //   _carts = carts;
  //   notifyListeners();
  // }
  Future<void> initialize() async {
    await fetchCartItems();
  }

  Future<void> addCart(ProductModel product, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/carts/add");
    final response = await http.post(
      uri,
      body: json.encode({
        'productId': product.id,
        'productQuantity': quantity,
      }),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json", // Set the content type to JSON
      },
    );

    if (response.statusCode == 200) {
      // Add cart item locally
      if (productExist(product)) {
        int index =
        _carts.indexWhere((element) => element.product!.id == product.id);
        _carts[index].quantity = _carts[index].quantity! + quantity;
      } else {
        _carts.add(
            CartModel(id: _carts.length, product: product, quantity: quantity));
      }
      notifyListeners();
    }
  }
  productExist(ProductModel product) {
    if (_carts.indexWhere((element) => element.product!.id == product.id) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> removeCart(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/carts/$id");
    final response = await http.delete(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      // Remove cart item locally
      _carts.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }

  Future<void> removeAllItemsCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/carts/removeAll");
    final response = await http.delete(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      // Remove cart item locally
      _carts.clear();
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    _isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/carts");
    final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      _carts = responseData.map((item) => CartModel.fromJson(item)).toList();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<double> totalPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    Uri uri = Uri.parse("http://10.0.2.2:8080/api/v1/product/users/$userId/carts/total-price");
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to get total price.');
    }
  }



}
