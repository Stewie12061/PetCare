import 'package:pet_care/const.dart';
import 'package:pet_care/utils/layouts.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:pet_care/widgets/animated_title.dart';
import 'package:pet_care/widgets/pet_card.dart';
import 'package:pet_care/widgets/stories_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) {
                return AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: value,
                    child: Text("Pet Care", style: poppin.copyWith( fontSize: 70, color: Styles.highlightColor, fontWeight: FontWeight.w900)));
              }),
          const Gap(20),
          const AnimatedTitle(title: 'What are you looking for?'),
          const Gap(10),
          const Row(
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
          const Gap(25),
          const ProductBestSellerSection(),
          const Gap(25),
          const AnimatedTitle(title: 'Stories'),
          const Gap(10),
          const StoriesSection(),
        ],
      ),
    );
  }
}
