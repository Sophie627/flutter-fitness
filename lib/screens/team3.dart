import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/signUp.dart';

class Team3 extends StatefulWidget {

  final Map userInfo;

  Team3({this.userInfo});

  @override
  _Team3State createState() => _Team3State();
}

class _Team3State extends State<Team3> {
  // bool check1 = false;
  // bool check2 = true;
  // bool check3 = false;
  // bool check4 = false;

  List<bool> checks = [false, false, false, false];
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
                text:
                    'Hey ${widget.userInfo['nickName']} - If a player scout\nwas analyzing your game,\nwhat would you want them\nto say about the way you\nplay? Pick 3!',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              checkBox(
                  height: height,
                  label: 'Strong with the ball in\nthe feet',
                  check: 0,
                  checkedValue: checks[0]),
              SizedBox(height: height * 0.014),
              checkBox(
                  height: height,
                  label: 'Shows great pace and\nreading of the game',
                  check: 1,
                  checkedValue: checks[1]),
              SizedBox(height: height * 0.014),
              checkBox(
                  height: height,
                  label: 'Can simple do it all',
                  check: 2,
                  checkedValue: checks[2]),
              SizedBox(height: height * 0.014),
              checkBox(
                  height: height,
                  label: 'High success rate in\npenalty kicks',
                  check: 3,
                  checkedValue: checks[3]),
              SizedBox(height: height * 0.073),
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
                  text: 'YES!',
                ),
              ),
              SizedBox(height: height * 0.102),
            ],
          ),
        ),
      ),
    );
  }

  Container checkBox({
    double height,
    int check,
    String label,
    bool checkedValue,
  }) {
    return Container(
      height: height * 0.109,
      decoration: BoxDecoration(
        color: Color(0xff1e4f91),
        borderRadius: BorderRadius.circular(10.00),
      ),
      child: Center(
        child: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: CheckboxListTile(
            activeColor: Colors.white,
            checkColor: Color(blueColor),
            title: new AutoSizeText(
              label,
              maxLines: 2,
              maxFontSize: 20,
              minFontSize: 18,
              style: TextStyle(
                fontFamily: "Roboto",
                color: Color(0xfffffefd).withOpacity(0.60),
              ),
            ),
            value: check == 0
                ? checks[0]
                : check == 1
                    ? checks[1]
                    : check == 2
                        ? checks[2]
                        : check == 3
                            ? checks[3]
                            : false,

            onChanged: (newValue) {
              setState(() {
                if (check == 0) {
                  checks[0] = newValue;
                } else if (check == 1) {
                  checks[1] = newValue;
                } else if (check == 2) {
                  checks[2] = newValue;
                } else if (check == 3) {
                  checks[3] = newValue;
                }
              });
            },
            controlAffinity:
                ListTileControlAffinity.trailing, //  <-- leading Checkbox
          ),
        ),
      ),
    );
  }
}
