import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../provider/cart_provider.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckOutPage>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCartItem();
    });
  }

  Future<void> fetchCartItem() async {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.fetchCartItems();
  }

  Future<void> removeFromFavorites(int id) async {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.removeCart(id);
  }

  @override
  Widget build(BuildContext context){
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Styles.highlightColor,
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
        title: Text(
          'Checkout',
          style: poppin.copyWith(
              fontSize: 18, color: black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(seconds: 2),
        height: cartProvider.carts.isNotEmpty ? 265 : 0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.2),
              offset: Offset.zero,
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sub Price',
                            style: poppin.copyWith(
                              fontSize: 16,
                              color: grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<double>(
                      future: cartProvider.totalPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while waiting for the result
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        }
                        final totalPrice = snapshot.data ?? 0.0;
                        return Text(
                          '\$${(totalPrice*1.1).toStringAsFixed(2)}',
                          style: poppin.copyWith(
                            fontSize: 16,
                            color: grey,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping fee',
                      style: poppin.copyWith(
                        fontSize: 16,
                        color: grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    FutureBuilder<double>(
                      future: cartProvider.totalPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while waiting for the result
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        }
                        return Text(
                          '\$${5.toStringAsFixed(2)}',
                          style: poppin.copyWith(
                            fontSize: 16,
                            color: grey,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Final Price',
                      style: poppin.copyWith(
                        fontSize: 18,
                        color: black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    FutureBuilder<double>(
                      future: cartProvider.totalPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while waiting for the result
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        }
                        final totalPrice = snapshot.data ?? 0.0;
                        final finalPrice = ((totalPrice*1.1) + 5.00);
                        return Text(
                          '\$${finalPrice.toStringAsFixed(2)}',
                          style: poppin.copyWith(
                            fontSize: 16,
                            color: grey,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Styles.highlightColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Place order',
                        style: poppin.copyWith(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // body: ,
    );
  }
}