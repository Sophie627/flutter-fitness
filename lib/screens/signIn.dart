import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customTextField.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/signUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(blueColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
              SizedBox(height: height * 0.073),
              Center(
                child: Image.asset('assets/images/accountLoginLogo.png'),
              ),
              SizedBox(height: height * 0.058),
              buildRegularText(text: 'Account'),
              buildRegularText(text: 'Login'),
              SizedBox(height: height * 0.058),
              CustomTextField(
                hintText: 'EMAIL.',
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'PASSWORD',
              ),
              SizedBox(
                height: height * 0.0073,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AutoSizeText(
                    "Forget?",
                    maxFontSize: 20,
                    minFontSize: 18,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      color: Color(0xff5184c7).withOpacity(0.80),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.146,
              ),
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
                  text: 'SIGN IN',
                ),
              ),
              SizedBox(height: height * 0.014),
              AutoSizeText(
                "By signing in, you agree to our terms and  \n           conditions and privacy policy ",
                maxFontSize: 17,
                minFontSize: 15,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Roboto",
                  color: Color(0xffd5e1f1).withOpacity(0.90),
                ),
              ),
              SizedBox(
                height: height * 0.029,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildRegularText({String text}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 40,
        color: Color(0xfffffefd).withOpacity(0.90),
      ),
    );
  }
}
