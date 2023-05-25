import 'package:pet_care/models/package.dart';
import 'package:pet_care/pages/booking_page.dart';
import 'package:pet_care/pages/vet_page.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PackageCard extends StatelessWidget {
  final Package package;
  const PackageCard(this.package, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              color: Styles.bgColor,
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.only(
              left: 22, right: 12, top: 12, bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: TextStyle(
                        color: Styles.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const Gap(10),
                  Text(
                    'Total ${package.service} Services',
                    style: const TextStyle(
                        color: Color(0xFF04EA4B),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        height: 1.5),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\$${package.price.toStringAsFixed(0)}',
                    style: TextStyle(
                        color: Styles.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => BookingPage(package: package,)));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      fixedSize: const Size(100, 0),
                      primary: Styles.bgWithOpacityColor,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text('Book services',
                            style: TextStyle(
                                color: Styles.highlightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
