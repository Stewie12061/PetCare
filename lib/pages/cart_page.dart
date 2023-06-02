import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_care/pages/checkout_page.dart';
import 'package:provider/provider.dart';
import '../const.dart';
import '../provider/cart_provider.dart';
import '../utils/styles.dart';
import '../widgets/cartItem.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartState createState() => _CartState();
}
class _CartState extends State<CartPage> {
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
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return Scaffold(
          backgroundColor: white,
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
              'Cart',
              style: poppin.copyWith(
                  fontSize: 18, color: black, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if(cartProvider.carts.isEmpty)
                Center(
                  child: Text(
                      'Nothing in here, add some for your pet',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  )
                ),
              if(cartProvider.carts.isNotEmpty)
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: cartProvider.carts.isNotEmpty
                        ? Text.rich(TextSpan(children: [
                      TextSpan(
                          text: '${cartProvider.carts.length} ',
                          style: poppin.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: cartProvider.carts.length > 1
                              ? ' Items'
                              : ' Item',
                          style: poppin.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ]))
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: (){
                        cartProvider.removeAllItemsCart();
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.cyan,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15),
                    child: Column(
                      children: List.generate(
                        cartProvider.carts.length,
                            (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Container(
                            height: 105,
                            decoration: BoxDecoration(
                              color: grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.15,
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      cartProvider.removeCart(
                                          cartProvider.carts[index].id!);
                                    },
                                    icon: Icons.delete_outline_rounded,
                                    foregroundColor: Colors.red,
                                    autoClose: true,
                                    backgroundColor: grey.withOpacity(0.1),
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(20),
                                    ),
                                  )
                                ],
                              ),
                              child: CartItem(
                                cart: cartProvider.carts[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                                text: '${cartProvider.carts.length} ',
                                style: poppin.copyWith(
                                  fontSize: 16,
                                  color: grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: cartProvider.carts.length > 1
                                    ? ' Items'
                                    : ' Item',
                                style: poppin.copyWith(
                                  fontSize: 16,
                                  color: grey,
                                  fontWeight: FontWeight.w200,
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
                              '\$${totalPrice.toStringAsFixed(2)}',
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
                          'Tax',
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
                            final totalPrice = snapshot.data ?? 0.0;
                            return Text(
                              '\$${(totalPrice*0.1).toStringAsFixed(2)}',
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
                          'Total',
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
                            return Text(
                              '\$${(totalPrice * 1.1).toStringAsFixed(2)}',
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
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const CheckOutPage()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Styles.highlightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'Check out',
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
        );
      },
    );
  }
}
