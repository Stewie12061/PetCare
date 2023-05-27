import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/appointment_page.dart';

class VetDetail extends StatelessWidget {
  const VetDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: AppointmentPage()
    );
  }
}