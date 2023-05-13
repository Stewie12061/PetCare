import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../const.dart';
import '../../pages/cart.dart';
import '../../provider/cart_provider.dart';
import '../../utils/styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});


  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Row(
      children: [
         Expanded(
           child: SizedBox(
             height: 45,
             child: Center(
               child: TextField(
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: Colors.white,
                   hintText: 'Search product',
                   prefixIcon: const Icon(Icons.search_rounded),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(50),
                     borderSide: const BorderSide(
                       color: Colors.black,
                       width: 2,
                     ),
                   ),
                 ),
               ),
             )
           ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CartPage()));
          },
          child: SizedBox(
            height: 30,
            width: 35,
            child: Stack(
              children: [
                const Positioned(
                  bottom: 0,
                  child: Icon(
                    Icons.shopping_cart,
                    color: black,
                  ),
                ),
                cartProvider.carts.isNotEmpty
                    ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Text(
                        '${cartProvider.carts.length}',
                        style: poppin.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      )),
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

