import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


class ProfileScreen extends StatefulWidget {
  final Settings settings;

  ProfileScreen({this.settings});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  String h1 = '';
  String h2 = '';
  String selectedPosition = '';
  String selectedState = '';
  String selectedClub = '';
  List<DropdownMenuItem> positionList = [];
  List<DropdownMenuItem> stateList = [];
  List<DropdownMenuItem> clubList = [];
  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController jersey = new TextEditingController();
  DateTime date = DateTime.now();

  fetchUserData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Firestore.instance.document("users/${user.uid}").snapshots().listen((value) { 
        print('userInfo ${value['firstName']}');
        name.text = value['firstName'];
        email.text = value['email'];
        jersey.text = value['jersey'];
        selectedPosition = value['position'];
        selectedState = value['state'];
        selectedClub = value['club'];
        date = DateTime.fromMillisecondsSinceEpoch(value['birthday'].seconds * 1000);
      });
    }
  }

  fetchData() {
    Firestore.instance.collection('positions').snapshots().listen((value) {
      value.documents.forEach((element) { 
        positionList.add(DropdownMenuItem(
          child: Text(element['name']),
            value: element.documentID,
        ));
      });
      setState(() {
        positionList = positionList;
        isLoading = false;
      });
    });
    Firestore.instance.collection('states').snapshots().listen((value) {
      value.documents.forEach((element) { 
        stateList.add(DropdownMenuItem(
          child: Text(element['name']),
            value: element.documentID,
        ));
      });
      setState(() {
        stateList = stateList;
        isLoading = false;
      });
    });
    Firestore.instance.collection('clubs').snapshots().listen((value) {
      value.documents.forEach((element) { 
        clubList.add(DropdownMenuItem(
          child: Text(element['name']),
            value: element.documentID,
        ));
      });
      setState(() {
        clubList = clubList;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    fetchUserData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.push(context, 
              PageTransition(
                child: MainScreen(
                  settings: widget.settings,
                ), 
                type: PageTransitionType.leftToRight,
              ),
            )),
        title: Text(
          'PROFILE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'HEALTH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            title: Text(
              'Connect to Apple Health',
            ),
            subtitle: Text(
              'Pre-fill your profile and track your workouts on Apple Health for morerobust health tracking.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(80, 8, 0, 8),
            child: Text(
              'Connect',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              'PERSONAL',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Name',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    
                  ),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your email',
                    ),
                  ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchableDropdown.single(
                    items: clubList,
                    value: selectedClub,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    searchHint: "Club",
                    onChanged: (value) {
                      setState(() {
                        selectedClub = value;
                      });
                    },
                    isExpanded: true,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchableDropdown.single(
                    items: stateList,
                    value: selectedState,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    // hint: selectedState,
                    searchHint: "State",
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                    isExpanded: true,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchableDropdown.single(
              items: positionList,
              value: selectedPosition,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                color: Colors.black,
              ),
              searchHint: "Select position",
              onChanged: (value) {
                setState(() {
                  selectedPosition = value;
                });
              },
              isExpanded: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextField(
                controller: jersey,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Jersey',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 66.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  updateProfile();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen()
                      ));
                },
                child: Text('Update Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  updateProfile() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('users').document(user.uid)
      .updateData({
        'email': email.text,
        'firstName': name.text,
        'birthday': date,
        'state': selectedState,
        'club': selectedClub,
        'position': selectedPosition,
        'jersey': jersey.text,
      })
      .then((value) => print("Profile Updated"))
      .catchError((error) => print("Failed to update profile: $error"));
  }
}
