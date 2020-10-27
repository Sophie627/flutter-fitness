import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/screens/workout_admin/workout_form.dart';

class WorkoutsScreen extends StatefulWidget {
  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List workoutData = [];
  List workoutID = [];
  int maxWorkoutID = 0;
  bool isLoading = true;

  fetchWorkoutData() {
    Firestore.instance.collection('workout').orderBy('workoutID').snapshots().listen((data) {
      setState(() {
        workoutData = [];
      });
      data.documents.forEach((doc) {
        workoutData.add(doc);
        workoutID.add(doc.documentID);
        maxWorkoutID = doc['workoutID'];
      });
      setState(() {
        workoutData = workoutData;
        workoutID = workoutID;
        maxWorkoutID = maxWorkoutID;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    fetchWorkoutData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          "Workout Management",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutFormScreen(
                        workoutID: 'createworkout!!!',
                        maxWorkoutID: maxWorkoutID,
                      )),
                  ).then((value) => setState((){}));
                },
                child: Text('+ Add New Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
              ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  strokeWidth: 1,
                ),
              )
              : workoutList(),
            ),
          ]
        ),
      ),
    );
  }

  Widget workoutList() {
    List<Widget> workoutList = [];
    workoutData.asMap().forEach((key, value) {
      workoutList.add(
        ListTile(
          title: Text(value['name']),
          subtitle: Text(value['description']),
          trailing: IconButton(
            icon: Icon(Icons.delete,
              color: Colors.red,
            ), 
            onPressed: () {
              deleteWorkout(workoutID[key]);
            }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutFormScreen(
                  workoutID: workoutID[key],
                )),
            );
          },
        ),
      );
    });
    return ListView(
      children: workoutList,
    );
  }

  void deleteWorkout(workoutID) {
    Firestore.instance.collection('workout').document(workoutID).delete()
    .then((value) => print("Workout Deleted"))
    .catchError((onError) => print("Failed to delete workout: $onError"));
  }
}