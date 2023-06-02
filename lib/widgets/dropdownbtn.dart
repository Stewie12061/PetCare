import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/styles.dart';

class CustomButtonTest extends StatefulWidget {
  const CustomButtonTest({Key? key}) : super(key: key);

  @override
  State<CustomButtonTest> createState() => _CustomButtonTestState();
}

class _CustomButtonTestState extends State<CustomButtonTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Icon(
              Icons.list,
              size: 30,
              color: Styles.highlightColor,
            ),
            items: [
              ...MenuItems.firstItems.map(
                    (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
              const DropdownMenuItem<Divider>(enabled: false, child: Divider(color: Colors.white,)),
              ...MenuItems.secondItems.map(
                    (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
            ],
            onChanged: (value) {
              MenuItems.onChanged(context, value as MenuItem);
            },
            dropdownStyleData: DropdownStyleData(
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.black
              ),
              elevation: 8,
              offset: const Offset(0, 8),
            ),
            menuItemStyleData: MenuItemStyleData(
              customHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              padding: const EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, settings, modify];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const modify = MenuItem(text: 'Profile', icon: Icons.mode);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        Navigator.of(context).pushReplacementNamed('home');
        break;
      case MenuItems.settings:
        Fluttertoast.showToast(
          msg: 'Not support yet',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Styles.blackColor,
          textColor: Colors.white,
        );
        break;
      case MenuItems.modify:
        Navigator.pushNamed(context, 'modify');
        break;
      case MenuItems.logout:
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          headerAnimationLoop: true,
          transitionAnimationDuration: const Duration(milliseconds: 500),
          animType: AnimType.bottomSlide,
          title: 'Sign Out',
          titleTextStyle: const TextStyle(color: Colors.cyan,fontWeight: FontWeight.w600,fontSize: 20),
          desc: 'Are you sure you want to sign out?',
          descTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          buttonsTextStyle: const TextStyle(color: Colors.black),
          showCloseIcon: false,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            Navigator.pushReplacementNamed(context, '/signin');
          },
        ).show();
        break;
    }
  }
}