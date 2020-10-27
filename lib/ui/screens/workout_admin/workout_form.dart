import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/business/validator.dart';
import 'package:onboarding_flow/ui/widgets/custom_alert_dialog.dart';
import 'package:onboarding_flow/ui/widgets/custom_text_field.dart';

class WorkoutFormScreen extends StatefulWidget {

  final String workoutID;
  final int maxWorkoutID;

  WorkoutFormScreen({
    this.workoutID,
    this.maxWorkoutID = 0,
  });

  @override
  _WorkoutFormScreenState createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final TextEditingController workoutName = new TextEditingController();
  final TextEditingController imageUrl = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  VoidCallback onBackPress;
  dynamic workoutData;
  List workoutSkillName = [];
  List workoutSkillID = [];
  List workoutSkillSkillID = [];
  bool isLoading = true;

  fetchWorkoutDate() {
    if (widget.workoutID == 'createworkout!!!') {
      setState(() {
        isLoading = false;
      });
    } else {
      Firestore.instance.collection('workout').document(widget.workoutID).get()
      .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Firestore.instance.collection('exercise' + documentSnapshot.data['workoutID'].toString()).orderBy('no').snapshots().listen((data) {
            setState(() {
              workoutSkillID = [];
              workoutSkillName = [];
              workoutSkillSkillID = [];
            });
            data.documents.forEach((doc) {
              workoutSkillSkillID.add(doc['skillID']);
              workoutSkillID.add(doc.documentID);
            });
            setState(() {
              workoutData = workoutData;
              workoutSkillID = workoutSkillID;
              workoutSkillSkillID = workoutSkillSkillID;
            });
            workoutSkillSkillID.asMap().forEach((key, element) {
              Firestore.instance.collection('skill').document(element).get()
              .then((value) {
                workoutSkillName.add(value['name']);
                setState(() {
                  workoutSkillName = workoutSkillName;
                });
                if (key == workoutSkillSkillID.length) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            });
          });
          print('Document data: ${documentSnapshot.data}');
          workoutName.text = documentSnapshot.data['name'];
          imageUrl.text = documentSnapshot.data['image'];
          description.text = documentSnapshot.data['description'];
          setState(() {
            workoutData = documentSnapshot.data;
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

    fetchWorkoutDate();
  }

  @override
  Widget build(BuildContext context) {

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
          widget.workoutID == 'createworkout!!!' ? 'Create a New Workout' : workoutData['name'],
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
              controller: workoutName,
              hint: "Workout Name",
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
            padding:
                EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: CustomTextField(
              baseColor: Colors.grey,
              borderColor: Colors.grey[400],
              errorColor: Colors.red,
              controller: description,
              hint: "Description",
              validator: Validator.validateName,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Divider(
              color: Colors.grey[200],
              thickness: 2.0,
            ),
          ),
          widget.workoutID == 'createworkout!!!'
          ? SizedBox(height: 0)
          : Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Text('Skill List',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: widget.workoutID == 'createworkout!!!' 
            ? SizedBox(height: 0)
            : ListView(
              children: <Widget>[
                skillList(),
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
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  actionSaveWorkout();
                },
                child: Text('Save Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget skillList() {
    List<Widget> skillList = [];
    workoutSkillName.asMap().forEach((key, value) {
      skillList.add(ListTile(
        title: Text(value),
        trailing: IconButton(
          icon: Icon(Icons.delete,
            color: Colors.red,
          ), 
          onPressed: null
        ),
      ));
    });
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 20.0),
      child: Column(
        children: skillList,
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
                // if (field == 'rest') removeRestVoice(key);
                // else removeTrainVoice(key); 
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

  void actionSaveWorkout() {
    if (widget.workoutID == 'createworkout!!!') {
      Firestore.instance.collection('workout').add({'name': workoutName.text, 'image': imageUrl.text, 'description': description.text, 'workoutID': widget.maxWorkoutID + 1})
      .then((value) => print("Workout Added"))
      .catchError((error) => print("Failed to add workout: $error"));
    } else {
      Firestore.instance.collection('workout').document(widget.workoutID)
        .updateData({'name': workoutName.text, 'url': imageUrl.text, 'description': description.text})
        .then((value) => print("Skill Updated"))
        .catchError((error) => print("Failed to update skill: $error"));
    }
    Navigator.of(context).pop();
  }
}