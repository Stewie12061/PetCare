import 'package:pet_care/models/package.dart';
import 'package:pet_care/utils/layouts.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:pet_care/widgets/package_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GroomingPage extends StatefulWidget {
  const GroomingPage({Key? key}) : super(key: key);

  @override
  State<GroomingPage> createState() => _GroomingPageState();
}

class _GroomingPageState extends State<GroomingPage> {

  Future<Map<String, List<dynamic>>> fetchGroomingPackages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    Uri uriCat = Uri.parse("http://10.0.2.2:8080/api/v1/grooming/cat");
    Uri uriDog = Uri.parse("http://10.0.2.2:8080/api/v1/grooming/dog");

    final catResponse = await http.get(
      uriCat,
      headers: {"Authorization": "Bearer $token"},
    );
    final dogResponse = await http.get(
      uriDog,
      headers: {"Authorization": "Bearer $token"},
    );

    if (catResponse.statusCode == 200 && dogResponse.statusCode == 200) {
      final catData = jsonDecode(catResponse.body);
      final dogData = jsonDecode(dogResponse.body);

      return {
        'cat': catData,
        'dog': dogData,
      };
    } else {
      // Handle error case
      throw Exception('Failed to fetch grooming packages');
    }
  }


  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final List _packages = [];

  String selectedPet = 'Dog'; // Default selected pet
  List<dynamic> catPackages = [];
  List<dynamic> dogPackages = [];
  @override
  void initState() {
    super.initState();
    fetchGroomingPackages().then((data) {
      setState(() {
        catPackages = data['cat']!;
        dogPackages = data['dog']!;

        if (catPackages != null) {
          for (var i = 0; i < catPackages.length; i++) {
            listKey.currentState!.insertItem(0, duration: Duration(milliseconds: 500 - i * 200));
            _packages.add(Package.fromJson(catPackages[i]));
          }
        }

        if (dogPackages != null) {
          for (var i = 0; i < dogPackages.length; i++) {
            listKey.currentState!.insertItem(0, duration: Duration(milliseconds: 500 - i * 200));
            _packages.add(Package.fromJson(dogPackages[i]));
          }
        }
      });
    }).catchError((error) {
      // Handle error case
      print('Error: $error');
    });
  }



  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);

    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) {
                    return Stack(
                      children: [
                        Container(
                          width: value * size.width,
                          height: value * size.width,
                          decoration: BoxDecoration(
                            color: Styles.bgColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(value * size.width / 2),
                              bottomRight: Radius.circular(value * size.width / 2),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Gap(value * 50),
                                AnimatedSize(
                                  curve: Curves.bounceInOut,
                                  duration: const Duration(seconds: 1),
                                  child: SvgPicture.asset(
                                    'assets/svg/person2.svg',
                                    height: value * 200,
                                  ),
                                ),
                                Gap(value * 20),
                                Card(
                                  color: Styles.bgWithOpacityColor,
                                  elevation: 5,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: 100,
                                    height: 50,
                                    child: Center(
                                      child: DropdownButton<String>(
                                        value: selectedPet,
                                        icon: SvgPicture.asset(
                                          'assets/svg/arrow_down.svg',
                                          height: value * 30,
                                        ),
                                        iconSize: value * 30,
                                        elevation: 5,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Styles.highlightColor,
                                          fontSize: value * 16,
                                        ),
                                        underline: Container(
                                          height: 0,
                                          color: Colors.transparent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedPet = newValue!;
                                            _packages.clear();
                                            for (var i = 0; i < _packages.length; i++) {
                                              listKey.currentState!.removeItem(
                                                0,
                                                    (context, animation) => const SizedBox(),
                                                duration: const Duration(milliseconds: 500),
                                              );
                                            }
                                            if (selectedPet == 'Dog') {
                                              for (var i = 0; i < dogPackages.length; i++) {
                                                listKey.currentState!.insertItem(
                                                  0,
                                                  duration: Duration(milliseconds: 500 - i * 100),
                                                );
                                                _packages.add(Package.fromJson(dogPackages[i]));
                                              }
                                            } else if (selectedPet == 'Cat') {
                                              for (var i = 0; i < catPackages.length; i++) {
                                                listKey.currentState!.insertItem(
                                                  0,
                                                  duration: Duration(milliseconds: 500 - i * 100),
                                                );
                                                _packages.add(Package.fromJson(catPackages[i]));
                                              }
                                            }
                                          });
                                        },

                                        items: <String>['Dog', 'Cat']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const Gap(5),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeInExpo,
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) {
                return Text(
                  selectedPet == 'Dog'
                      ? 'Dog Grooming Packages'
                      : 'Cat Grooming Packages',
                  style: TextStyle(
                    color: Styles.blackColor,
                    fontSize: value * 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const Gap(5),
            MediaQuery.removeViewPadding(
              context: context,
              removeTop: true,
              child: AnimatedList(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                initialItemCount: _packages.length,
                key: listKey,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (c, i, animation) {
                  final List<dynamic> groomingList =
                  selectedPet == 'Dog' ? dogPackages : catPackages;

                  if (i >= groomingList.length) {
                    return const SizedBox(); // Return an empty SizedBox if the index is out of range
                  }

                  final package = Package.fromJson(groomingList[i]);
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-0.5, 0),
                      end: const Offset(0, 0),
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeIn,
                    )),
                    child: PackageCard(package),
                  );
                },

              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
