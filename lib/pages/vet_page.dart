import 'package:pet_care/models/package_details.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:pet_care/widgets/vet_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VetPage extends StatefulWidget {
  const VetPage({Key? key}) : super(key: key);

  @override
  State<VetPage> createState() => _VetPageState();
}

class _VetPageState extends State<VetPage> {
  late ScrollController _controller;
  double headerHeight = 140;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      if(_controller.offset > 0) {
        setState(() {
          headerHeight = 0;
        });
      }
      else {
        setState(() {
          headerHeight = 140;
        });
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final veterinaryPackage = [
      {
        'title': 'Online Vet(Cat)',
        'sub': null,
        'pet': 'assets/svg/pet_circle.svg',
        'items': [
          'One time consultation',
          'Call & Video Consultancy',
          'Personalized Advice'
        ],
        'price': 149
      },
      {
        'title': 'Online Essential Care',
        'sub': '(220 minutes/month)',
        'pet': null,
        'items': [
          'Chat Consults',
          'Personalized Advice',
          '1 month follow ups',
          'Ticks & Fleas Preventive'
        ],
        'price': 499
      },
      {
        'title': 'Dog Consultation',
        'sub': null,
        'pet': 'assets/svg/pet_circle2.svg',
        'items': [
          'Nutrition Consultation',
          'Dog Parenting Management',
          'Behavioral Training Tips',
          '(Aggression, Biting, Jumping)'
        ],
        'price': 599
      },

    ];
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Gap(60),
                AnimatedContainer(
                  margin: EdgeInsets.only(bottom: headerHeight == 0 ? 0 : 16),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInExpo,
                  width: double.infinity,
                  height: headerHeight,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('assets/png/vet.png'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Styles.bgColor, width: 3)),
                ),
                Expanded(
                  child: MediaQuery.removeViewPadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                        shrinkWrap: true,
                        controller: _controller,
                        itemBuilder: (c, i) {
                          final vp = VeterinaryDetails.fromJson(veterinaryPackage[i]);
                          return VetCard(vp);
                        },
                        separatorBuilder: (c, i) {
                          return const Gap(12);
                        },
                        itemCount: veterinaryPackage.length),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 12,
            left: 15,
            right: 15,
            child: Center(
              child:
                Text('Pet Veterinary',
                    style: TextStyle(
                        color: Styles.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28))
            ),
          )
        ],
      ),
    );
  }
}
