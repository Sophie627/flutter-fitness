import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/signIn.dart';
import 'package:onboarding_flow/screens/signUp.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
              Column(
                children: [
                  boldText(text: 'Hi there,'),
                  boldText(text: "I'm FootyLab"),
                ],
              ),
              SizedBox(height: height * 0.058),
              Column(
                children: [
                  regularText(text: 'YOUR NEW PERSONAL'),
                  regularText(text: "TRAINER COMPANION"),
                ],
              ),
              SizedBox(height: height * 0.146),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SignUp(),
                    ),
                  );
                },
                child: CustomButton(
                  text: 'Hey FootyLab!',
                ),
              ),
              SizedBox(height: height * 0.058),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SignIn(),
                    ),
                  );
                },
                child: Text(
                  "I Already Have an Account",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color(0xffbdd0e9).withOpacity(0.90),
                  ),
                ),
              ),
              SizedBox(height: height * 0.073),
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText regularText({String text}) {
    return AutoSizeText(
      text,
      maxLines: 1,
      maxFontSize: 25,
      minFontSize: 20,
      style: TextStyle(
        letterSpacing: 3.0,
        fontFamily: "Roboto",
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
        color: Color(0xffb8b8f0),
      ),
    );
  }

  Text boldText({String text}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Arial Rounded MT",
        fontWeight: FontWeight.w700,
        fontSize: 35,
        color: Color(0xfffffefd),
      ),
    );
  }
}
