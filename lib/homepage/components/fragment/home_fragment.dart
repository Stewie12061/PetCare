import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../pages/home.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:ListView(
          children: const [
            Home(),
          ],
        )

    );
  }
}