import 'package:flutter/cupertino.dart';
import 'package:pet_care/homepage/components/body.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class HomePage extends StatelessWidget {
  //int selectIndex = 0;
  static String routeName = '/home_sreen';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}