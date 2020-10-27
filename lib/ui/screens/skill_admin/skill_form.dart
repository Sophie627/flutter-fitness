import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
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
  final TextEditingController restTime = new TextEditingController();
  final TextEditingController restMusicName = new TextEditingController();
  final TextEditingController trainTime = new TextEditingController();
  final TextEditingController trainMusicName = new TextEditingController();
  bool _blackVisible = false;
  VoidCallback onBackPress;
  dynamic skillData;
  bool isLoading = true;
  int touch = 1;
  Map restMap = {};
  Map trainMap = {};

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
          if (documentSnapshot.data['touch'] != null) {
            setState(() {
              touch = documentSnapshot.data['touch'];
            });
          }
          if (documentSnapshot.data['rest'] != null) {
            setState(() {
              restMap = documentSnapshot.data['rest'];
            });
          }
          if (documentSnapshot.data['train'] != null) {
            setState(() {
              trainMap = documentSnapshot.data['train'];
            });
          }
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
    print('voice $restMap $trainMap');
    return isLoading 
    ? Material(
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          strokeWidth: 1,
        ),
      ),
    )
    : Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          widget.skillID == 'createskill!!!' ? 'Create a New Skill' : skillData['name'],
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
            padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
            child:  Row(
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text("Touch Picker",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => showMaterialNumberPicker(
                      context: context,
                      title: "Pick Skill Touch",
                      maxNumber: 10,
                      minNumber: 1,
                      confirmText: "OK",
                      cancelText: "Cancel",
                      selectedNumber: touch,
                      onChanged: (value) => setState(() => touch = value),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      touch.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ), 
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Divider(
              color: Colors.grey[200],
              thickness: 2.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Text('Voice',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: Text('Rest',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                voiceList(restMap, 'rest'),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: restTime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Time',
                          ),
                        ),
                      ),
                      Text(' s: '),
                      Flexible(
                        child: TextField(
                          controller: restMusicName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Music Name',
                          ),
                        ),
                      ),
                      Text(' .mp3'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline), 
                        onPressed: addRestVoice),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: Text('Train',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                voiceList(trainMap, 'train'),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: trainTime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Time',
                          ),
                        ),
                      ),
                      Text(' s: '),
                      Flexible(
                        child: TextField(
                          controller: trainMusicName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Music Name',
                          ),
                        ),
                      ),
                      Text(' .mp3'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline), 
                        onPressed: addTrainVoice),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Divider(
              color: Colors.grey[200],
              thickness: 2.0,
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
    );
  }

  Widget voiceList(Map map, String field) {
    List<Widget> voiceList = [];
    map.forEach((key, value) {
      voiceList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${key}s: ${value}.mp3',
              style: TextStyle(
                fontSize: 22.0
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete,
                color: Colors.red,
                size: 32.0,
              ), 
              onPressed: () {
                if (field == 'rest') removeRestVoice(key);
                else removeTrainVoice(key); 
              },
            ),
          ],
        )
      );
    });
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 20.0),
      child: Column(
        children: voiceList,
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
      } catch (e) {
        print("Error in sign up: $e");
        // _showErrorAlert(
        //   title: "Signup failed",
        //   content: e,
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

  void addRestVoice() {
    if (restTime.text == '' || restMusicName.text == '') return;
    restMap[restTime.text] = restMusicName.text;
    Firestore.instance.collection('skill').document(widget.skillID)
      .updateData({'rest': restMap})
      .then((value) => print("Rest Voice Updated"))
      .catchError((error) => print("Failed to update rest voice: $error"));
    setState(() {
      restMap = restMap;
    });
    restTime.text = '';
    restMusicName.text = '';
  }

  void addTrainVoice() {
    if (trainTime.text == '' || trainMusicName.text == '') return;
    trainMap[trainTime.text] = trainMusicName.text;
    Firestore.instance.collection('skill').document(widget.skillID)
      .updateData({'train': trainMap})
      .then((value) => print("Train Voice Updated"))
      .catchError((error) => print("Failed to update train voice: $error"));
    setState(() {
      trainMap = trainMap;
    });
    trainTime.text = '';
    trainMusicName.text = '';
  }

  void removeRestVoice(String key) {
    restMap.remove(key);
    Firestore.instance.collection('skill').document(widget.skillID)
      .updateData({'rest': restMap})
      .then((value) => print("Rest Voice Updated"))
      .catchError((error) => print("Failed to update rest voice: $error"));
    setState(() {
      restMap = restMap;
    });
    restTime.text = '';
    restMusicName.text = '';
  }

  void removeTrainVoice(String key) {
    trainMap.remove(key);
    Firestore.instance.collection('skill').document(widget.skillID)
      .updateData({'train': trainMap})
      .then((value) => print("Train Voice Updated"))
      .catchError((error) => print("Failed to update train voice: $error"));
    setState(() {
      trainMap = trainMap;
    });
    trainTime.text = '';
    trainMusicName.text = '';
  }
}