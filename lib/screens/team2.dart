import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/custom/customTextField.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/team3.dart';

class Team2 extends StatefulWidget {
  @override
  _Team2State createState() => _Team2State();
}

class _Team2State extends State<Team2> {
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
                text: 'Ivan - That\'s awesome! Tell\nme more about your team!',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              CustomTextField(
                hintText: 'YOUR STATE',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'CLUB & LEAGUE',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'POSITION',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'JERSEY #',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'YOUR BIRTHDAY',
              ),
              SizedBox(height: height * 0.073),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => Team3(),
                    ),
                  );
                },
                child: CustomButton(
                  text: 'SUBMIT',
                ),
              ),
              SizedBox(height: height * 0.102),
            ],
          ),
        ),
      ),
    );
  }
}
