import 'package:pet_care/pages/carousel.dart';
import 'package:pet_care/widgets/animated_title.dart';
import 'package:pet_care/widgets/pet_card.dart';
import 'package:pet_care/widgets/stories_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/product_best_seller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Carousel(),
        Gap(20),
        AnimatedTitle(title: 'What are you looking for?'),
        Gap(10),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              PetCard(petPath: 'assets/svg/cat1.svg', petName: 'Cat Item'),
              Gap(28),
              PetCard(
                petPath: 'assets/svg/dog1.svg',
                petName: 'Dog Item',
                height: 68,
              ),
            ],
          ),
        ),
        Gap(25),
        ProductBestSellerSection(),
        Gap(25),
        AnimatedTitle(title: 'Stories'),
        Gap(10),
        StoriesSection(),
      ],
    );
  }
}
