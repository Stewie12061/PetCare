import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pet_care/homepage/homepage.dart';
import 'package:pet_care/pages/booking_success_page.dart';
import 'package:pet_care/pages/get_started.dart';
import 'package:pet_care/pages/order_view_page.dart';
import 'package:pet_care/pages/profile_page.dart';
import 'package:pet_care/pages/register_pages/login.dart';
import 'package:pet_care/pages/update_info_page.dart';
import 'package:pet_care/provider/cart_provider.dart';
import 'package:pet_care/provider/favorite_provider.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:pet_care/widgets/processing.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51M7XO7LGB4KyGyVdlhB1cExKrVuSHxsxA4io48OqzVPHmAxxM2Vyb5ccjIJ6nxQAJUKzpxlzfIq69s4Zhka1PtvU005EWmzHHi";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<FavoriteProvider>(create: (_) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdoptMe',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Styles.blackColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Styles.blackColor),
      ),
      routes: {
        '/signin': (context) => const LoginPage(),
        'home': (context) => const HomePage(),
        'success_booking': (context) => const AppointmentBooked(),
        'success_order': (context) => const ProcessingScreen(),
        'order_view': (context) => const OrderViewPage(),
        'profile': (context) => const ProfilePage(),
        'modify': (context) => const UpdateInfo()
      },
      home: const GetStarted(),
    );
  }
}
