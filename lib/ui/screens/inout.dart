/*
  Exercise Screen file
  Created on March 30 2020 by Sophie(bolesalavb@gmail.com)
*/

import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onboarding_flow/ui/screens/nascarresults.dart';
import 'package:onboarding_flow/ui/screens/soccerbasics_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class InOut extends StatefulWidget {
  Settings settings;
  InOut({this.settings});

  @override
  _InOutState createState() => _InOutState();
}

class _InOutState extends State<InOut> {
  Timer _timer;
  PanelController _pc = new PanelController();
  var txt = TextEditingController();
  FocusNode myFocusNode;
  AudioPlayer advancedPlayer;
  CarouselSlider exerciseCarousel;
  final controller = PageController(viewportFraction: 0.8);
  
  bool _firstBuilding = true; //state related to first building
  int _current = 0; //state related to current exercise index
  List _exerciseData = [];  //All exercise data
  int _time = -1;  //state related to timer
  String _exerciseComment = '';  //state related to exercise comment
  bool _playState = true; //state related to playing
  String _stageState = "rest"; //state related to stage
  bool _nightMode = false;//day mode or night mode

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  /* 
    void playMusic(String title, String method)
    Author: Sophie
    Created Date & Time:  Mar 31 2020 10:23PM

    Function: playMusic

    Description:  Sound or Voice is played.

    Parameters: title(String) - title of Sound or Voice
                method(String)  - type of Music(Sound or Voice)
  */
  void playMusic(String title, String method) {
    Future loadMusic() async {
      advancedPlayer = await AudioCache().play("music/" + title + ".mp3");
    }

    if (method == "sound") {
      if(widget.settings == null) {
        // loadMusic();
      } else if (widget.settings.sound) {
        loadMusic();
      }
    }

    if (method == "voice") {
      if(widget.settings == null) {
        loadMusic();
      } else if (widget.settings.voice) {
        loadMusic();
      }
    }
  }

