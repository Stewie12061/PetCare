import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../provider/cart_provider.dart';
import '../service/Utilities.dart';

class PaymentPage extends StatefulWidget {
  final Order order;

  const PaymentPage({super.key, required this.order});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () async {
        await makePayment();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // Add a loading indicator while waiting
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      String value = widget.order.orderPrice.toString();
      paymentIntent = await createPaymentIntent(value, 'USD');
      // Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
          // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
          style: ThemeMode.dark,
          merchantDisplayName: 'Stewie',
        ),
      ).then((value) {});

      /// now finally display payment sheet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    CartProvider cartProvider =
    Provider.of<CartProvider>(context, listen: false);

    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ),
        );
        final orderResponse = await Utilities().makeOrder(widget.order);
        if (orderResponse == 200) {
          // Remove all items from cart
          await cartProvider.removeAllItemsCart();

          paymentIntent = null;
          await Future.delayed(const Duration(seconds: 3));
          Navigator.of(context).pushNamed('success_order');
        }
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled "),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  // Future<Map<String, dynamic>>
  createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      String SECRET_KEY =
          "sk_test_51M7XO7LGB4KyGyVd6spNIn8OwCXl254ORKPtFn8Nkv33ePcb1z3Pb2EjJEAaRzFdEz6x319AXbGy1QtHVFwd128T00vLIQjGPw";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = ((double.parse(amount)) * 100).toInt();
    return calculatedAmount.toString();
  }
}
