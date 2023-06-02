import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/pages/payment_page.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:provider/provider.dart';
import '../const.dart';
import '../models/order_model.dart';
import '../provider/cart_provider.dart';
import '../service/Utilities.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckOutPage>{
  late var finalPrice=0.0;
  bool isPaymentOptionSelected = false;
  String paymentOptionText = 'Choose Payment Option';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController? addressController = TextEditingController();
  final TextEditingController? cityController = TextEditingController();
  final TextEditingController? countryController = TextEditingController();
  final TextEditingController? zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCartItem();
    });
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height*0.3,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
            )
          ),
          // Add your desired styling for the ModalBottomSheet
          child: Padding(
            padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  color: Colors.black,
                  child: ListTile(
                    leading: const Icon(
                        Icons.payment,
                      size: 40,
                      color: Colors.cyan,
                    ),
                    title: const Text('Pay with Card', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.cyan)),
                    subtitle: const Text(
                      'You pay after getting delivery',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isPaymentOptionSelected = true;
                        paymentOptionText = 'Pay with Card';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Gap(20),
                Card(
                  elevation: 5,
                  clipBehavior: Clip.hardEdge,
                  color: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.payments,
                      size: 40,
                      color: Colors.cyan,
                    ),
                    title: const Text('Cash on Delivery',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.cyan)),
                    subtitle: const Text(
                      'Safer and faster way of payment',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isPaymentOptionSelected = true;
                        paymentOptionText = 'Cash on Delivery';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        height: cartProvider.carts.isNotEmpty ? 350 : 0,
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
                        finalPrice = ((totalPrice*1.1) + 5.00);
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
                  onTap:() => _showPaymentOptions(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        paymentOptionText,
                        style: poppin.copyWith(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    if(isPaymentOptionSelected){
                      if(_formKey.currentState!.validate()){
                        final DateFormat dateFormat = DateFormat('dd/MM/yyyy h:mm a');
                        String formattedDate = dateFormat.format(DateTime.now());

                        Order order = Order(
                          address: addressController?.text,
                          city: cityController?.text,
                          country: countryController?.text,
                          zipCode: zipCodeController?.text,
                          orderPrice: finalPrice,
                          itemQuantity: cartProvider.carts.length,
                          isPaid: 0,
                          isCompleted: 0,
                          dateOrder: formattedDate,
                        );
                        if(paymentOptionText=='Pay with Card'){
                          String? address = order.address;
                          String price = finalPrice.toStringAsFixed(2);
                          String text = cartProvider.carts.length > 1
                              ? 'Items'
                              : 'Item';
                          String quantity = '${cartProvider.carts.length} $text';
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            headerAnimationLoop: true,
                            transitionAnimationDuration: const Duration(milliseconds: 500),
                            animType: AnimType.bottomSlide,
                            title: 'Confirm Order',
                            titleTextStyle: const TextStyle(color: Colors.cyan,fontWeight: FontWeight.w600,fontSize: 20),
                            desc: 'Address: $address \n$quantity total: \$$price',
                            descTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                            buttonsTextStyle: const TextStyle(color: Colors.black),
                            showCloseIcon: false,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              order.isPaid = 1;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(order: order,),
                                ),
                              );
                            },
                          ).show();
                        }else{
                          String? address = order.address;
                          String price = finalPrice.toStringAsFixed(2);
                          String text = cartProvider.carts.length > 1
                              ? 'Items'
                              : 'Item';
                          String quantity = '${cartProvider.carts.length} $text';
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            headerAnimationLoop: true,
                            transitionAnimationDuration: const Duration(milliseconds: 500),
                            animType: AnimType.bottomSlide,
                            title: 'Confirm Order',
                            titleTextStyle: const TextStyle(color: Colors.cyan,fontWeight: FontWeight.w600,fontSize: 20),
                            desc: 'Address: $address \n$quantity total: \$$price',
                            descTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                            buttonsTextStyle: const TextStyle(color: Colors.black),
                            showCloseIcon: false,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              order.isPaid = 0;
                              final orderReposone = await Utilities().makeOrder(order);
                              if (orderReposone == 200) {
                                Navigator.of(context).pushNamed('success_order');
                              }
                              else {
                                Fluttertoast.showToast(
                                  msg: 'Something when wrong \nPlease try again later',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Styles.highlightColor,
                                  textColor: Colors.white,
                                );
                              }
                            },
                          ).show();
                        }
                      }
                    }else{
                      Fluttertoast.showToast(msg: 'Choose payment option first',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Styles.highlightColor,
                        textColor: Colors.white,
                      );
                    }

                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: isPaymentOptionSelected ? Styles.highlightColor : Colors.grey,
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'DELIVERY INFORMATION',
                style: poppin.copyWith(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildTextFormField(addressController!, context, 'Address:'),
              _buildTextFormField(cityController!, context, 'City:'),
              _buildTextFormField(countryController!, context, 'Country:'),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                SizedBox(
                  width: 75,
                  height: 50,
                  child: Text(
                    'Zip Code',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: zipCodeController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 10),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Zip Code';
                        }
                        if (value.length != 5) {
                          return 'Zip Code must be 5 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          )
            ],
          ),
        ),
      ),
    );
  }
}

Padding _buildTextFormField(
  TextEditingController? controller,
  BuildContext context,
  String labelText,
){
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      children: [
        SizedBox(
          width: 75,
          height: 50,
          child: Text(
            labelText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(left: 10),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter $labelText';
                }
                return null;
              },
            ),
          ),
        )
      ],
    ),
  );
}
