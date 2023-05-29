import 'package:flutter/material.dart';
import 'package:pet_care/pages/reschedule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/apointment.dart';
import '../service/Utilities.dart';
import '../utils/Config.dart';
import '../widgets/schedule_card.dart';
import 'map_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

//enum for appointment status
enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming; //initial status
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];
  final Utilities utilities = Utilities();
  List<Appointment> appointments = [];
  late int statusFetch=1;
  bool canceled=false;
  bool completed=false;

  Future<void> fetchAppointments(int status) async {
    final fetchedAppointments = await utilities.fetchAppointments(status);
    appointments.clear();
    setState(() {
      appointments = fetchedAppointments;
    });
  }
  Future<void> cancelAppointment(int appointmentId) async {
    try {
      int status = await utilities.cancelAppointment(appointmentId);

      if (status == 200) {
        // Appointment canceled successfully
        // Refresh the list of appointments or handle as needed
        fetchAppointments(statusFetch);
      } else {
        // Handle API error
        print('Failed to cancel appointment');
      }
    } catch (error) {
      // Handle network or server error
      print('Failed to cancel appointment. Error: $error');
    }
  }

  @override
  void initState() {
    fetchAppointments(statusFetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Appointment Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //this is the filter tabs
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.upcoming) {
                                  status = FilterStatus.upcoming;
                                  _alignment = Alignment.centerLeft;
                                  statusFetch = 1;
                                  fetchAppointments(statusFetch);
                                  canceled=false;
                                  completed=false;
                                } else if (filterStatus ==FilterStatus.complete) {
                                  status = FilterStatus.complete;
                                  _alignment = Alignment.center;
                                  statusFetch = 2;
                                  fetchAppointments(statusFetch);
                                  canceled=false;
                                  completed=true;
                                } else if (filterStatus ==FilterStatus.cancel) {
                                  status = FilterStatus.cancel;
                                  _alignment = Alignment.centerRight;
                                  statusFetch = 3;
                                  fetchAppointments(statusFetch);
                                  canceled = true;
                                  completed = false;
                                }
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: ((context, index) {
                  var schedule = appointments[index];
                  bool isLastElement = appointments.length + 1 == index;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black45,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: !isLastElement
                        ? const EdgeInsets.only(bottom: 20)
                        : EdgeInsets.zero,
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
                                  const Text(
                                    '828 Sư Vạn Hạnh, Phường 12, Quận 10, TP HCM',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
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
                          ScheduleCard(
                            date: schedule.date,
                            day: schedule.day,
                            time: schedule.time,
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
                                            title: const Text('Cancel Appointment'),
                                            content: const Text('Are you sure you want to cancel this appointment?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  cancelAppointment(schedule.id);
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
                                    TextStyle(color: Config.colorBlack),
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
                                              packageId: schedule.packageId,
                                              price: schedule.price,
                                              groomingPackageName: schedule.groomingPackageName,
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
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
