import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:pet_care/models/product_model.dart';
import 'package:pet_care/service/Utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';
import '../../pages/cart.dart';
import '../../pages/detail.dart';
import '../../provider/cart_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/product.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key});

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: (){
                  showSearch(context: context, delegate: MySearchDelegate());
                },
              ),
            ),
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
          child: SizedBox(
            height: 30,
            width: 35,
            child: Stack(
              children: [
                const Positioned(
                  bottom: 0,
                  child: ImageIcon(
                    AssetImage('assets/nav_icons/cart.png'),
                    size: 30,
                    color: black,
                  ),
                ),
                cartProvider.carts.isNotEmpty
                    ? Positioned(
                  top: -8,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Text(
                      '${cartProvider.carts.length}',
                      style: poppin.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate{
  final Utilities utilities = Utilities();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
             query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: utilities.searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error occurred while searching.'),
          );
        } else {
          final searchResults = snapshot.data;
          if (searchResults != null && searchResults.isNotEmpty) {
            // Display the search results
            return GridView.count(
              crossAxisCount: 2, // Number of columns
              padding: const EdgeInsets.all(8), // Add padding around each item
              childAspectRatio: 0.6, // Adjust aspect ratio for item size
              children: List.generate(searchResults.length, (index) {
                final product = searchResults[index];
                return Padding(
                  padding: const EdgeInsets.all(8), // Add spacing between items
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(product: searchResults[index]),
                        ),
                      );
                    },
                    child: ProductItem(
                      product: product,
                    ),
                  ),
                );
              }),
            );
          } else {
            // Display a message when no search results are found
            return const Center(
              child: Text('No search results found.'),
            );
          }
        }
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search product'),
    );
  }
}
