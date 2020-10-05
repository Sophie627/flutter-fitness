import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Inside Outside',
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
              Image.asset(
                'assets/images/1.gif',
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
                      '50',
                      
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
        ],
      ),
    );
  }

  Widget sample3(BuildContext context) {
    final fromDate = DateTime(2019, 05, 22);
    final toDate = DateTime.now();
    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));
    return Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 2,
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
              label: "Duty",
              onMissingValue: (dateTime) {
                if (dateTime.day.isEven) {
                  return 10.0;
                }
                return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: 10, xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
              ],
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
