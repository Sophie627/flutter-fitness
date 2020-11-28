import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/team1.dart';

class Nickname extends StatefulWidget {
  @override
  _NicknameState createState() => _NicknameState();
}

class _NicknameState extends State<Nickname> {
  final TextEditingController _nickName = new TextEditingController();

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
              //   height: height * 0.01,
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
                  controller: _nickName,
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
              SizedBox(height: 100.0),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => Team1(
                        nickname: _nickName.text,
                      ),
                    ),
                  );
                },
                child: CustomButton(
                  text: 'CONTINUE',
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
