import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pet_care/pages/register_pages/signup_form.dart';

import '../../utils/styles.dart';
import 'flow_controller.dart';

class SignUpBodyScreen extends StatefulWidget {
  const SignUpBodyScreen({super.key});

  @override
  State<SignUpBodyScreen> createState() => _SignUpBodyScreenState();
}

class _SignUpBodyScreenState extends State<SignUpBodyScreen> {
  FlowController flowController = Get.put(FlowController());
  late int _currentFlow;
  @override
  void initState() {
    _currentFlow = FlowController().currentFlow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.bgColor,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor("#ffffff"),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: const SignUpForm()
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                    offset: const Offset(0, 0),
                    child: Image.asset(
                      'assets/images/signup.png',
                      scale: 1,
                      width: double.infinity,
                      height: 250,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}