import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import '../models/cart_model.dart';
import 'package:http/http.dart' as http;

class CartItem extends StatelessWidget {
  final CartModel cart;
  const CartItem({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: const Offset(3, 3),
                color: black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5)
          ]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration:
            const BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  color: Color(0xFF42A5F5),
                  spreadRadius: -5,
                  blurRadius: 20)
            ]),
            child: Image.asset('assets/products/${cart.product!.image}'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product!.name,
                  style: poppin.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w600, color: black),
                ),
                FutureBuilder<String>(
                  future: fetchCategoryName(cart.product!.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    } else if (snapshot.hasError) {
                      return const Text("category");
                    } else {
                      final categoryName = snapshot.data;
                      return Text(
                        categoryName!,
                        style: poppin.copyWith(fontSize: 14, color: black),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${(cart.product!.price).toStringAsFixed(2)}',
                  style: poppin.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w600, color: black),
                ),
              ],
            ),
          ),
          Text(
            '${cart.quantity}x',
            style: poppin.copyWith(
                fontSize: 14, color: black, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
  Future<String> fetchCategoryName(int id) async {
    final url = 'http://10.0.2.2:8080/api/v1/categories/categoryName/$id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final categoryName = response.body;
      return categoryName;
    } else {
      throw Exception('category');
    }
  }
}
