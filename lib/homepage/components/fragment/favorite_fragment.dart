import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/favorite_page.dart';

class FavoriteDetail extends StatelessWidget {
  const FavoriteDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Favorite(),
    );
  }
}