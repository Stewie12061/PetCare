import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/product_model.dart';
import '../provider/favorite_provider.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    fetchFavoriteProducts();
  }

  Future<void> fetchFavoriteProducts() async {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    await favoriteProvider.fetchFavoriteProducts();
  }

  Future<void> removeFromFavorites(ProductModel productModel) async {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    await favoriteProvider.removeFromFavorites(productModel);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, _) {
        List<ProductModel> favoriteProducts = favoriteProvider.favoriteProducts;
        return Scaffold(
          body: ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ListTile(
                leading: Image.asset(
                  'assets/products/${product.image}',
                  width: 50,
                  height: 50,
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    removeFromFavorites(product);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
