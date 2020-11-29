import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:onboarding_flow/business/validator.dart';
import 'package:onboarding_flow/ui/screens/workout_admin/workout_skill_form.dart';
import 'package:onboarding_flow/ui/widgets/custom_text_field.dart';
import 'package:reorderables/reorderables.dart';

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
  bool isLoadingSkill = true;
  int maxSkillNo = 0;
  List<String> skillsID = [];
  List<String> skillsName = [];
  int _selectedSkill;
  List<DropdownMenuItem<int>> _dropDownMenuItems;
  int workoutID;
  List<Widget> skillListWidget = [];
  List exerciseNoList = [];

  Future<void> deleteSkillDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('Are you sure?'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('Will you really this skill?',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                deleteSkill(id); 
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel',
                style: TextStyle(
                  fontSize: 13.0
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  fetchWorkoutData() {
    if (widget.workoutID == 'createworkout!!!') {
      setState(() {
        isLoading = false;
      });
    } else {
      Firestore.instance.collection('workout').document(widget.workoutID).get()
      .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            workoutID = documentSnapshot.data['workoutID'];
          });
          Firestore.instance.collection('exercise' + documentSnapshot.data['workoutID'].toString()).orderBy('no').snapshots().listen((data) {
            setState(() {
              workoutSkillID = [];
              workoutSkillName = [];
              workoutSkillSkillID = [];
              exerciseNoList = [];
            });
            data.documents.forEach((doc) {
              exerciseNoList.add(doc['no']);
              workoutSkillSkillID.add(doc['skillID']);
              workoutSkillID.add(doc.documentID);
              maxSkillNo = doc['no'];
            });
            setState(() {
              workoutData = workoutData;
              workoutSkillID = workoutSkillID;
              workoutSkillSkillID = workoutSkillSkillID;
              maxSkillNo = maxSkillNo;
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

  fetchSkillData() {
    Firestore.instance.collection('skill').snapshots().listen((data) {
      setState(() {
        skillsID = [];
        skillsName = [];
      });
      data.documents.forEach((doc) {
        skillsName.add(doc['name']);
        skillsID.add(doc.documentID);
      });
      setState(() {
        skillsName = skillsName;
        skillsID = skillsID;
        isLoadingSkill = false;
      });
      _dropDownMenuItems = buildAndGetDropDownMenuItems(skillsName);
      _selectedSkill = _dropDownMenuItems[0].value;
    });
  }

  List<DropdownMenuItem<int>> buildAndGetDropDownMenuItems(List skills) {
    List<DropdownMenuItem<int>> items = new List();
    skills.asMap().forEach((key, value) { 
      items.add(new DropdownMenuItem(value: key, child: new Text(value)));
    });
    return items;
  }

  void changedDropDownItem(int selectedSkill) {
    setState(() {
      _selectedSkill = selectedSkill;
      addSkill(selectedSkill);
    });
  }

  @override
  void initState() {
    super.initState();

    fetchWorkoutData();
    fetchSkillData();
    
  }

  @override
  Widget build(BuildContext context) {

    return isLoading || isLoadingSkill
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
            : skillList()
          ),
          widget.workoutID == 'createworkout!!!' 
          ? SizedBox(height: 0)
          : SizedBox(height: 30.0,),
          widget.workoutID == 'createworkout!!!' 
          ? SizedBox(height: 0)
          : Container(
            child: new Center(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Please choose a skill: "),
                new DropdownButton(
                  value: _selectedSkill,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                )
              ],
            )),
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
    
    workoutSkillName.asMap().forEach((key, value) {
      skillListWidget.add(
        Slidable(
          key: ValueKey(key),
          child: ListTile(
            title: Text(value,
              style: TextStyle(
                fontSize: 20.0,
              ),
            )
          ), 
          actionPane: SlidableDrawerActionPane(),
          actions: <Widget>[
            IconSlideAction(
              caption: 'More',
              color: Colors.grey.shade200,
              icon: Icons.more_horiz,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutSkillFromScreen(
                    workoutSkillID: workoutSkillID[key],
                    workoutID: workoutID,
                  )),
              ),
              closeOnTap: false,
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => deleteSkillDialog(workoutSkillID[key]),
            ),
          ],
        ),
      );
    });
    setState(() {});
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 20.0),
      child: ReorderableListView(
        children: skillListWidget,
        onReorder: (int oldIndex, int newIndex) {
          print('oldIndex: $oldIndex, newIndex: $newIndex');
          Widget row = skillListWidget.removeAt(oldIndex);
          skillListWidget.insert(newIndex, row);
          setState(() {});
          updateIndex(oldIndex, newIndex);
        },
      ),
      // Column(
      //   children: skillList,
      // ),
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

  void addSkill(int selectedSkill) {
    Firestore.instance.collection('exercise' + workoutID.toString()).add({'skillID': skillsID[selectedSkill], 'no': maxSkillNo + 1})
      .then((value) {
         print("Workout Added");
      })
      .catchError((error) => print("Failed to add workout: $error"));
  }

  void deleteSkill(skillID) {
    Firestore.instance.collection('exercise' + workoutID.toString()).document(skillID).delete()
    .then((value) => print("Skill Deleted"))
    .catchError((onError) => print("Failed to delete skill: $onError"));
  }

  void updateIndex(int oldIndex, int newIndex) {
    List newNoList = [];
    List tmpList = [];
    int index = 0;
    exerciseNoList.asMap().forEach((key, value) { 
      newNoList.add(index);
      tmpList.add(index);
      index ++;
    });
    int tmp = tmpList.removeAt(newIndex);
    tmpList.insert(oldIndex, tmp);
    print('tmpList $tmpList');
    workoutSkillID.asMap().forEach((key, value) { 
      Firestore.instance.collection('exercise' + workoutID.toString()).document(value).updateData({
        'no': tmpList[key]
      })
      .then((value) => print("Skill Updated"))
      .catchError((onError) => print("Failed to update skill: $onError"));
    });
    setState(() {
      exerciseNoList = newNoList;
      String tmpSkillID = workoutSkillID.removeAt(oldIndex);
      workoutSkillID.insert(newIndex, tmpSkillID);
    });
  }
}