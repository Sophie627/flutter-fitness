import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:onboarding_flow/ui/screens/ready_screen.dart';
import 'package:onboarding_flow/ui/screens/totalworkouts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../globals.dart' as globals;

class ChartScreen extends StatefulWidget {

  final String skillID;
  final String skillMaxRep;

  ChartScreen({this.skillID,
    this.skillMaxRep,
  });

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  bool isSwitched = globals.bestAlert;
  DocumentSnapshot skillData;
  List skillDateHistory = [];
  List skillRepHistory = [];
  List skillTypeHistory = [];
  List workoutData = [];
  List skillID = [];
  List skillName = [];
  List skillRep = [];
  List skillDate = [];
  List skillUrl = [];
  bool isLoading = true;
  String radioValue = 'W';
  DateTime fromDate;
  BezierChartScale bezierChartScale = BezierChartScale.WEEKLY;
  bool isLogin = true;
  List workoutHistory = [];
  List workoutName = [];
  int totalRep = 0;
  Map<DateTime, List<dynamic>> workoutDate = {};

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
        // setState(() {
        //   isLoading = false;
        // });
      });
    }
  }
  
  void handleWorkoutHistory(List data) {
    data.forEach((element) {
      if(workoutName.indexOf(element['name']) == -1 && element['name'] != 'solo') {
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
      if(element['rep'] > 0) {
        if(skillID.indexOf(element['skillID']) == -1) {
          Firestore.instance.collection('skill').document(element['skillID']).snapshots().listen((data) {
            print('skillname ${data}');
            setState(() {
              skillName.add(data['name']);
              skillUrl.add(data['url']);
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
      }
    });
  }

  void getSkillhisstory() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    
    Firestore.instance.collection('users').document(user.uid).snapshots().listen((data)  { 
      setState(() {
        if( data['workout']  == null ) {
          workoutData = [];
        } else {
          workoutData = data['workout'];
        }
      });
      handleSkillHistory(workoutData);
      setState(() {
        isLoading = false;
      });
    });
  }

  handleSkillHistory(List data) {
    data.forEach((element) {
      if(element['skillID'] == widget.skillID) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(element['date'].seconds * 1000);
        // DateTime tmp = DateTime(date.year, date.month, date.day);
        // print("tmp ${tmp}");
        // if(skillDateHistory.indexOf(tmp) == -1 ) {
          setState(() {
            skillDateHistory.add(date);
            skillRepHistory.add(element['rep']);
            totalRep += element['rep'];
            if (element['solo'] == null || !element['solo']) {
              skillTypeHistory.add('Workout');
            } else {
              skillTypeHistory.add('Solo');
            }
          });
        // } else {
        //   int index = skillDateHistory.indexOf(tmp);
        //   if(skillRepHistory[index] < element['rep']) {
        //     skillRepHistory[index] = element['rep'];
        //     if (element['solo'] == null || !element['solo']) {
        //       skillTypeHistory[index] = 'Workout';
        //     } else {
        //       skillTypeHistory[index] = 'Solo';
        //     }
        //   }
        // }
      }
    });
  }

  fetchSkillData() async {
    Firestore.instance.collection('skill').document(widget.skillID).snapshots().listen((data) {
      setState(() {
        skillData = data;
      });
    });
  }

  @override
  void initState() {

    super.initState();
    fetchSkillData();
    getSkillhisstory();
    fetchCurrentUserWorkoutData();
  }

  @override
  Widget build(BuildContext context) {
    int touch = skillData['touch'] == null ? 1 : skillData['touch'];
    List<Widget> gaugeList = [];
    for (var i = 0; i < skillRepHistory.length; i++) {
      gaugeList.add(customGauge(skillRepHistory[i], skillDateHistory[i], int.parse(widget.skillMaxRep), skillTypeHistory[i]));
    }
    print(skillTypeHistory);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).popUntil(ModalRoute.withName('/totalworkouts'));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TotalWorkouts(
                  // settings: widget.settings,
                  skillID: skillID,
                  skillRep: skillRep,
                  skillDate: skillDate,
                  skillName: skillName,
                  skillUrl: skillUrl,
                )),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          skillData['name'],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                skillData['url'],
                fit: BoxFit.contain,
                height: 150,
                width: 150,
              ),
              Expanded(
                  child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'BEST REP SCORE',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      widget.skillMaxRep,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'TOTAL TOUCHES',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      (touch * totalRep).toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'BEST SCORE ALERTS',
                  //     style: TextStyle(
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  //   trailing: Switch(
                  //     value: isSwitched,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         isSwitched = value;
                  //       });
                  //       globals.bestAlert = value;
                  //     },

                  //     activeTrackColor: Colors.blue,
                  //     activeColor: Colors.white,
                  //   ),
                  // ),
                ],
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ready(
                      // settings: widget.settings,
                      id: -1,
                      name: "solo",
                      image: widget.skillID,
                      skillData: [skillData],
                      skillMaxRep: [int.parse(widget.skillMaxRep)],
                    )),
                ); 
              },
              minWidth: MediaQuery.of(context).size.width * 0.85,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.blue,
              child: Text(
                'GO LIVE NOW',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: CustomRadioButton(
              enableButtonWrap: true,
              elevation: 0,
              defaultSelected: 'W',
              enableShape: true,
              unSelectedColor: Colors.white,
              unSelectedBorderColor: Colors.blue,
              buttonLables: [
                "Weekly",
                "Monthly",
                "Yearly",
              ],
              buttonValues: [
                "W",
                "M",
                "Y",
              ],
              buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 12)),
              radioButtonValue: (value) {
                setState(() {
                  radioValue = value;
                });
              },
              selectedColor: Colors.blue,
            ),
          ),
          chart(context),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: gaugeList.reversed.toList(),
            )
          ),
        ],
      ),
    );
  }

  Widget customGauge(int rep, DateTime date, int maxRep, String type) {
    int max = (maxRep / 10).ceil() * 10;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        )
      ),
      child: GridTile(
        child: SfRadialGauge(
          title: GaugeTitle(
            text: type,
            textStyle: const TextStyle(
                fontSize: 12.0, fontWeight: FontWeight.bold)),
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showAxisLine: false,
              minimum: 0, 
              maximum: max.toDouble(), 
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: rep.toDouble(),
                    color: Color(0xFF1DCC50),
                    startWidth: 7,
                    endWidth: 7),
                GaugeRange(
                    startValue: rep.toDouble(),
                    endValue: max.toDouble(),
                    color: Colors.grey,
                    startWidth: 7,
                    endWidth: 7)
              ], 
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  verticalAlignment: GaugeAlignment.far,
                  widget: Container(
                    child: Text(rep.toString(),
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))),
                  angle: 90,
                  positionFactor: 0.4),
                GaugeAnnotation(
                  verticalAlignment: GaugeAlignment.far,
                  widget: Container(
                    child: Text(DateFormat('MM-dd-yyyy').format(date),
                      style: TextStyle(
                        fontSize: 12,))),
                  angle: 90,
                  positionFactor: 1.3)
              ]
            )
          ]
        ),
      ),
    );
  }

  Widget chart(BuildContext context) {
    List<DataPoint<dynamic>> repData = [];
    List<DataPoint<dynamic>> touchData = [];
    BezierChartScale bezierChartScale;
    
    DateTime toDate = DateTime.now();
    switch (radioValue) {
      case 'W':
        setState(() {
          bezierChartScale = BezierChartScale.WEEKLY;
          fromDate = toDate.subtract(Duration(days: 7));
        });
        break;
      case 'M':
        setState(() {
          bezierChartScale = BezierChartScale.MONTHLY;
          fromDate = toDate.subtract(Duration(days: 365));
        });
        break;
      case 'Y':
        setState(() {
          bezierChartScale = BezierChartScale.YEARLY;
          fromDate = toDate.subtract(Duration(days: 3650));
        });
        break;
      default:
    }
    int touch = skillData['touch'] == null ? 1 : skillData['touch'];
    for (var i = 0; i < skillRepHistory.length; i++) {
      repData.add(DataPoint<DateTime>(value: skillRepHistory[i].toDouble(), xAxis: skillDateHistory[i]));
      touchData.add(DataPoint<DateTime>(value: skillRepHistory[i].toDouble() * touch, xAxis: skillDateHistory[i]));
    }
    // final fromDate = skillDateHistory[0];
    
    // toDate = DateTime(toDate.year, toDate.month, toDate.day);
    // final date1 = DateTime.now().subtract(Duration(days: 2));
    // final date2 = DateTime.now().subtract(Duration(days: 3));
    return Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: bezierChartScale,
          toDate: toDate,
          onIndicatorVisible: (val) {
            print("Indicator Visible :$val");
          },
          onDateTimeSelected: (datetime) {
            print("selected datetime: $datetime");
          },
          onScaleChanged: (scale) {
            print("Scale: $scale");
          },
          selectedDate: toDate,
          //this is optional
          // footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
          //   final newFormat = DateFormat('yy/MM');
          //   return newFormat.format(value);
          // },
          series: [
            BezierLine(
              lineStrokeWidth: 8.0,
              lineColor: Colors.blue,
              label: "Total Reps",
              onMissingValue: (dateTime) {
                return 0;
              },
              data: repData,
            ),
            BezierLine(
              lineStrokeWidth: 8.0,
              lineColor: Colors.grey,
              label: "Total Touches",
              onMissingValue: (dateTime) {
                return 0;
              },
              data: touchData,
            ),
          ],
          config: BezierChartConfig(
            showDataPoints: false,
            updatePositionOnTap: true,
            displayDataPointWhenNoValue: false,
            verticalIndicatorStrokeWidth: 0.0,
            pinchZoom: true,
            physics: ClampingScrollPhysics(),
            verticalIndicatorColor: Colors.black,
            showVerticalIndicator: false,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Colors.white,
            xAxisTextStyle: TextStyle(
              color: Colors.black
            ),
            footerHeight: 50.0
          ),
        ),
      ),
    );
  }
}
