import 'package:flutter/material.dart';
import 'package:pet_care/pages/register_pages/signup_body.dart';
import 'package:pet_care/pages/register_pages/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
          body: Center(
            child: SignUpBodyScreen(),
          ),
        ));
  }
}