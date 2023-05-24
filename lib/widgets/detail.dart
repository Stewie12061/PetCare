import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/favorite_provider.dart';
import '../utils/styles.dart';

class DetailPage extends StatefulWidget {
  final ProductModel product;
  bool isFavorite;

  DetailPage({super.key, required this.product, required this.isFavorite});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: black.withOpacity(0.7),
            size: 18,
          ),
        ),
      ),
      backgroundColor: white,
      body:SingleChildScrollView(
        child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.5 - 10,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    right: MediaQuery.of(context).size.width * 0.2,
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF42A5F5),
                              offset: Offset.zero,
                              blurRadius: 100,
                              spreadRadius: 0)
                        ],
                      ),
                    ),
                  ),
                  Image.asset('assets/products/${widget.product.image}'),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: poppin.copyWith(
                      fontSize: 18, color: black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.product.description,
                  maxLines: 4,
                  style: poppin.copyWith(
                      height: 1.5, fontSize: 14, color: black.withOpacity(0.5)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                });
                              },
                              child: const Icon(Icons.remove, color: grey)),
                          const SizedBox(width: 20),
                          Text(
                            '$quantity',
                            style: poppin,
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(quantity<10){
                                    quantity++;
                                  }
                                });
                              },
                              child: const Icon(Icons.add, color: grey)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${(quantity * widget.product.price).toStringAsFixed(2)}',
                      style: poppin.copyWith(
                          fontSize: 32,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        color: white,
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.isFavorite) {
                  favoriteProvider.removeFromFavorites(widget.product);
                } else {
                  favoriteProvider.addToFavorites(widget.product);
                }
                setState(() {
                  widget.isFavorite = !widget.isFavorite;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Icon(
                    widget.isFavorite ? Icons.favorite: Icons.favorite_border ,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  cartProvider.addCart(widget.product, quantity);
                  Fluttertoast.showToast(
                    msg: 'Add ${widget.product.name} to cart',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Styles.highlightColor,
                    textColor: Colors.white,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Styles.highlightColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: white),
                      SizedBox(width: 10),
                      Text(
                        'Add to cart',
                        style: poppin.copyWith(
                          color: white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
