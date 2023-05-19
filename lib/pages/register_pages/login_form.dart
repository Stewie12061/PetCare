import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:pet_care/pages/register_pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../homepage/homepage.dart';
import '../../utils/styles.dart';
import '../../widgets/my_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    const url = 'http://10.0.2.2:8080/api/v1/auth/signin';
    String body = jsonEncode({
      "userName": username,
      "password": password,
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print(response.body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final userId = responseData['id'];
      final jwtToken = responseData['accessToken'];
      final email = responseData['email'];
      final username = responseData['username'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId.toString());
      await prefs.setString('jwtToken', jwtToken.toString());
      await prefs.setString('email', email.toString());
      await prefs.setString('username', username.toString());

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Login Fail'),
            content: Text('Username or password is incorrect'),
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

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateUsername(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Username can not be empty";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: Image.asset(
                    'assets/images/login.png',
                    height: 250,
                    width: double.infinity,
                  ),
                ),
                Stack(
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
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Log In",
                                    style: GoogleFonts.poppins(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#4f4f4f"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Username",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: usernameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter username';
                                        }
                                        return null;
                                      },
                                      cursorColor: HexColor("#4f4f4f"),
                                      decoration: InputDecoration(
                                        hintText: "Username",
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
                                        prefixIcon: Icon(Icons.lock_outline),
                                        prefixIconColor: HexColor("#4f4f4f"),
                                        filled: true,
                                      ),
                                      onSaved: (value) {
                                        setState(() => usernameController.text = value!);
                                      },
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        _errorMessage,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      validator: (passwordKey) {
                                        if (passwordKey!.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      },
                                      obscureText: true,
                                      cursorColor: HexColor("#4f4f4f"),
                                      decoration: InputDecoration(
                                        hintText: "**********",
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
                                        prefixIcon: Icon(Icons.lock_outline),
                                        prefixIconColor: HexColor("#4f4f4f"),
                                        filled: true,
                                      ),
                                      onSaved: (value) {
                                        setState(() => passwordController.text = value!);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          signIn();
                                        }
                                      },
                                      buttonText: 'Submit',
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Text("Don't have an account?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#8d8d8d"),
                                              )),
                                          TextButton(
                                            child: Text(
                                              "Sign Up",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#44564a"),
                                              ),
                                            ),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                const SignUpScreen(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

