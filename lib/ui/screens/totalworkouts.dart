import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_flow/ui/screens/activity.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/chart_screen.dart';

class TotalWorkouts extends StatefulWidget {
  Settings settings;
  List skillID;
  List skillRep;
  List skillDate;
  List skillName;
  List skillUrl;

  TotalWorkouts({this.settings, this.skillID, this.skillRep, this.skillDate, this.skillName, this.skillUrl});
  @override
  _TotalWorkoutsState createState() => _TotalWorkoutsState();
}

class _TotalWorkoutsState extends State<TotalWorkouts> {
  
  @override
  Widget build(BuildContext context) {
    List<Widget> skillLists = [];
    List skills = [];
    for(int i = 0; i <widget.skillID.length; i++) {
      skills.add({
        'id': widget.skillID[i],
        'rep': widget.skillRep[i],
        'date': widget.skillDate[i],
        'name': widget.skillName[i],
        'url': widget.skillUrl[i],
      });
    }
    skills.sort((a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));
    for(int i = 0; i <widget.skillID.length; i++) {
      print('skill ${skills[i]["url"]}');
      skillLists.add(
        Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartScreen(
                      skillID: skills[i]['id'],
                      skillMaxRep: skills[i]['rep'].toString(),
                    )),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    new Image.network(
                      skills[i]['url'],
                      height: 100.0,
                    ),
                    // SizedBox(width: 20.0),
                    Expanded(
                      flex: 6,
                      child: Text(
                        skills[i]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Text(skills[i]['rep'].toString() + " Reps",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        )
      );
    }
    return Scaffold(
      backgroundColor: Color(0xFF87B7E1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:30.0,left: 20.0,right: 30.0,bottom: 30.0,),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityScreen(
                        settings: widget.settings,
                      )),
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,top:20,),
                child: Text(
                  widget.skillID.length.toString() + ' TOTAL SKILLS COMPLETED',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              
            ],
            ),
          ),

          Expanded(
                      child: Container(
      
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft:Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListView(
                children:[
                  
                  ListTile(
                    dense:true, 
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                    leading: Text(
                      'SKILLS',
                      style: TextStyle(
                        fontWeight:FontWeight.bold,
                      ),
                      ),
                      
                  ),
                  Divider(),
                  Column(
                    children: skillLists,
                  ),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Love To Squat'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Reach the Finish Line'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Final Lap'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Final Lap'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Step it Up'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Push The Limit'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                  //  ListTile(
                  //   dense:true, 
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical:0,),
                  //   leading: Column(
                  //     crossAxisAlignment:  CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         DateFormat.yMMMd().format(DateTime.now()),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 10,
                  //         ),
                  //         ),
                  //         Text(
                  //           'Like A Champion'
                  //         ),
                  //     ],
                  //   ),
                  //    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){}),
                  // ),
                  // Divider(),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
