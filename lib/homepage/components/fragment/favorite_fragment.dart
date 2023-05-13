import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/favorite.dart';

import '../../../pages/home.dart';

class FavoriteDetail extends StatelessWidget {
  const FavoriteDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:ListView(
          children: const [
            Favorite(),
          ],
        )

    );
  }
}