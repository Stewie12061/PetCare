import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/homepage/components/fragment/home_fragment.dart';
import 'package:pet_care/homepage/components/homeheader.dart';
import 'package:pet_care/utils/styles.dart';
import '../../utils/Config.dart';
import 'fragment/favorite_fragment.dart';
import 'fragment/grooming_fragment.dart';
import 'fragment/profile_fragment.dart';
import 'fragment/appointment_fragment.dart';


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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Styles.highlightColor, // Thay đổi màu nền ở đây
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          elevation: 5,
          backgroundColor: Colors.black,
          currentIndex: selectIndex,
          fixedColor: Colors.white,
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
          // selectedLabelStyle: TextStyle(color: Colors.cyan),
          // unselectedLabelStyle: TextStyle(color: Colors.black),
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
                color: Colors.white,
              ),
              label: 'Home'

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
                color: Colors.white,
              ),
              label: 'Favorite'
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
                color: Colors.white,
              ),
              label: 'Grooming'
            ),
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.solidCalendar,color: Colors.black,),
              activeIcon: FaIcon(FontAwesomeIcons.solidCalendarCheck,color: Colors.white,),
              label: 'Appointment'

            ),
            BottomNavigationBarItem(
              icon:  const Icon(
                  Icons.account_circle,
                color: Colors.black,
              ),
              activeIcon: Icon(
                  Icons.account_circle,
                color: Colors.white,
              ),
              label: 'Profile'
            ),
          ],

        ),
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
