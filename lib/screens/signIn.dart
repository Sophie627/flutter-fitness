import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_flow/business/auth.dart';
import 'package:onboarding_flow/business/validator.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customTextField.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/signUp.dart';
import 'package:onboarding_flow/ui/widgets/custom_alert_dialog.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  bool _blackVisible = false;
  VoidCallback onBackPress;

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
                hintText: 'EMAIL',
                controller: _email,
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'PASSWORD',
                controller: _password,
                obscureText: true,
              ),
              SizedBox(
                height: height * 0.0073,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/resetpassword");
                },
                child: Row(
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
                  onPressed: () {
                    _emailLogin(
                      email: _email.text,
                      password: _password.text,
                      context: context);
                  },
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

  void _emailLogin({String email, String password, BuildContext context}) async {
    if (Validator.validateEmail(email) &&
        Validator.validatePassword(password)) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _changeBlackVisible();
        await Auth.signIn(email, password)
            .then((uid) => Navigator.pushNamed(context, "/main"));
            // .then((uid) => Navigator.of(context).pop());
      } catch (e) {
        print("Error in email sign in: $e");
        String exception = Auth.getExceptionText(e);
        _showErrorAlert(
          title: "Login failed",
          content: exception,
          onPressed: _changeBlackVisible,
        );
      }
    }
  }

  void _changeBlackVisible() {
    setState(() {
      _blackVisible = !_blackVisible;
    });
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }
}
