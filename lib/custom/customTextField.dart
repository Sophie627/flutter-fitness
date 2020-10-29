import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;

  CustomTextField({this.hintText});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.109,
      decoration: BoxDecoration(
        color: Color(0xff1e4f91),
        borderRadius: BorderRadius.circular(10.00),
      ),
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Roboto",
          fontSize: 20,
          color: Color(0xffffffff),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(30),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: "Roboto",
            fontSize: 18,
            color: Color(0xfffffefd).withOpacity(0.60),
          ),
        ),
      ),
    );
  }
}
