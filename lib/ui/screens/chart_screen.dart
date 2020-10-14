import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/ui/screens/ready_screen.dart';
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
  bool isLoading = true;
  String radioValue = 'W';

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
      // if(element['skillID'] == widget.skillID) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(element['date'].seconds * 1000);
        // DateTime tmp = DateTime(date.year, date.month, date.day);
        // print("tmp ${tmp}");
        // if(skillDateHistory.indexOf(tmp) == -1 ) {
          setState(() {
            skillDateHistory.add(date);
            skillRepHistory.add(element['rep']);
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
      // }
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
  }

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => MainScreen(
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
                fit: BoxFit.fitWidth,
                height: 150,
                width: 150,
              ),
              Expanded(
                  child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'BEST SCORE REPS',
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
                      'BEST SCORE ALERTS',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                        globals.bestAlert = value;
                      },

                      activeTrackColor: Colors.blue,
                      activeColor: Colors.white,
                    ),
                  ),
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
                  textStyle: TextStyle(fontSize: 14)),
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
    switch (radioValue) {
      case 'W':
        bezierChartScale = BezierChartScale.WEEKLY;
        break;
      case 'M':
        bezierChartScale = BezierChartScale.MONTHLY;
        break;
      case 'Y':
        bezierChartScale = BezierChartScale.YEARLY;
        break;
      default:
    }
    int touch = skillData['touch'] == null ? 1 : skillData['touch'];
    for (var i = 0; i < skillRepHistory.length; i++) {
      repData.add(DataPoint<DateTime>(value: skillRepHistory[i].toDouble(), xAxis: skillDateHistory[i]));
      touchData.add(DataPoint<DateTime>(value: skillRepHistory[i].toDouble() * touch, xAxis: skillDateHistory[i]));
    }
    final fromDate = skillDateHistory[0];
    DateTime toDate = DateTime.now();
    toDate = DateTime(toDate.year, toDate.month, toDate.day);
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
              lineColor: Colors.blue,
              label: "Total Reps",
              onMissingValue: (dateTime) {
                return 0;
              },
              data: repData,
            ),
            BezierLine(
              lineColor: Colors.grey,
              label: "Total Touches",
              onMissingValue: (dateTime) {
                return 0;
              },
              data: touchData,
            ),
          ],
          config: BezierChartConfig(
            updatePositionOnTap: true,
            displayDataPointWhenNoValue: false,
            verticalIndicatorStrokeWidth: 3.0,
            pinchZoom: true,
            physics: ClampingScrollPhysics(),
            verticalIndicatorColor: Colors.black,
            showVerticalIndicator: true,
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
