import 'package:flutter/material.dart';
import 'package:onboarding_flow/business/auth.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/root_screen.dart';
import 'package:onboarding_flow/ui/screens/settings_screen.dart';
import 'package:onboarding_flow/ui/screens/activity.dart';
import 'package:onboarding_flow/ui/screens/insideoutside.dart';
import 'package:onboarding_flow/ui/screens/nascarresults.dart';
import 'package:onboarding_flow/ui/screens/profile.dart';
import 'package:onboarding_flow/ui/screens/totalworkouts.dart';
import 'package:onboarding_flow/ui/screens/soccerbasics_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final Settings settings;

  MainScreen({this.firebaseUser, this.settings});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            elevation: 0.5,
            leading: new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer()),
            title: new Text(
              'Brave Fit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,  
                fontFamily: 'Xbka',
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('SHOP'),
                    ],
                  ),
                )
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 130.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF85C1E9),
                    ),
                    child: Text(
                        'Brave Fit Fitness',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,  
                          fontFamily: 'Xbka',
                        ),
                      ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          settings: widget.settings,
                        )),
                    ); 
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.brush),
                  title: Text('Activity'),
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityScreen(
                          settings: widget.settings,
                        )),
                    ); 
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Learn'),
                  onTap: () {
                    // Navigator.pushNamed(context, '/totalworkouts');
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          settings: widget.settings,
                        )),
                    ); 
                    // Navigator.pushNamed(context, '/settings');
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.directions_railway),
                  title: Text('Follow us'),
                  onTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                _signList(),
              ],
            ),
          ),
          body: new TabBarView(children: [
            new SingleChildScrollView(
              child: new Stack(
                children: <Widget>[
                  new Center(
                    child: new Container(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          InkWell(
                            child: Stack(
                              children: <Widget> [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 30.0,
                                      child: new Image.asset('assets/images/narscar.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SoccerBasics(
                                    settings: widget.settings,
                                  )),
                              ); 
                            },
                          ),
                          InkWell(
                            child: Stack(
                              children: <Widget> [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 30.0,
                                      child: new Image.asset('assets/images/soccerbasics.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            onTap: () {
                              // Navigator.pushNamed(context, "/soccerbasics");
                            },
                          ),
                          InkWell(
                            child: Stack(
                              children: <Widget> [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 30.0,
                                      child: new Image.asset('assets/images/thecore.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            onTap: () {
                              // Navigator.pushNamed(context, "/exercise");
                            },
                          ),
                          InkWell(
                            child: Stack(
                              children: <Widget> [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 30.0,
                                      child: new Image.asset('assets/images/getlimber.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            onTap: () {
                              // Navigator.pushNamed(context, "/exercise");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
            new Container(
              color: Colors.lightGreen,
            ),
          ]), 
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Text("WORKOUTS"),
              ),
              Tab(
                icon: new Text("CHALLENGES"),
              ),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
      );
    
  }

  Widget _signList() {
    if (widget.firebaseUser == null) {
      return ListTile(
        leading: Icon(Icons.home),
        title: Text('To First Screen'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RootScreen(
                // settings: widget.settings,
              )),
          ); 
          _scaffoldKey.currentState.openEndDrawer();
        },
      );
    } else {
      return ListTile(
        leading: Icon(Icons.power_settings_new),
        title: Text('Sign Out'),
        onTap: () {
          _logOut();
          _scaffoldKey.currentState.openEndDrawer();
        },
      );
    }
  }

  

  void _logOut() async {
    Auth.signOut();
  }
}
