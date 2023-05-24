import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../pages/profile_page.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: ProfilePage(),
    );
  }
}