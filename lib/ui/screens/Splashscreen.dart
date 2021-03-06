import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/screens/intro.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/ui/screens/root_screen.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  
  @override
  Widget build(BuildContext context) {

    //preloading images...
    // Firestore.instance.collection('workout').orderBy('workoutID').snapshots().listen((data) => {
    //   data.documents.forEach((doc) {
    //     precacheImage(NetworkImage(doc['image']), context);
    //   }),
    // });
    // Firestore.instance.collection('skill').snapshots().listen((data) => {
    //   data.documents.forEach((doc) {
    //     precacheImage(NetworkImage(doc['url']), context);
    //   }),
    // });
   
    return Scaffold(
      body: initScreen(context),
    );
  }
  
  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() async {
    if (await FirebaseAuth.instance.currentUser() == null) {
      // Navigator.pushNamed(context, "/welcome");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Intro()),
      );
    } else {
      Navigator.pushNamed(context, "/main");
    }
    // Navigator.pushReplacement(context, MaterialPageRoute(
    //     builder: (context) => RootScreen()
    //   )
    // ); 
  }
  
  initScreen(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/splash.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  strokeWidth: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}