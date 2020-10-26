import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/screens/dashboard/dashboardStats.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int userCount = 0;
  int workoutCount = 0;
  int skillCount = 0;
  bool isLoadingUser = true;
  bool isLoadingWorkout = true;
  bool isLoadingSkill = true;

  fetchCount() {
    Firestore.instance.collection('workout').snapshots().listen((value) {
      setState(() {
        workoutCount = value.documents.length;
        isLoadingWorkout = false;
      });
    });
    Firestore.instance.collection('users').snapshots().listen((value) {
      setState(() {
        userCount = value.documents.length;
        isLoadingUser = false;
      });
    });
    Firestore.instance.collection('skill').snapshots().listen((value) {
      setState(() {
        skillCount = value.documents.length;
        isLoadingSkill = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    fetchCount();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _buildAppBar(context),
      body: !isLoadingSkill && !isLoadingUser && !isLoadingWorkout 
      ? _buildBody(context)
      : Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          strokeWidth: 1,
        ),
      ),
    );
  }
  
  _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          DashboardStats(
            userCount: userCount,
            skillCount: skillCount,
            workoutCount: workoutCount,
          ),
          ListTile(
            subtitle: Text('User Management',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            subtitle: Text('Workout Management',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            subtitle: Text('Skill Management',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      elevation: 0.5,
      backgroundColor: Colors.white,
      title: Text(
        "Dashboard",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}