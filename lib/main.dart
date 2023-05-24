import 'package:flutter/material.dart';
import 'package:pet_care/homepage/homepage.dart';
import 'package:pet_care/pages/get_started.dart';
import 'package:pet_care/pages/register_pages/login.dart';
import 'package:pet_care/provider/cart_provider.dart';
import 'package:pet_care/provider/favorite_provider.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:provider/provider.dart';

void main() {
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
        '/home': (context) => const HomePage(),
      },
      home: const GetStarted(),
    );
  }
}
