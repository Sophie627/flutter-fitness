/*
  Result Screen file
  Updated on June 8 2020 by Sophie(bolesalavb@gmail.com)
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/models/exercise.dart';
import 'package:onboarding_flow/models/user.dart';
import 'package:onboarding_flow/ui/screens/chart_screen.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:screenshot_share_image/screenshot_share_image.dart';
// import 'package:share/share.dart';
// import 'package:screenshot_share/screenshot_share.dart';

class NascarResultsScreen extends StatefulWidget {
  Settings settings;
  List workout;
  List userWorkout;
  List userWorkoutHistory;
  String name;
  String skillID;
  
  NascarResultsScreen({this.settings, this.workout, this.name, this.userWorkout, this.userWorkoutHistory, this.skillID});
  @override
  _NascarResultsScreenState createState() => _NascarResultsScreenState();
}

class _NascarResultsScreenState extends State<NascarResultsScreen> {
  int totalSteps = 0;
  int totalTouches = 0;
  int totalTime = 0;
  String workoutTime;
  int skillMaxRep = 0;
  // String uid = '';

  // List workoutData = [];

  void updateUserWorkout() async {
    List workoutData = widget.userWorkout;
    List workoutHistory = widget.userWorkoutHistory;

    widget.workout.forEach((element) => { 
      workoutData.add({
        'skillID' : element.skillID,
        'rep': element.rep,
        'time': element.time,
        'solo': element.isSolo,
        "date": DateTime.now(),
      }),
    });
    workoutHistory.add(
      {
        'name': widget.name,
        'date': DateTime.now(),
      }
    );
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Firestore.instance
      .document("users/${user.uid}")
      .updateData({'workout': workoutData});
      workoutData.forEach((element) {
        if (element['skillID'] == widget.skillID && element['rep'] > skillMaxRep) setState(() {
          skillMaxRep = element['rep'];
        });
      });
      Firestore.instance
      .document("users/${user.uid}")
      .updateData({'workoutHistory': workoutHistory});
    }
  }

  /*
    void getTotalStep()
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  June 8 2020 7:51 PM

    Function: getTotalStep

    Description: Getting total step
  */
  void getTotalStep() {
    if (widget.workout != null) {
      for(var i = 0; i < widget.workout.length; i++){
        totalSteps += widget.workout[i].rep;
      }
    }
  }
  
  void getTotalTouches() {
    if (widget.workout != null) {
      for(var i = 0; i < widget.workout.length; i++){
        totalTouches += widget.workout[i].rep * widget.workout[i].touch;
      }
    }
  }
  
  /*
    void getTotalTime()
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: June 8 2020 8:26 PM

    Function: getTotalTime

    Description: Get total time and convert to MM:SS format
  */
  void getTotalTime() {
    if (widget.workout != null) {
      for(var i = 0; i < widget.workout.length; i++){
        totalTime += widget.workout[i].time;
      }
    }
    print('totalTime ${totalTime}');
    workoutTime = (totalTime ~/ 60).toString() + (totalTime % 60 < 10 ? ':0' : ':') + (totalTime % 60).toString();
  }

  @override
  void initState() {
    super.initState();

    getTotalStep();
    getTotalTouches();
    getTotalTime();
    updateUserWorkout();
  }

  @override
  Widget build(BuildContext context) {
    // Firestore.instance
    //   .document("users/${uid}")
    //   .updateData({'workout': workoutData});
    // print('uid ${uid}');
    
    print('workout ${totalTouches}');
    return Scaffold(
      body: Builder(
        builder: (context) => 
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.name.toUpperCase() + ' Results',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      getExerciseListWidgets(widget.workout),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  'Total Reps',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  totalSteps.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  'Total Touches',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  totalTouches.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Center(
                        child: Text(
                          workoutTime,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Workout Time',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Expanded(
                      child: RaisedButton(
                        onPressed: (){
                          if(widget.name == 'solo') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(
                                  skillID: widget.skillID,
                                  skillMaxRep: skillMaxRep.toString(),
                                )),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(
                                )),
                            );
                          }
                        },
                        child: Text(
                          'FINISH',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      color: Colors.black,
                      ),
                    ),
                    Expanded(child: RaisedButton(
                      onPressed: (){
                        ScreenshotShareImage.takeScreenshotShareImage();
                      },
                      child: Text(
                        'SHARE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.greenAccent,
                      ),
                    ),
                  ]
                ),
              ]
            )
          ),
      ),
    );
  }

  /*
    Widget getExerciseListWidgets(List workout)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  June 8 2020 7:17 PM

    Widget: getExerciseListWidget

    Description:  List of exercise name and rep

    Parameters: workout(List) - exercise List(name, rep & time)
  */
  Widget getExerciseListWidgets(List workout)
  {
    List<Widget> list = new List<Widget>();
    if (workout != null) {
      for(var i = 0; i < workout.length; i++){
        list.add(
          ListTile(
            dense: true,
            leading: Text(workout[i].name),
            trailing: Text(workout[i].rep.toString() + ' reps'),
          )
        );
      }
    }
    return new Column(children: list);
  }
}