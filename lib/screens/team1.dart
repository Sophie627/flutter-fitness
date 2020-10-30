import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/signUp.dart';
import 'package:onboarding_flow/screens/team2.dart';

class Team1 extends StatefulWidget {

  final String nickname;
  Team1({
    this.nickname,
  });

  @override
  _Team1State createState() => _Team1State();
}

class _Team1State extends State<Team1>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                text: widget.nickname + ' - I like it! Do you play for\na soccer team?',
              ),
              SizedBox(
                height: height * 0.2194,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => Team2(
                      nickName: widget.nickname,
                    )),
                  );
                },
                child: CustomButton(
                  text: 'YES!',
                ),
              ),
              SizedBox(
                height: height * 0.043,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SignUp(),
                    ),
                  );
                },
                child: Text(
                  "I Do Not Play for a Team",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 18,
                    color: Color(0xffffffff),
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
}