import 'package:flutter/material.dart';

import '../utils/config.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
        required this.width,
        required this.title,
        required this.onPressed,
        required this.disable})
      : super(key: key);

  final double width;
  final String title;
  final bool disable; //this is used to disable button
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: SizedBox(
        width: width,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Config.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: disable ? null : onPressed,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}