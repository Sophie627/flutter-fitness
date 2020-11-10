import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_flow/business/auth.dart';
import 'package:onboarding_flow/business/validator.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/custom/customTextField.dart';
import 'package:onboarding_flow/models/user.dart';
import 'package:onboarding_flow/res/colors.dart';
// import 'package:onboarding_flow/screens/notifications.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/ui/widgets/custom_alert_dialog.dart';

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
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confirmPassword = new TextEditingController();
  bool _blackVisible = false;

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
                text: '${widget.userInfo['nickName']} - I like it! Let\'s get your\naccount finished up',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              CustomTextField(
                hintText: 'YOUR EMAIL',
                controller: _email,
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'ACCOUNT PASSWORD',
                controller: _password,
                obscureText: true,
              ),
              SizedBox(height: height * 0.014),
              CustomTextField(
                hintText: 'CONFIRMED PASSWORD',
                controller: _confirmPassword,
                obscureText: true,
              ),
              SizedBox(height: height * 0.04),
              !widget.isTeam
              ? Row(
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
              )
              : SizedBox(height: 0),
              SizedBox(height: height * 0.073),
              InkWell(
                onTap: () {
                  _signUp(
                    fullname: widget.userInfo['nickName'],
                    email: _email.text,
                    password: _password.text);
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

  void _changeBlackVisible() {
    setState(() {
      _blackVisible = !_blackVisible;
    });
  }

  void _signUp(
      {String fullname,
      String email,
      String password,
      BuildContext context}) async {
    if (_email.text == '') {
      _showErrorAlert(
        title: "Email Error",
        content: "Please enter email address",
        onPressed: _changeBlackVisible,
      );
      return;
    }
    if (_confirmPassword.text != _password.text) {
      _showErrorAlert(
        title: "Password Error",
        content: "Password not match",
        onPressed: _changeBlackVisible,
      );
      return;
    }
    if (Validator.validateEmail(email) &&
        Validator.validatePassword(password)) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _changeBlackVisible();
        await Auth.signUp(email, password).then((uID) {
          if (widget.isTeam) {
            Auth.addUser(new User(
              userID: uID,
              email: email,
              firstName: fullname,
              profilePictureURL: '',
              birthday: widget.userInfo['birthday'],
              state: widget.userInfo['state'],
              club: widget.userInfo['club'],
              position: widget.userInfo['position'],
              jersey: widget.userInfo['jersey'],
              term: widget.userInfo['term'],
              ));
          } else {
            Auth.addUser(new User(
              userID: uID,
              email: email,
              firstName: fullname,
              profilePictureURL: '',
              birthday: date,
              ));
          }
          // onBackPress();
          // Navigator.pushNamed(context, "/main");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => MainScreen(),
            ),
          );
        });
      } catch (e) {
        print("Error in sign up: $e");
        String exception = Auth.getExceptionText(e);
        _showErrorAlert(
          title: "Signup failed",
          content: exception,
          onPressed: _changeBlackVisible,
        );
      }
    }
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
