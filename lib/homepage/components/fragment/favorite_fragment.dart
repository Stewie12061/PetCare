import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../pages/home.dart';

class FavoriteDetail extends StatelessWidget {
  const FavoriteDetail({Key? key}) : super(key: key);

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