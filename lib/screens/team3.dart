import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<bool> checks = [];
  List<String> terms = [];
  bool isLoading = true;

  fetchTermData() {
    Firestore.instance.collection('scoutTerms').snapshots().listen((value) {
      value.documents.forEach((element) { 
        checks.add(false);
        terms.add(element['term']);
      });
      setState(() {
        checks = checks;
        terms = terms;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    fetchTermData();
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
                text:
                    'Hey ${widget.userInfo['nickName']} - If a player scout\nwas analyzing your game,\nwhat would you want them\nto say about the way you\nplay? Pick 3!',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              Container(
                child: Column(
                  children: isLoading
                  ? [Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      strokeWidth: 1,
                    ),
                  )]
                  : checkBoxList(height),
                ),
              ),
              SizedBox(height: height * 0.073),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SignUp(
                        userInfo: {
                          'nickName': widget.userInfo['nickName'],
                          'state': widget.userInfo['state'],
                          'club': widget.userInfo['club'],
                          'position': widget.userInfo['position'],
                          'jersey': widget.userInfo['jersey'],
                          'birthday': widget.userInfo['birthday'],
                          'term': checks,
                        },
                        isTeam: true,
                      ),
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

  List<Widget> checkBoxList(double height) {
    List<Widget> list = [];

    terms.asMap().forEach((key, value) { 
      list.add(
        checkBox(
          height: height,
          label: value,
          check: key,
          checkedValue: checks[key]),
      );
      list.add(SizedBox(height: height * 0.014),);
    });

    return list;
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
            value: checks[check],

            onChanged: (newValue) {
              if (checks.where((element) => element == true).length < 3 || (checks.where((element) => element == true).length == 3 && checks[check] == true)) {
                setState(() {
                  checks[check] = newValue;
                });
              }
            },
            controlAffinity:
                ListTileControlAffinity.trailing, //  <-- leading Checkbox
          ),
        ),
      ),
    );
  }
}
