import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/const.dart';
import 'package:pet_care/widgets/product.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../pages/detail.dart';
import '../provider/cart_provider.dart';
import '../utils/styles.dart';

class ProductBestSellerSection extends StatefulWidget {
  const ProductBestSellerSection({Key? key}) : super(key: key);

  @override
  State<ProductBestSellerSection> createState() => _ProductBestSellerSection();
}

class _ProductBestSellerSection extends State<ProductBestSellerSection> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Color?> animation;
  List<ProductModel> dataProduct = [];

  Future<void> getProduct() async {
    final String response =
    await rootBundle.loadString('assets/json/product.json');
    final data = json.decode(response);
    setState(() {
      for (var element in data['product']) {
        dataProduct.add(ProductModel.fromJson(element));
      }
    });
    print(dataProduct);
  }

  @override
  void initState() {
    super.initState();
    getProduct();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.transparent,
      end: const Color(0xFF04E4E9),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Seller',
                    style: poppin.copyWith(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AllProductsPage()),
                      // );
                      print("all");
                    },
                    child: Text(
                      'See all',
                      style: poppin.copyWith(
                        color: Styles.highlightColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    dataProduct.length,
                        (index) => Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(left: 20, right: 20)
                          : const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                      product: dataProduct[index])));
                        },
                        child: ProductItem(
                          product: dataProduct[index],
                        ),
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Special Bundle',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Styles.blackColor,
                        height: 1),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width - 40,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Styles.bgColor,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: -10,
                    child: Transform.rotate(
                      angle: -0.15,
                      child: Image.asset(
                        'assets/foods/meow-mix1.png',
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 50,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Image.asset(
                        'assets/foods/authority1.png',
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Transform.rotate(
                      angle: 0,
                      child: Image.asset(
                        'assets/foods/royal-canin1.png',
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 190,
                    top: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Bundle',
                          style: poppin.copyWith(
                              fontSize: 16,
                              color: Styles.blackColor,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Special offer\n Three in one',
                          style: poppin.copyWith(color: Styles.blackColor, fontSize: 14),
                        ),
                        Text(
                          '\$${40.00}',
                          style: poppin.copyWith(
                              fontSize: 20,
                              color: black,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
