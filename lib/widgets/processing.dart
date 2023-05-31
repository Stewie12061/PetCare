import 'package:flutter/material.dart';
import '../widgets/button.dart';
import 'dart:async';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  _ProcessingScreenState createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a 3-second loading delay
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              flex: 3,
              child: Image.asset('assets/images/success.jpg'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: _isLoading
                  ? null
                  : const Text(
                'Successfully Order',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Button(
                  width: double.infinity,
                  title: 'Back to Home Page',
                  onPressed: () => Navigator.of(context).pushNamed('home'),
                  disable: false,
                ),
              )
          ],
        ),
      ),
    );
  }
}
