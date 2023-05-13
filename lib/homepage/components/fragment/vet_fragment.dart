import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/vet_page.dart';

import '../../../pages/grooming_page.dart';
import '../../../pages/home.dart';

class VetDetail extends StatelessWidget {
  const VetDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: VetPage()
    );
  }
}