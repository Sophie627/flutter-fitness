import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
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
@override
void initState() {
  super.initState();
  _calendarController = CalendarController();
}

@override
void dispose() {
  _calendarController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        body: Column(
            
            children: <Widget>[
          Expanded(
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
                  )),
              );
            },
            child: ReUseableCard(
              cardChild: Column(children: [
                SizedBox(height: 25),
                Text(
                  '7',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'TOTAL WORKOUTS COMPLETED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
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
                '0',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                ),
              ),
              Text(
                'TOTAL CHALLENGES COMPLETED',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
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
              ])),
              Expanded(
          child: ReUseableCard(
        cardChild: Column(
          children: <Widget>[
            SizedBox(height: 10, width: double.infinity),
            Text(
              '0',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                child: ReUseTile(
                  headerText: '0',
                  footerText: 'S',
                  iconColor: Colors.grey,
                ),
              ),
              Expanded(
              child: ReUseTile(
                headerText: '0',
                footerText: 'M',
                iconColor: Colors.greenAccent,
              ),

            ),
            Expanded(
              child: ReUseTile(
                headerText: '0',
                footerText: 'T',
                iconColor: Colors.grey,
              ),
            ),
            Expanded(
              child: ReUseTile(
                headerText: '0',
                footerText: 'W',
                iconColor: Colors.grey,
              ),
            ),
            Expanded(
              child: ReUseTile(
                headerText: '0',
                footerText: 'T',
                iconColor: Colors.grey,
              ),
            ),
            Expanded(
              child: ReUseTile(
                headerText: '0',
                footerText: 'F',
                iconColor: Colors.grey,
              ),
            ),
            Expanded(
              child: ReUseTile(
                headerText: '0',
                footerText: 'S',
                iconColor: Colors.grey,
              ),
            ),
                ],
              ),
            ),
            Text(
              'CALORIES BURNED',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
              )),
              Expanded(
                            child: ReUseableCard(
        cardChild: TableCalendar(
      calendarController: _calendarController,
headerVisible: true,
locale: 'en_US',
initialCalendarFormat: CalendarFormat.week,
headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),

  ),
                ),
              ),
              
            ],
            
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
