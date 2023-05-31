import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/models/product_model.dart';
import 'package:pet_care/service/Utilities.dart';
import 'package:provider/provider.dart';
import '../../const.dart';
import '../../pages/cart_page.dart';
import '../../widgets/detail.dart';
import '../../provider/cart_provider.dart';
import '../../provider/favorite_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/product.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: Stack(
                  children: [
                  Positioned(
                  child: IconButton(
                    icon: const Icon(Icons.search,size: 30,color: Colors.black,),
                    onPressed: (){
                      showSearch(context: context, delegate: MySearchDelegate());
                    },
                  ),
                ),
                ]
              ),
            ),
            const Gap(20),
            TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, value, _) {
                  return AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: value,
                      child: Text("Pet Care", style: poppin.copyWith( fontSize: 50, color: Styles.blackColor, fontWeight: FontWeight.w900)));
                }),
            const Gap(20),
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
                      top: -5,
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
                            fontSize: 13,
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
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
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
                          builder: (context) => DetailPage(
                            product: searchResults[index],
                            isFavorite: favoriteProvider.isProductFavorite(searchResults[index].id),
                          ),
                        ),
                      );
                    },
                    child: ProductItem(
                      product: product,
                      isFavorite: favoriteProvider.isProductFavorite(searchResults[index].id),
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
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
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
                          builder: (context) => DetailPage(
                              product: searchResults[index],
                            isFavorite: favoriteProvider.isProductFavorite(searchResults[index].id),
                          ),
                        ),
                      );
                    },
                    child: ProductItem(
                      product: product,
                      isFavorite: favoriteProvider.isProductFavorite(searchResults[index].id),
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
}
