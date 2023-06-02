import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:pet_care/pages/register_pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/styles.dart';
import '../../widgets/my_button.dart';

class UpdateInfo extends StatefulWidget {
  const UpdateInfo({Key? key}) : super(key: key);

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  final emailController = TextEditingController();
  final fullnameController = TextEditingController();
  final phonenumerController = TextEditingController();
  String name = '';
  String email = '';
  String phonenumber = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
  }

  Future<void> loadDataFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('fullname') ?? '';
      email = prefs.getString('email') ?? '';
      phonenumber = prefs.getString('phonenumber') ?? '';

      emailController.text=email;
      fullnameController.text=name;
      phonenumerController.text=phonenumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 90, horizontal: 10),
          decoration: BoxDecoration(
              color: HexColor("#ffffff"),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        Center(
                          child: Text(
                            "Edit User Info",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#4f4f4f"),
                            ),
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
                              } else if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null; // Return null if the input is valid
                            },
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: HexColor("#4f4f4f"),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined),
                              hintText: "Enter your email",
                              fillColor: HexColor("#f0f3f1"),
                              contentPadding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Full name",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: HexColor("#8d8d8d"),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: fullnameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            cursorColor: HexColor("#4f4f4f"),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.account_circle_outlined),
                              hintText: "Enter your full name",
                              fillColor: HexColor("#f0f3f1"),
                              contentPadding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Phone number",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: HexColor("#8d8d8d"),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: phonenumerController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            cursorColor: HexColor("#4f4f4f"),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.account_circle_outlined),
                              hintText: "Enter your phone number",
                              fillColor: HexColor("#f0f3f1"),
                              contentPadding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MyButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  headerAnimationLoop: true,
                                  transitionAnimationDuration: const Duration(milliseconds: 500),
                                  animType: AnimType.bottomSlide,
                                  title: 'Edit profile',
                                  titleTextStyle: const TextStyle(color: Colors.cyan,fontWeight: FontWeight.w600,fontSize: 20),
                                  desc: 'Are you sure you change your info?',
                                  descTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                  buttonsTextStyle: const TextStyle(color: Colors.black),
                                  showCloseIcon: false,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    editUserInfo();
                                  },
                                ).show();
                              }
                            },
                            buttonText: 'Save Changes',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> editUserInfo() async {
    String email = emailController.text;
    String phoneNumber = phonenumerController.text;
    String fullname = fullnameController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtToken")!;
    String userId = prefs.getString("userId")!;
    String url = 'http://10.0.2.2:8080/api/v1/auth/$userId/updateUserInfo';
    String body = jsonEncode({
      "email": email,
      "fullname": fullname,
      "phonenumber": phoneNumber
    });
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'User information updated successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Styles.highlightColor,
        textColor: Colors.white,
      );
      // You can handle navigation or other actions here after successful update
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(
        msg: 'Invalid request. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Styles.highlightColor,
        textColor: Colors.white,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Update Failed'),
            content: const Text('Something went wrong. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
