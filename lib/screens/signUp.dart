import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/custom/customTextField.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/notifications.dart';

class SignUp extends StatefulWidget {

  final Map userInfo;
  final bool isTeam;

  SignUp({this.userInfo,
    this.isTeam = false,
  });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    
    if (widget.isTeam) setState(() {
      date = widget.userInfo['birthday'];
    });
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
                text: '${widget.userInfo['nickName']} - I like it! Let\'s get your\naccount finished up',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              CustomTextField(
                hintText: 'YOUR EMAIL',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'ACCOUNT PASSWORD',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'CONFIRMED PASSWORD',
              ),
              SizedBox(height: height * 0.04),
              Row(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    child: RaisedButton(
                      child: Text("YOUR BIRTHDAY"),
                      onPressed: () => showMaterialDatePicker(
                        context: context,
                        selectedDate: date,
                        onChanged: (value) => setState(() => date = value),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat.yMMMd().format(date),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.073),
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
              SizedBox(height: height * 0.102),
            ],
          ),
        ),
      ),
    );
  }
}
