import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/res/colors.dart';

import 'notifications.dart';

class Nickname extends StatefulWidget {
  @override
  _NicknameState createState() => _NicknameState();
}

class _NicknameState extends State<Nickname> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(blueColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.043,
              ),
              Center(
                child: Image.asset(
                  'assets/images/BlinkingLion.gif',
                  height: height * 0.2633,
                  width: width * 0.3475,
                ),
              ),
              SizedBox(
                height: height * 0.029,
              ),
              CustomRegularText(
                text: 'Nice to meet you! What do\nyour friends call you?',
              ),
              SizedBox(height: height * 0.146),
              Container(
                height: height * 0.114,
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
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(30),
                    border: InputBorder.none,
                    hintText: 'YOUR NICKNAME',
                    hintStyle: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20,
                      color: Color(0xfffffefd).withOpacity(0.60),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.219),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => Notificationss(),
                    ),
                  );
                },
                child: CustomButton(
                  text: 'SUBMIT',
                ),
              ),
              SizedBox(height: height * 0.073),
            ],
          ),
        ),
      ),
    );
  }
}
