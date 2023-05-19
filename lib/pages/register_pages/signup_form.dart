import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:pet_care/pages/register_pages/login.dart';
import '../../utils/styles.dart';
import '../../widgets/my_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30,0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 67,
                ),
                Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // Return null if the input is valid
                    },
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: "Enter your email",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    onSaved: (value) {
                      setState(() => emailController.text = value!);
                    },

                  ),
                  Text(
                    "Username",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      hintText: "Enter Username",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    onSaved: (value) {
                      setState(() => emailController.text = value!);
                    },
                  ),
                  Text(
                    "Password",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: passwordContoller,
                    validator: (passwordKey) {
                      if (passwordKey!.isEmpty) {
                        return 'Please enter password';
                      }
                      if (passwordKey.length < 8) {
                        return 'Password should be more than 8 characters';
                      }
                      return null;
                    },
                    obscureText: true,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Enter password",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      focusColor: HexColor("#44564a"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUpUser();
                      }
                    },
                    buttonText: 'Sign Up',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUpUser() async{
    String email = emailController.text;
    String username = nameController.text;
    String password = passwordContoller.text;
    const url = 'http://10.0.2.2:8080/api/v1/auth/signup';
    String body = jsonEncode({
      "userName": username,
      "password": password,
      "email" : email
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
              msg: 'Account created successfully!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Styles.highlightColor,
              textColor: Colors.white,
            );
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    }else if (response.statusCode==400){
      Fluttertoast.showToast(
        msg: 'Account already exists',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Styles.highlightColor,
        textColor: Colors.white,
      );
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Sign up Fail'),
            content: Text('Something went wrong please try again later'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}