import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/screens/root_screen.dart';

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
    return Scaffold(
      body: initScreen(context),
    );
  }
  
  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => RootScreen()
      )
    ); 
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
                    color: Colors.black
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