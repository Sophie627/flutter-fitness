import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/team1.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';

class Notificationss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(blueColor),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
        )
      ),
      backgroundColor: Color(blueColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
              // SizedBox(
              //   height: height * 0.043,
              // ),
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
                text: 'Last thing - want me to send\nyou some notifications?',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              Image.asset('assets/images/notification.png'),
              SizedBox(height: height * 0.058),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => MainScreen()),
                  );
                },
                child: CustomButton(
                  text: 'YES PLEASE!',
                ),
              ),
              SizedBox(
                height: height * 0.043,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => MainScreen()),
                  );
                },
                child: Text(
                  "NO THANKS",
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
