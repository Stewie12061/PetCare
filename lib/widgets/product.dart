import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:pet_care/const.dart';

import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/favorite_provider.dart';
import '../utils/styles.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;

  const ProductItem({
    Key? key,
    required this.product, required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3 + 55,
          width: MediaQuery.of(context).size.width * 0.5 - 30,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3 + 10,
                  width: MediaQuery.of(context).size.width * 0.5 - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(3, 3),
                            color: black.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 5)
                      ]),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 50,
                            left: 20,
                            right: 20,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                BoxShadow(
                                    offset: Offset.zero,
                                    color: Color(0xFF42A5F5),
                                    spreadRadius: 10,
                                    blurRadius: 20)
                              ]),
                            ),
                          ),

                          Image.asset(
                            'assets/products/${product.image}',
                            height: 180,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      product.name,
                      style: poppin.copyWith(
                          fontSize: 16, color: black, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '\$${(product.price).toStringAsFixed(2)}',
                      style: poppin.copyWith(
                          fontSize: 18, color: black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    cartProvider.addCart(product, 1);
                    Fluttertoast.showToast(
                      msg: 'Add ${product.name} to cart',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Styles.highlightColor,
                      textColor: Colors.white,
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration:
                          const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '+',
                          style: poppin.copyWith(
                              color: white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                ),
              ),
              Positioned(
                top: 0,
                left: 110,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    if (isFavorite) {
                      favoriteProvider.removeFromFavorites(product);
                    } else {
                      favoriteProvider.addToFavorites(product);
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: Icon(
                          isFavorite ? Icons.favorite: Icons.favorite_border ,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                  )
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
