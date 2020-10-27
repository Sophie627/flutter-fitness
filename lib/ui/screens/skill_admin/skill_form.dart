import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/business/validator.dart';
import 'package:onboarding_flow/ui/widgets/custom_alert_dialog.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';
import 'package:onboarding_flow/ui/widgets/custom_text_field.dart';

class SkillFormScreen extends StatefulWidget {

  final String skillID;

  SkillFormScreen({this.skillID});

  @override
  _SkillFormScreenState createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  final TextEditingController skillName = new TextEditingController();
  final TextEditingController imageUrl = new TextEditingController();
  CustomTextField skillNameField;
  CustomTextField imageUrlField;
  bool _blackVisible = false;
  VoidCallback onBackPress;
  dynamic skillData;
  bool isLoading = true;

  fetchSkillDate() {
    if (widget.skillID == 'createskill!!!') {
      setState(() {
        isLoading = false;
      });
    } else {
      Firestore.instance.collection('skill').document(widget.skillID).get()
      .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data}');
          skillName.text = documentSnapshot.data['name'];
          imageUrl.text = documentSnapshot.data['url'];
          setState(() {
            skillData = documentSnapshot.data;
            isLoading = false;
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    onBackPress = () {
      Navigator.of(context).pop();
    };

    fetchSkillDate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: isLoading 
        ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            strokeWidth: 1,
          ),
        )
        : Stack(
          children: <Widget>[
            Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 70.0, bottom: 10.0, left: 30.0, right: 30.0),
                      child: Text(
                        widget.skillID == 'createskill!!!' ? 'Create a New Skill' : skillData['name'],
                        softWrap: true,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                      child: new CustomTextField(
                        baseColor: Colors.grey,
                        borderColor: Colors.grey[400],
                        errorColor: Colors.red,
                        controller: skillName,
                        hint: "Skill Name",
                        validator: Validator.validateName,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: CustomTextField(
                        baseColor: Colors.grey,
                        borderColor: Colors.grey[400],
                        errorColor: Colors.red,
                        controller: imageUrl,
                        hint: "Image URL",
                        validator: Validator.validateName,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 40.0),
                      child: CustomFlatButton(
                        title: "Save Skill",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.white,
                        onPressed: () {
                          _signUp(
                              fullname: skillName.text,
                              password: imageUrl.text);
                        },
                        splashColor: Colors.black12,
                        borderColor: Color.fromRGBO(59, 89, 152, 1.0),
                        borderWidth: 0,
                        color: Color.fromRGBO(59, 89, 152, 1.0),
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: onBackPress,
                        ),
                      ]
                    ),
                  ) 
                ),
              ],
            ),
            Offstage(
              offstage: !_blackVisible,
              child: GestureDetector(
                onTap: () {},
                child: AnimatedOpacity(
                  opacity: _blackVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
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
      String number,
      String email,
      String password,
      BuildContext context}) async {
    if (Validator.validateName(fullname) &&
        Validator.validateEmail(email) &&
        Validator.validateNumber(number) &&
        Validator.validatePassword(password)) {
      try {
        // SystemChannels.textInput.invokeMethod('TextInput.hide');
        // _changeBlackVisible();
        // await Auth.signUp(email, password).then((uID) {
        //   Auth.addUser(new User(
        //       userID: uID,
        //       email: email,
        //       firstName: fullname,
        //       profilePictureURL: ''));
        //   // onBackPress();
        //   Navigator.pushNamed(context, "/main");
        // });
      } catch (e) {
        print("Error in sign up: $e");
        // String exception = Auth.getExceptionText(e);
        // _showErrorAlert(
        //   title: "Signup failed",
        //   content: exception,
        //   onPressed: _changeBlackVisible,
        // );
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