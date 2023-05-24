import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_care/homepage/components/fragment/home_fragment.dart';
import 'package:pet_care/homepage/components/homeheader.dart';
import 'package:pet_care/utils/styles.dart';
import 'fragment/favorite_fragment.dart';
import 'fragment/grooming_fragment.dart';
import 'fragment/profile_fragment.dart';
import 'fragment/vet_fragment.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var selectIndex = 0;
  var flag = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = [
      const HomeDetail(),
      const FavoriteDetail(),
      const GroomingDetail(),
      const VetDetail(),
      const ProfileDetail()
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const HomeHeader(),
        backgroundColor: Styles.highlightColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectIndex,
        onTap: (index) {
          setState(() {
            selectIndex = index;
            if (selectIndex != 3) {
              flag = true;
            } else {
              flag = false;
            }
          });
        },
        selectedLabelStyle: TextStyle(color: Styles.highlightColor),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/nav_icons/dog_icon.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/nav_icons/dog_icon.svg',
              width: 24,
              height: 24,
              color: Styles.highlightColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/nav_icons/favorite_icon.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/nav_icons/favorite_icon.svg',
              width: 24,
              height: 24,
              color: Styles.highlightColor,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/nav_icons/cut_icon.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/nav_icons/cut_icon.svg',
              width: 24,
              height: 24,
              color: Styles.highlightColor,
            ),
            label: 'Grooming',
          ),
          BottomNavigationBarItem(
            icon:  SvgPicture.asset(
              'assets/nav_icons/vet_icon.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/nav_icons/vet_icon.svg',
              width: 24,
              height: 24,
              color: Styles.highlightColor,
            ),
            label: 'Vet',
          ),
          BottomNavigationBarItem(
            icon:  const Icon(
                Icons.account_circle,
              color: Colors.black,
            ),
            activeIcon: Icon(
                Icons.account_circle
              ,color: Styles.highlightColor
            ),
            label: 'Profile',
          ),
        ],

      ),
      body: SafeArea(
        child: Column(
          children: [
            screen[selectIndex]
          ],
        ),
      ),
    );
  }
}
