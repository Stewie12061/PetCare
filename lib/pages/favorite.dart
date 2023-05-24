import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../provider/favorite_provider.dart';
import 'detail.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFavoriteProducts();
    });
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
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 5,
                ),
                clipBehavior: Clip.hardEdge,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                product: favoriteProducts[index],
                              isFavorite: favoriteProvider.isProductFavorite(favoriteProducts[index].id),
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset.zero,
                                    color: Color(0xFF42A5F5),
                                    spreadRadius: -5,
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/products/${product.image}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Spacer(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 40,
                              ),
                              onPressed: () {
                                removeFromFavorites(product);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

}
