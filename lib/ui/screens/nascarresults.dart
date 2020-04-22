import 'package:flutter/material.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';

class NascarResultsScreen extends StatefulWidget {
  Settings settings;
  
  NascarResultsScreen({this.settings});
  @override
  _NascarResultsScreenState createState() => _NascarResultsScreenState();
}

class _NascarResultsScreenState extends State<NascarResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[

            Expanded(
              child: ListView(
                children: <Widget>[
                  Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'NASCAR Results',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      ),
                  ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Burpees'),
                    trailing: Text('35 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('High Knees'),
                    trailing: Text('12 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Skaters'),
                    trailing: Text('22 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Squats'),
                    trailing: Text('24 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('High Knees'),
                    trailing: Text('12 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Skaters'),
                    trailing: Text('22 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Squats'),
                    trailing: Text('24 reps'),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Burpees'),
                    trailing: Text('35 reps'),
                  ),
                  Center(
                    child: Text(
                      'Total Steps',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      ),
                  ),
                    Center(
                    child: Text(
                      '435',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                   Center(
                    child: Text(
                    '27:50',
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
                Expanded(child: RaisedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(
                          settings: widget.settings,
                        )),
                    );
                  },
                  child: Text(
                    'FINISH',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  color: Colors.black,
                  ),),
                 Expanded(child: RaisedButton(
                  onPressed: (){},
                  child: Text(
                    'SHARE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  color: Colors.greenAccent,
                  ),),
              ]
            ),
          ]
        )
        ),
    );
  }
}