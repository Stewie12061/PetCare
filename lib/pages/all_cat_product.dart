import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/models/category_model.dart';
import 'package:pet_care/models/product_model.dart';
import 'package:pet_care/service/Utilities.dart';
import 'package:pet_care/widgets/product.dart';
import 'package:provider/provider.dart';

import '../homepage/components/homeheader.dart';
import '../homepage/components/productheader.dart';
import '../provider/favorite_provider.dart';
import '../utils/styles.dart';
import 'detail.dart';

class AllCatProductPage extends StatefulWidget {
  @override
  _CategoriesProductsScreenState createState() => _CategoriesProductsScreenState();
}

class _CategoriesProductsScreenState extends State<AllCatProductPage> {
  final Utilities utilities = Utilities();
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchCategories();

  }

  Future<void> fetchCategories() async {
    final fetchedCategories = await utilities.getCategories();
    setState(() {
      categories = fetchedCategories;
      if (fetchedCategories.isNotEmpty) {
        selectedCategory = fetchedCategories[0]; // Select the first category by default
        fetchProductsForCategory(selectedCategory!);
      }
    });
  }

  Future<void> fetchProductsForCategory(CategoryModel category) async {
    final fetchedProducts = await utilities.getCatProductsForCategory(category);
    setState(() {
      products = fetchedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const ProductHeader(),
        backgroundColor: Styles.highlightColor,
      ),
      body: Column(
        children: [
          // Category List
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        fetchProductsForCategory(selectedCategory!);
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 5,
                        backgroundColor:category == selectedCategory ? Colors.blue : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        side: BorderSide(
                          color: category == selectedCategory ? Colors.white : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            'assets/category/${category.image}',
                            width: 40,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: category == selectedCategory ? Colors.white : Colors.black,
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Product List
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 2, // Number of columns
              padding: const EdgeInsets.all(8), // Add padding around each item
              childAspectRatio: 0.6, // Adjust aspect ratio for item size
              children: List.generate(products.length, (index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.all(8), // Add spacing between items
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  product: products[index])));
                    },
                    child: ProductItem(
                      product: product,
                      isFavorite: favoriteProvider.isProductFavorite(products[index].id),
                    ),
                  ),
                );
              }),
            ),
          ),

        ],
      ),
    );
  }

}
