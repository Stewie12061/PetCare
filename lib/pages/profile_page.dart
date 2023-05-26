import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/pages/booking_page.dart';
import 'package:pet_care/pages/reschedule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/apointment.dart';
import '../service/Utilities.dart';
import '../utils/Config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  List<Appointment> appointments = [];
  final Utilities utilities = Utilities();

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
    fetchAppointments();
  }

  Future<void> loadDataFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('fullname') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  Future<void> fetchAppointments() async {
    final fetchedAppointments = await utilities.fetchClosestAppointments();
    setState(() {
      appointments = fetchedAppointments;
    });
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final response = await utilities.cancelAppointment(appointmentId);
      if (response == 200) {
        fetchAppointments();
      } else {
        // Handle API error
        print('Failed to cancel appointment. Status code: ${response}');
      }

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 25, right: 20, left: 20),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.bar_chart),
                          Icon(Icons.more_vert),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Container(
                            width: 120,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage("https://www.looper.com/img/gallery/the-stewie-griffin-theory-that-changes-everything-about-family-guy/l-intro-1625887696.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: (size.width - 40) * 0.6,
                            child: Column(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Column(
                            children: [
                              Text(
                                "\$8900",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Total spend",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 0.5,
                            height: 40,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          const Column(
                            children: [
                              Text(
                                "20",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Total order",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(20),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sign Out'),
                                content: Text('Are you sure you want to sign out?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Sign Out'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacementNamed(context, '/signin');
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 25, right: 25,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "UPCOMING APPOINTMENT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment.groomingPackageName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${appointment.price}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Config.primaryColor,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${appointment.day}, ${appointment.date}',
                                          style: const TextStyle(
                                            color: Config.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        const Icon(
                                          Icons.access_alarm,
                                          color: Config.primaryColor,
                                          size: 17,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                            child: Text(
                                              appointment.time,
                                              style: const TextStyle(
                                                color: Config.primaryColor,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Cancel Appointment'),
                                                content: Text('Are you sure you want to cancel this appointment?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      cancelAppointment(appointment.id);
                                                    },
                                                  ),
                                                ],
                                              );
                                              }
                                            );
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style:
                                            TextStyle(color: Config.primaryColor),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Config.primaryColor,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ReschedulePage(
                                                      packageId: appointment.packageId,
                                                      price: appointment.price,
                                                      groomingPackageName: appointment.groomingPackageName,
                                                    )
                                                )
                                            );
                                          },
                                          child: const Text(
                                            'Reschedule',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
