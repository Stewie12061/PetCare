import 'package:pet_care/pages/home.dart';
import 'package:pet_care/utils/layouts.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../homepage/homepage.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, _) {
          return Column(
            children: [
              Opacity(
                opacity: value,
                child: SizedBox(
                    width: double.infinity,
                    height: Layouts.getSize(context).height * 0.65,
                    child: SvgPicture.asset(
                      'assets/svg/starter_header.svg',
                      fit: BoxFit.cover,
                    )),
              ),
              const Gap(25),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 70),
                child: Text('PET CARE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Styles.blackColor,
                      fontSize: value*40,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ).apply(fontWeightDelta: 2)),
              ),
              const Gap(5),
              Text(
                'Take care me, we both need the love',
                textScaleFactor: value,
                style: TextStyle(color: Styles.highlightColor, fontWeight: FontWeight.w600,fontSize: 18),
              ),
              const Gap(30),
              Opacity(
                opacity: value,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  child: const Text('Get Started',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
