import 'package:flutter/material.dart';

class CustomRegularText extends StatelessWidget {
  final String text;

  CustomRegularText({this.text});
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        this.text,
        style: TextStyle(
          fontSize: 30,
          fontFamily: "Roboto",
          color: Color(0xfffffefd).withOpacity(0.80),
        ),
      ),
    );
  }
}
