import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_care/service/Utilities.dart';
import 'package:pet_care/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../models/package.dart';
import '../utils/Config.dart';
import '../utils/styles.dart';
import '../widgets/datetime_convert.dart';

class ReschedulePage extends StatefulWidget {
  final int packageId;
  final String groomingPackageName;
  final double price;

  const ReschedulePage({super.key, required this.packageId, required this.groomingPackageName, required this.price});

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  //declaration
  List<bool> availableTimeSlots = [];
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  void initState() {
    super.initState();
    initializeAvailableTimeSlots();

  }
  Future<void> initializeAvailableTimeSlots() async {
    final selectedDate = _currentDay; // Get the selected date

    final formattedDate = DateConverted.getDate(selectedDate);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String url = "http://10.0.2.2:8080/api/v1/";
    Uri uri = Uri.parse("${url}appointment/checkAvailable?date=$formattedDate");
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final availabilityData = json.decode(response.body);

      setState(() {
        availableTimeSlots = List.generate(8, (index) {
          final timeSlot = index + 9;
          final formattedTime = timeSlot > 11 ? '$timeSlot:00 PM' : '$timeSlot:00 AM';
          return !availabilityData['bookedTimeSlots'].contains(formattedTime);
        });
      });
    } else {
      // Handle error case
      print('Failed to fetch availability');
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Styles.highlightColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: black.withOpacity(0.7),
            size: 18,
          ),
        ),
        title: Text(
          'Reschedule for ${widget.groomingPackageName}',
          style: poppin.copyWith(
              fontSize: 18, color: black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  _tableCalendar(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    child: Center(
                      child: Text(
                        'Select Consultation Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            _isWeekend
                ? SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 30),
                alignment: Alignment.center,
                child: const Text(
                  'Weekend is not available, please select another date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
                : SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (availableTimeSlots[index!]){
                        setState(() {
                          _currentIndex = index;
                          _timeSelected = true;
                        });
                      }else{
                        Fluttertoast.showToast(
                          msg: 'Selected time slot is not available',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Styles.highlightColor,
                          textColor: Colors.white,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:  _currentIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: _currentIndex == index ? Config.primaryColor
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                          _currentIndex == index ? Colors.white : null,
                        ),
                      ),
                    ),
                  );
                },
                childCount: 8,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1.5),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                child: Button(
                  width: double.infinity,
                  title: 'Make Appointment',
                  onPressed: (){
                    //convert date/day/time into string first
                    final getDate = DateConverted.getDate(_currentDay);
                    final getDay = DateConverted.getDay(_currentDay.weekday);
                    final getTime = DateConverted.getTime(_currentIndex!);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                              child: Text(
                                'Confirm Appointment',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              )),
                          content: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Appointment on \n$getDay, $getDate",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.visible, // Change to 'ellipsis' if desired
                                  ),

                                  Text("At $getTime",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.visible, // Change to 'ellipsis' if desired
                                  )
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.highlightColor
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text('Confirm'),
                                    onPressed: () async {
                                      final booking = await Utilities().bookAppointment(
                                          widget.packageId,
                                          getDate, getDay, getTime, widget.price,1);
                                      if (booking == 200){
                                        Navigator.of(context).pushNamed('success_booking');
                                      }
                                      else {
                                        Fluttertoast.showToast(
                                          msg: 'Something when wrong \nPlease try again later',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Styles.highlightColor,
                                          textColor: Colors.white,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.highlightColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  disable: _timeSelected && _dateSelected ? false : true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //table calendar
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2023, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration:
        BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          _timeSelected = false;
          _currentIndex = null;
          initializeAvailableTimeSlots();

          //check if weekend is selected
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      }),
    );
  }
}