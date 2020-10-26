import 'package:flutter/material.dart';

class DashboardStats extends StatefulWidget {
  final int userCount;
  final int skillCount;
  final int workoutCount;

  DashboardStats({
    this.userCount,
    this.skillCount,
    this.workoutCount,
  });

  @override
  _DashboardStatsState createState() => _DashboardStatsState();
}

class _DashboardStatsState extends State<DashboardStats> {
  final TextStyle stats = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
        crossAxisCount: 3,
        children: <Widget>[
          gridUnit("Users", Colors.blue, widget.userCount),
          gridUnit("Workouts", Colors.pink, widget.workoutCount),
          gridUnit("Skills", Colors.green, widget.skillCount),
        ],
      ),
    );
  }

  Container gridUnit(String txt, Color color, int number){
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number.toString(),
            style: stats,
          ),
          const SizedBox(height: 5.0),
          Text(txt.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}