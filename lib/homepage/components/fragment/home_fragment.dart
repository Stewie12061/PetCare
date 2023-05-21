import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../pages/home.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:ListView(
          children: [
            CarouselSlider(
              items: const [
                Image(image: AssetImage('assets/images/login.png')),
                Image(image: AssetImage('assets/images/signup.png')),
                Image(image: AssetImage('assets/images/login.png')),
                Image(image: AssetImage('assets/images/signup.png')),
              ],
              options: CarouselOptions(),
            ),
            const Home(),
          ],
        )

    );
  }
}