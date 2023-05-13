import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../pages/grooming_page.dart';
import '../../../pages/home.dart';

class GroomingDetail extends StatelessWidget {
  const GroomingDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: GroomingPage(),
    );
  }
}