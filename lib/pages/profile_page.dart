import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/pages/booking_page.dart';
import 'package:pet_care/pages/reschedule_page.dart';
import 'package:pet_care/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/apointment.dart';
import '../models/order_model.dart';
import '../service/Utilities.dart';
import '../utils/Config.dart';
import '../widgets/dropdownbtn.dart';
import 'map_page.dart';
import 'order_view_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  List<Appointment> appointments = [];
  List<Order> orders = [];
  final Utilities utilities = Utilities();
  String totalOrder='';
  String totalSpend='';
  double money=0.0;

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
    fetchAppointments();
    fetchOrders();
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

  Future<void> fetchOrders() async {
    final fetchedOrders = await utilities.fetchOrders();
    setState(() {
      orders = fetchedOrders;
      totalOrder = orders.length.toString();
      for(var data in orders){
        if(data.isPaid==1){
          money += data.orderPrice!;
        }
      }
      totalSpend = money.toString();
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
                          SizedBox(
                            height: 50,
                              width: 50,
                              child: CustomButtonTest()
                          )

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
                      Card(
                        color: Styles.highlightColor,
                        elevation: 3,
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 5,
                        ),
                        clipBehavior: Clip.hardEdge,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const OrderViewPage()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30,bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '\$$totalSpend',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Total spend",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      totalOrder,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Total order",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(5),
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'Address: ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (_) => const MapPage()));
                                                },
                                                child: const Text(
                                                  'Open map',
                                                  style: TextStyle(
                                                    color: Colors.cyan,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
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
                                          const Text(
                                            '828 Sư Vạn Hạnh, Phường 12, Quận 10, TP HCM',
                                            style: TextStyle(
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
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              headerAnimationLoop: true,
                                              transitionAnimationDuration: const Duration(milliseconds: 500),
                                              animType: AnimType.bottomSlide,
                                              title: 'Cancel Appointment',
                                              titleTextStyle: const TextStyle(color: Colors.cyan,fontWeight: FontWeight.w600,fontSize: 20),
                                              desc: 'Are you sure you want to cancel this appointment?',
                                              descTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                              buttonsTextStyle: const TextStyle(color: Colors.black),
                                              showCloseIcon: false,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                Navigator.of(context).pop();
                                                cancelAppointment(appointment.id);
                                              },
                                            ).show();
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
                                                      id: appointment.id,
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
