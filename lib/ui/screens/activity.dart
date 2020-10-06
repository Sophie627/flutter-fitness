import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:onboarding_flow/ui/screens/totalworkouts.dart';

class ActivityScreen extends StatefulWidget {
  Settings settings;

  ActivityScreen({this.settings});
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  CalendarController _calendarController= CalendarController();

  List workoutData = [];
  List workoutHistory = [];
  List workoutName = [];
  Map<DateTime, List<dynamic>> workoutDate = {};
  List skillID = [];
  List skillName = [];
  List skillRep = [];
  List skillDate = [];
  bool isLoading = true;
  bool isLogin = true;

  void fetchCurrentUserWorkoutData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      setState(() {
        isLogin = false;
        isLoading = false;
      });
    } else {
      Firestore.instance.collection('users').document(user.uid).snapshots().listen((data)  { 
        setState(() {
          if( data['workout']  == null ) {
            workoutData = [];
          } else {
            workoutData = data['workout'];
          }
        });
        setState(() {
          if( data['workoutHistory']  == null ) {
            workoutHistory = [];
          } else {
            workoutHistory = data['workoutHistory'];
          }
        });
        handleWorkoutData(workoutData);
        handleWorkoutHistory(workoutHistory);
        setState(() {
          isLoading = false;
        });
      });
    }
  }
  
  void handleWorkoutHistory(List data) {
    data.forEach((element) {
      if(workoutName.indexOf(element['name']) == -1) {
        setState(() {
          workoutName.add(element['name']);
        });
      }
      DateTime date = DateTime.fromMillisecondsSinceEpoch(element['date'].seconds * 1000);
      DateTime tmp = DateTime(date.year, date.month, date.day);
      if(workoutDate.keys.toList().indexOf(tmp) == -1 ) {
        setState(() {
          workoutDate.addAll({tmp : ['']});
        });
      }
    });
  }

  void handleWorkoutData(List data) {
    data.forEach((element) {
      if(skillID.indexOf(element['skillID']) == -1) {
        Firestore.instance.collection('skill').document(element['skillID']).snapshots().listen((data) {
          setState(() {
            skillName.add(data['name']);
          });
        });
        setState(() {
          skillID.add(element['skillID']);
          skillRep.add(element['rep']);
          skillDate.add(element['date']);
        });
      } else {
        int index = skillID.indexOf(element['skillID']);
        if(skillRep[index] < element['rep']) {
          setState(() {
            skillRep[index] = element['rep'];
            skillDate[index] = element['date'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    fetchCurrentUserWorkoutData();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(workoutDate);
    return isLoading
    ? Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Text(
                "Loading...",
                // style: TextStyle(
                //   fontSize: 20.0,
                //   color: Colors.black
                // ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              CircularProgressIndicator(
                backgroundColor: Colors.black,
                strokeWidth: 1,
            )
          ],
        ),
      ),
    )
    : Container(
      color: Colors.grey.shade400,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey.shade400,
            centerTitle: true,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(
                    settings: widget.settings,
                  )),
              )),
            title: Text(
              'Activity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: isLogin 
          ? Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TotalWorkouts(
                                settings: widget.settings,
                                skillID: skillID,
                                skillRep: skillRep,
                                skillDate: skillDate,
                                skillName: skillName,
                              )),
                          );
                        },
                        child: ReUseableCard(
                          cardChild: Column(children: [
                            SizedBox(height: 25),
                            Text(
                              skillID.length.toString(),
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'TOTAL SKILLS COMPLETED',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF87B7E1),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'VIEW ALL',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                                height: 15,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReUseableCard(
                        cardChild: Column(children: [
                            SizedBox(height: 25),
                          Text(
                            workoutName.length.toString(),
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'TOTAL WORKOUTS COMPLETED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFF87B7E1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'VIEW ALL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width: double.infinity,
                              height: 15,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ReUseableCard(
                  cardChild: TableCalendar(
                    events: workoutDate,
                    calendarController: _calendarController,
                    headerVisible: true,
                    locale: 'en_US',
                    initialCalendarFormat: CalendarFormat.month,
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonVisible: false,
                    ),
                  ),
                ),
              ),
            ],
          )
          : Center(child: Text('No data. Please sign in...'),),
        ),
      ),
    );
  }
}

class ReUseTile extends StatelessWidget {
  final String headerText;
  final String footerText;
  final Color iconColor;

  const ReUseTile({Key key, this.headerText, this.footerText, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      header: GridTileBar(
        title: Text(
          headerText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
      ),
      child: Icon(
        Icons.stop,
        color: iconColor,
        size: 25,
      ),
      footer: GridTileBar(
        title: Text(
          footerText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class ReUseableCard extends StatelessWidget {
  final Widget cardChild;

  const ReUseableCard({Key key, this.cardChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: cardChild,
    );
  }
}
