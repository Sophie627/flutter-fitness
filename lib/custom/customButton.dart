import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: GestureDetector( 
        onTap: onPressed,
        child: Container(
          height: height * 0.102,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            border: Border.all(
              width: 1.00,
              color: Color(0xff707070),
            ),
            borderRadius: BorderRadius.circular(50.00),
          ),
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xff2765b8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
