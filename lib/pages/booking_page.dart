import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_care/service/Utilities.dart';
import 'package:pet_care/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const.dart';
import '../models/package.dart';
import '../utils/Config.dart';
import '../utils/styles.dart';
import '../widgets/datetime_convert.dart';

class BookingPage extends StatefulWidget {
  final Package package;

  const BookingPage({super.key, required this.package});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  //declaration
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? token; //get token for insert booking date and time into database

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    getToken();
    super.initState();
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
          'Appointment for ${widget.package.name}',
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
                      setState(() {
                        _currentIndex = index;
                        _timeSelected = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: _currentIndex == index
                            ? Config.primaryColor
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
                  onPressed: () async {
                    //convert date/day/time into string first
                    final getDate = DateConverted.getDate(_currentDay);
                    final getDay = DateConverted.getDay(_currentDay.weekday);
                    final getTime = DateConverted.getTime(_currentIndex!);
                    print(getDate+" "+getDay+" "+getTime);

                    final booking = await Utilities().bookAppointment(widget.package.id,
                        getDate, getDay, getTime);

                    if (booking == 200) {
                      Navigator.of(context).pushNamed('success_booking');
                    }else{
                      Fluttertoast.showToast(
                        msg: 'Something when wrong \nPlease try again later',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Styles.highlightColor,
                        textColor: Colors.white,
                      );
                    }

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