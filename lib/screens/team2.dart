import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_flow/custom/customButton.dart';
import 'package:onboarding_flow/custom/customRegularText.dart';
import 'package:onboarding_flow/custom/customTextField.dart';
import 'package:onboarding_flow/res/colors.dart';
import 'package:onboarding_flow/screens/team3.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Team2 extends StatefulWidget {

  final String nickName;

  Team2({this.nickName});

  @override
  _Team2State createState() => _Team2State();
}

class _Team2State extends State<Team2> {
  String selectedState;
  List<DropdownMenuItem> stateItems = [];
  String selectedClub;
  List<DropdownMenuItem> clubItems = [];
  String selectedPosition;
  List<DropdownMenuItem> positionItems = [];
  final TextEditingController _jersey = new TextEditingController();
  final TextEditingController _birthday = new TextEditingController();
  DateTime date = DateTime.now();
  bool isLoading = true;

  fetchData() {
    Firestore.instance.collection('states').snapshots().listen((value) {
      value.documents.forEach((element) { 
        stateItems.add(DropdownMenuItem(
          child: Text(element['name']),
            value: element.documentID,
        ));
      });
      setState(() {
        stateItems = stateItems;
      });
    });
    Firestore.instance.collection('clubs').snapshots().listen((value) {
      value.documents.forEach((element) { 
        clubItems.add(DropdownMenuItem(
          child: Text(element['name']),
            value: element.documentID,
        ));
      });
      setState(() {
        clubItems = clubItems;
      });
    });
    Firestore.instance.collection('positions').snapshots().listen((value) {
      value.documents.forEach((element) { 
        positionItems.add(DropdownMenuItem(
          child: Text(element['name']),
            value: element.documentID,
        ));
      });
      setState(() {
        positionItems = positionItems;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
                text: '${widget.nickName} - That\'s awesome! Tell\nme more about your team!',
              ),
              SizedBox(
                height: height * 0.043,
              ),
              SearchableDropdown.single(
                items: stateItems,
                value: selectedState,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  color: Colors.white,
                ),
                hint: "YOUR STATE",
                searchHint: "Select your state",
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                  });
;                },
                isExpanded: true,
              ),
              SizedBox(height: height * 0.04),
              SearchableDropdown.single(
                items: clubItems,
                value: selectedClub,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  color: Colors.white,
                ),
                hint: "CLUB & LEAGUE",
                searchHint: "Select club & league",
                onChanged: (value) {
                  setState(() {
                    selectedClub = value;
                  });
;                },
                isExpanded: true,
              ),
              SizedBox(height: height * 0.04),
              SearchableDropdown.single(
                items: positionItems,
                value: selectedPosition,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  color: Colors.white,
                ),
                hint: "POSITION",
                searchHint: "Select position",
                onChanged: (value) {
                  setState(() {
                    selectedPosition = value;
                  });
;                },
                isExpanded: true,
              ),
              SizedBox(height: height * 0.04),
              CustomTextField(
                controller: _jersey,
                hintText: 'JERSEY #',
              ),
              SizedBox(height: height * 0.014),
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
                      builder: (ctx) => Team3(
                        userInfo: {
                          'nickName': widget.nickName,
                          'state': selectedState,
                          'club': selectedClub,
                          'position': selectedPosition,
                          'jersey': _jersey.text,
                          'birthday': date,
                        },
                      ),
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
