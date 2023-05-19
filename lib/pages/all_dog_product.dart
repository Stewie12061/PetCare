import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/models/category_model.dart';
import 'package:pet_care/models/product_model.dart';
import 'package:pet_care/service/Utilities.dart';

class AllDogProductPage extends StatefulWidget {
  @override
  _CategoriesProductsScreenState createState() => _CategoriesProductsScreenState();
}

class _CategoriesProductsScreenState extends State<AllDogProductPage> {
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
    final fetchedProducts = await utilities.getProductsForCategory(category);
    setState(() {
      products = fetchedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories & Products'),
      ),
      body: Row(
        children: [
          // Category List
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    fetchProductsForCategory(selectedCategory!);
                  },
                  selected: category == selectedCategory,
                );
              },
            ),
          ),
          // Product List
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  // Add more product details if needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