  /*
    void playListVoice(List list)
    Author: Sophie
    Created Date & Time:  Mar 31 2020 10:31PM

    Function: playListVoice

    Description:  Voices of list are played at the same time.

    Parameters: list(List)  - Voice title list  
  */
  void playListVoice(List list) {
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        playMusic(list[i], "voice");
      }
    }
  }
  /* 
    fetchData() async
    Author: Sophie
    Created Date & Time: March 31 2020 12:11AM

    Function: fetchData

    Description:  Using this function, Data related to 'Exercise 1' can be gotten from firebase. 
  */
  fetchData() async {
    Firestore.instance.collection('exercise1').orderBy('no').snapshots().listen((data) => {
      data.documents.forEach((doc) => _exerciseData.add(doc)),
      setState(() {
        _exerciseData = _exerciseData;
      }),
    });
  }

  /*
    exerciseRest(index, normal)
    Author: Sophie
    Created Date & Time:  March 31 2020 5:12AM

    Function: exerciseRest

    Description:  Rest stage of every exercise step is carried out by this function

    Parameters: index(int)  - index of current exercise step
                normal(bool)  - Normal rest or rest due to press button
  */
  exerciseRest(index, normal) {
    if (index == 0) {
      setState(() {
        _time = 10;
        _exerciseComment = "";
        _stageState = 'rest';
      });
    } else {
      // if (normal) {
        setState(() {
          _time = int.parse(_exerciseData[index - 1]['restTime']);
          _exerciseComment = "Rest";
          _stageState = 'rest';
        });
      // } else {
      //   setState(() {
      //     _time = int.parse(_exerciseData[index - 1]['restTime']);
      //     // _time = 10;
      //     _exerciseComment = "Rest";
      //     _stageState = 'rest';
      //   });
      // }
    }
    if (!_firstBuilding) {
      exerciseCarousel.animateToPage(_current,
        duration: Duration(milliseconds: 1500),
        curve: Curves.linear);
      controller.animateToPage(_current,
        duration: Duration(milliseconds: 1500),
        curve: Curves.linear);
    }
    startTimer();
  }

  /*
    exerciseTrain(index)
    Author: Sophie
    Created Date & Time:  March 31 2020 6:18AM

    Function: exerciseTrain

    Description: Train stage of every exercise step is carried out by this function.

    Parameters: index(int)  - index of current exercise step 
  */
  exerciseTrain(index) {
    setState(() {
      _time = int.parse(_exerciseData[index]['durationTime']);
      _exerciseComment = _exerciseData[index]['name'];
      _stageState = 'train';
    });
    startTimer();
  }

  /*
    exerciseScore(index)
    Author: Sophie
    Created Date & Time:  March 31 2020 6:40AM

    Function: exerciseScore

    Description: Score stage of every exercise step is carried out by this function.

    Parameters: index(int)  - index of current exercise step 
  */
  exerciseScore(index) {
    _pc.open();
    FocusScope.of(context).requestFocus(myFocusNode);
  }

  /*
    timeProcess(int time, String type)
    Author: sophie
    Created Date & Time:   Mar 31 2020 5:43PM

    Function: timeProcess

    Description:  Process according to current time is carried out.

    Parameters: time(int) - current time
                type(String)  - current stage of exercise step
  */
  timeProcess(int time, String type) {
    print("_time ${_time}");
    switch (type) {
      case "train":
        if (time == (int.parse(_exerciseData[_current]['durationTime']) / 2).round()) {
          playListVoice(_exerciseData[_current]['half']);
        }
        switch (time) {
          case 8:
            setState(() {
              _exerciseComment = "Rest starts in...";
            });
            break;
          case 3:
            playListVoice(_exerciseData[_current]['3s']);
            playMusic("countdown", "sound");
            break;
          case 2:
            playListVoice(_exerciseData[_current]['2s']);
            break;
          case 1:
            playListVoice(_exerciseData[_current]['1s']);
            break;
          case 0:
            playListVoice(_exerciseData[_current]['train0s']);
            break;
          default:
        }
        break;
      case "rest":
        switch (time) {
          case 10:
            playListVoice(_exerciseData[_current]['10s']);
            break;
          case 8:
            playListVoice(_exerciseData[_current]['8s']);
            setState(() {
              _exerciseComment = _exerciseData[_current]['name'] + " starts in...";
            });
            break;
          case 3:
            playListVoice(_exerciseData[_current]['3s']);
            playMusic("countdown", "sound");
            break;
          case 2:
            playListVoice(_exerciseData[_current]['2s']);
            break;
          case 1:
            playListVoice(_exerciseData[_current]['1s']);
            break;
          case 0:
            playListVoice(_exerciseData[_current]['0s']);
            break;
          default:
        }
        break;
      default:
    }
  }

  /*
    void startTimer()
    Author: Sophie
    Created Date & Time:  Mar 31 2020 5:33AM

    Function: startTimer

    Description: Using this function, Timer can be started and all process related to timer is carried out.
  */
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            timer.cancel();
            switch (_stageState) {
              case "rest":
                exerciseTrain(_current);
                break;
              case "train":
                exerciseScore(_current);
                break;
              default:
            }
          } else {
            // print("_time ${_time}");
            timeProcess(_time, _stageState);
            print(_time);
            _time = _time - 1;
          }
        }
      )
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.settings);

    fetchData();
    myFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    _timer.cancel();
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    exerciseCarousel = CarouselSlider.builder(
      height: 500,
      itemCount: _exerciseData.length,
      itemBuilder: (BuildContext context, int itemIndex) =>
        Container(
          padding: EdgeInsets.all(50.0),
          child: new Image.network(
            _exerciseData[itemIndex]['url'],
            fit: BoxFit.cover,
          ),
        ),
    );
    
    if(_firstBuilding) {
      exerciseRest(_current, true);
      setState(() {
        _firstBuilding = false;
      });
    }

    var stringTime = _time.toString();
    if (_time < 10) {
      stringTime = "0" + _time.toString();
    }
    // print("sound ${widget.settings.sound}");
    return Container(
      color: _nightMode ? Colors.black : Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SlidingUpPanel(
            isDraggable: false,
            minHeight: 0.0,
            maxHeight: 370.0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            controller: _pc,
            panel: new Container(
              // color: Colors.transparent,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.6), spreadRadius: 2000),
                ],
              ),
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("How many reps?",
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A5998),
                    ),
                  ),
                  new Container(
                    width: 200.0,
                    child: new TextField(
                      controller: txt,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 120,
                        fontFamily: 'HK Grotesk',
                      ),
                      focusNode: myFocusNode,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ButtonTheme(
                      minWidth: 120.0,
                      // height: 100.0,
                      child: CustomFlatButton(
                        title: "Save",
                        fontSize: 20,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_current == _exerciseData.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NascarResultsScreen(
                                  settings: widget.settings,
                                )),
                            ); 
                          } else {
                            setState(() {
                              _current = _current + 1;
                            });
                            _pc.close();
                            myFocusNode.unfocus();
                            exerciseRest(_current, true);
                          }
                        },
                        splashColor: Colors.black12,
                        borderColor: Colors.black,
                        borderWidth: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ),
            body: Container(
              color: _nightMode ? Colors.black : Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: IconButton(
                      color: _nightMode ? Colors.white : Colors.grey,
                      icon: Icon(Icons.arrow_back), 
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SoccerBasics(
                              settings: widget.settings,
                            )),
                      ); 
                      _timer.cancel();
                    }),
                    title: Center(
                      child: Text(
                        'NASCAR',
                        style: TextStyle(
                          color: _nightMode ? Colors.white : Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    ),
                    subtitle: Center(
                      child: Text(
                        _exerciseData[_current]['name'],
                        style: TextStyle(
                          color: _nightMode ? Colors.white : Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      )
                    ),
                    trailing:IconButton(
                      color: _nightMode ? Colors.white : Colors.black,
                      icon: Icon(Icons.more_vert), 
                      onPressed: (){
                        if (_nightMode) {
                          setState(() {
                            _nightMode = false;
                          });
                        } else {
                          setState(() {
                            _nightMode = true;
                          });
                        } 
                    }),
                  ),
                  // exerciseCarousel,
                  Expanded(
                    child: exerciseCarousel
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        _exerciseComment,
                        style: TextStyle(
                          color: _nightMode ? Colors.white : Colors.grey,
                          fontSize: 14,
                        ),
                      )
                    ),
                    subtitle: Center(
                      child: Text(
                        '0:' + stringTime,
                        style: TextStyle(
                          color: _nightMode ? Colors.white : Colors.grey.shade800,
                          fontSize: 30,
                        ),
                      )
                    ),
                  ),
                  _carouselIndicator(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          color: _nightMode ? Colors.white : Colors.black,
                          icon: Icon(Icons.refresh,size: 50,), onPressed: (){
                          _timer.cancel();
                          setState(() {
                            _playState = true;
                          });
                          exerciseRest(_current, false);
                        }),
                        IconButton(icon: _prevIcon(), onPressed: (){
                          if (_current != 0){
                            _timer.cancel();
                            setState(() {
                              _current = _current - 1;
                              _playState = true;
                            });
                            exerciseRest(_current, false);
                          }
                        }),
                        _playPauseButton(),
                        IconButton(icon: _nextIcon(), onPressed: (){
                          if (_current != _exerciseData.length - 1) {
                            _timer.cancel();
                            setState(() {
                              _current = _current + 1;
                              _playState = true;
                            });
                            exerciseRest(_current, false);
                          }
                        }),
                        IconButton(
                          color: _nightMode ? Colors.white : Colors.black,
                          icon: Icon(Icons.stop,size: 50,), onPressed: (){
                          _timer.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SoccerBasics(
                                settings: widget.settings,
                              )),
                          );
                          
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            
          ),
        ),
      ),
    );
  }

  /*
    Widget _prevIcon()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 3:25AM

    Widget: _prevIcon

    Description:  This widget is Icon of prev Button.
  */
  Widget _prevIcon() {
    if (_current == 0) {
      return Icon(Icons.fast_rewind, size: 50,
        color: Colors.grey.withOpacity(0.5),
      );
    } else {
      return Icon(Icons.fast_rewind, size: 50,
        color: _nightMode ? Colors.white : Colors.black,
      );
    }
  }

  /*
    Widget _nextIcon()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 3:27AM

    Widget: _nextIcon

    Description:  This widget is Icon of next Button.
  */
  Widget _nextIcon() {
    if (_current == _exerciseData.length - 1) {
      return Icon(Icons.fast_forward,size: 50,
        color: Colors.grey.withOpacity(0.5),
      );
    } else {
      return Icon(Icons.fast_forward,size: 50,
        color: _nightMode ? Colors.white : Colors.black,
      );
    }
  }

  /*
    Widget _playPauseButton()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 4:10AM

    Widget: _playPauseButton

    Description:  Play/Pause Button
  */
  Widget _playPauseButton() {
    if (_playState) {
      return IconButton(
        icon: Icon(Icons.pause_circle_outline,size: 50, 
          color: _nightMode ? Colors.white : Colors.black,
        ), 
        onPressed: (){
          _timer.cancel();
          setState(() {
            _playState = false;
          });
      });
    } else {
      return IconButton(
        icon: Icon(Icons.play_circle_outline,size: 50,
          color: _nightMode ? Colors.white : Colors.black,
        ), 
        onPressed: (){
          startTimer();
          setState(() {
            _playState = true;
          });
      });
    }
  }

  /*
    Widget _carouselIndicator()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 4:56AM

    Widget: _carouselIndicator
  */
  Widget _carouselIndicator() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 0,
          child: PageView(
            controller: controller,
            children: List.generate(
                _exerciseData.length,
                (_) => Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Container(height: 280),
                    )),
          ),
        ),
        Container(
          child: SmoothPageIndicator(
            controller: controller,
            count: _exerciseData.length,
            effect:  WormEffect(
              spacing:  4.0,
              radius:  12.0,
              dotWidth:  10.0,
              dotHeight:  10.0,
              paintStyle:  PaintingStyle.fill,
              strokeWidth:  1.5,
              dotColor:  Colors.grey,
              activeDotColor:  Colors.blue
            ),
          ),
        ),
      ],
    );
  }
}