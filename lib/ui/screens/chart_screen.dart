import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  bool isSwitched = true;
  DocumentSnapshot skillData;
  List skillDateHistory =[];
  List skillRepHistory =[];
  List workoutData = [];
  bool isLoading = true;

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
        DateTime tmp = DateTime(date.year, date.month, date.day);
        print("tmp ${tmp}");
        if(skillDateHistory.indexOf(tmp) == -1 ) {
          setState(() {
            skillDateHistory.add(tmp);
            skillRepHistory.add(element['rep']);
          });
        } else {
          int index = skillDateHistory.indexOf(tmp);
          if(skillRepHistory[index] < element['rep']) skillRepHistory[index] = element['rep'];
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              onPressed: () {},
              minWidth: MediaQuery.of(context).size.width * 0.85,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.blue,
              child: Text(
                'LIVE VIEW',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          sample3(context),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Container(
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
                        text: 'Workout',
                        textStyle: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                      axes: <RadialAxis>[
                        RadialAxis(
                          showLabels: false,
                          showAxisLine: false,
                          minimum: 0, 
                          maximum: 150, 
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 100,
                                color: Color(0xFF1DCC50),
                                startWidth: 7,
                                endWidth: 7),
                            GaugeRange(
                                startValue: 100,
                                endValue: 150,
                                color: Colors.grey,
                                startWidth: 7,
                                endWidth: 7)
                          ], 
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              verticalAlignment: GaugeAlignment.far,
                              widget: Container(
                                child: const Text('90.0',
                                  style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold))),
                              angle: 90,
                              positionFactor: 0.4),
                            GaugeAnnotation(
                              verticalAlignment: GaugeAlignment.far,
                              widget: Container(
                                child: const Text('2020-10-06',
                                  style: TextStyle(
                                    fontSize: 12,))),
                              angle: 90,
                              positionFactor: 1.3)
                          ]
                        )
                      ]
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget sample3(BuildContext context) {
    List<DataPoint<dynamic>> data = [];
    for (var i = 0; i < skillRepHistory.length; i++) {
      data.add(DataPoint<DateTime>(value: skillRepHistory[i].toDouble(), xAxis: skillDateHistory[i]));
    }
    final fromDate = DateTime(2019, 05, 22);
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
          bezierChartScale: BezierChartScale.WEEKLY,
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
          footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
            final newFormat = DateFormat('dd/MM');
            return newFormat.format(value);
          },
          series: [
            BezierLine(
              lineColor: Colors.black,
              label: "Rep",
              onMissingValue: (dateTime) {
                return 0;
              },
              data: data,
            ),
          ],
          config: BezierChartConfig(
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
          ),
        ),
      ),
    );
  }
}
