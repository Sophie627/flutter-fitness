import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/delayed_animation.dart';
import 'package:onboarding_flow/screens/nickname.dart';
import 'package:onboarding_flow/screens/signIn.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

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
              DelayedAnimation(
                child: boldText(text: 'Hi there,'),
                delay: delayedAmount + 1000,
              ),
              DelayedAnimation(
                child: boldText(text: "I'm FootyLab"),
                delay: delayedAmount + 2000,
              ),
              SizedBox(height: height * 0.058),
              DelayedAnimation(
                child: regularText(text: 'YOUR NEW PERSONAL'),
                delay: delayedAmount + 3000,
              ),
              DelayedAnimation(
                child: regularText(text: "TRAINER COMPANION"),
                delay: delayedAmount + 3000,
              ),
              SizedBox(height: height * 0.146),
              DelayedAnimation(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => Nickname(),
                      ),
                    );
                  },
                  child: CustomButton(
                    text: 'Hey FootyLab!',
                  ),
                ),
                delay: delayedAmount + 4000,
              ),
              SizedBox(height: height * 0.058),
              DelayedAnimation(
                child: InkWell(
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
                delay: delayedAmount + 5000,
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
