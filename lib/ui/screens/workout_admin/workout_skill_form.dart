import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class WorkoutSkillFromScreen extends StatefulWidget {

  final String workoutSkillID;
  final int workoutID;

  WorkoutSkillFromScreen({
    this.workoutSkillID,
    this.workoutID
  });

  @override
  _WorkoutSkillFromScreenState createState() => _WorkoutSkillFromScreenState();
}

class _WorkoutSkillFromScreenState extends State<WorkoutSkillFromScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final TextEditingController restMusicTime = new TextEditingController();
  final TextEditingController restMusicName = new TextEditingController();
  final TextEditingController trainMusicTime = new TextEditingController();
  final TextEditingController trainMusicName = new TextEditingController();
  String durationTime = "1";
  String restTime = "1";
  Map restMap = {};
  Map trainMap = {};
  bool isLoading = true;

  fetchSkillData() {
    Firestore.instance.collection('exercise' + widget.workoutID.toString()).document(widget.workoutSkillID).get().then((value) {
      if (value['durationTime'] != null) setState(() {
        durationTime = value['durationTime'];
      });
      if (value['restTime'] != null) setState(() {
        restTime = value['restTime'];
      });
      if (value['voice'] != null) {
        if(value['voice']['rest'] != null) setState(() {
          restMap = value['voice']['rest'];
        });
        if(value['voice']['train'] != null) setState(() {
          trainMap = value['voice']['train'];
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    fetchSkillData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading 
    ? Material(
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          strokeWidth: 1,
        ),
      ),
    )
    : Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'Skill Management',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
            child:  Row(
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text("Duration Time",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => showMaterialNumberPicker(
                      context: context,
                      title: "Pick Duration Time",
                      maxNumber: 100,
                      minNumber: 1,
                      confirmText: "OK",
                      cancelText: "Cancel",
                      selectedNumber: int.parse(durationTime),
                      onChanged: (value) => setState(() => durationTime = value.toString()),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      durationTime,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ), 
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
            child:  Row(
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text("Rest Time",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => showMaterialNumberPicker(
                      context: context,
                      title: "Pick Rest Time",
                      maxNumber: 100,
                      minNumber: 1,
                      confirmText: "OK",
                      cancelText: "Cancel",
                      selectedNumber: int.parse(restTime),
                      onChanged: (value) => setState(() => restTime = value.toString()),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      restTime,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ), 
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Divider(
              color: Colors.grey[200],
              thickness: 2.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Text('Voice',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: Text('Rest',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                voiceList(restMap, 'rest'),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: restMusicTime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Time',
                          ),
                        ),
                      ),
                      Text(' s: '),
                      Flexible(
                        child: TextField(
                          controller: restMusicName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Music Name',
                          ),
                        ),
                      ),
                      Text(' .mp3'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline), 
                        onPressed: addRestVoice),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: Text('Train',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                voiceList(trainMap, 'train'),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: trainMusicTime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Time',
                          ),
                        ),
                      ),
                      Text(' s: '),
                      Flexible(
                        child: TextField(
                          controller: trainMusicName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Music Name',
                          ),
                        ),
                      ),
                      Text(' .mp3'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline), 
                        onPressed: addTrainVoice),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Divider(
              color: Colors.grey[200],
              thickness: 2.0,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  actionSaveSkill();
                },
                child: Text('Save Skill',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget voiceList(Map map, String field) {
    List<Widget> voiceList = [];
    map.forEach((key, value) {
      voiceList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${key}s: ${value}.mp3',
              style: TextStyle(
                fontSize: 22.0
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete,
                color: Colors.red,
                size: 32.0,
              ), 
              onPressed: () {
                if (field == 'rest') removeRestVoice(key);
                else removeTrainVoice(key); 
              },
            ),
          ],
        )
      );
    });
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 20.0),
      child: Column(
        children: voiceList,
      ),
    );
  }

  void removeRestVoice(String key) {
    restMap.remove(key);
    Firestore.instance.collection('exercise' + widget.workoutID.toString()).document(widget.workoutSkillID)
      .updateData({'voice': {'rest': restMap, 'train': trainMap}})
      .then((value) => print("Rest Voice Updated"))
      .catchError((error) => print("Failed to update rest voice: $error"));
    setState(() {
      restMap = restMap;
    });
    restMusicTime.text = '';
    restMusicName.text = '';
  }

  void removeTrainVoice(String key) {
    trainMap.remove(key);
    Firestore.instance.collection('exercise' + widget.workoutID.toString()).document(widget.workoutSkillID)
      .updateData({'voice': {'rest': restMap, 'train': trainMap}})
      .then((value) => print("Train Voice Updated"))
      .catchError((error) => print("Failed to update train voice: $error"));
    setState(() {
      trainMap = trainMap;
    });
    trainMusicTime.text = '';
    trainMusicName.text = '';
  }

  void addRestVoice() {
    if (restMusicTime.text == '' || restMusicName.text == '') return;
    restMap[restMusicTime.text] = restMusicName.text;
    Firestore.instance.collection('exercise' + widget.workoutID.toString()).document(widget.workoutSkillID)
      .updateData({'voice': {'rest': restMap, 'train': trainMap}})
      .then((value) => print("Rest Voice Updated"))
      .catchError((error) => print("Failed to update rest voice: $error"));
    setState(() {
      restMap = restMap;
    });
    restMusicTime.text = '';
    restMusicName.text = '';
  }

  void addTrainVoice() {
    if (trainMusicTime.text == '' || trainMusicName.text == '') return;
    trainMap[trainMusicTime.text] = trainMusicName.text;
    Firestore.instance.collection('exercise' + widget.workoutID.toString()).document(widget.workoutSkillID)
      .updateData({'voice': {'rest': restMap, 'train': trainMap}})
      .then((value) => print("Train Voice Updated"))
      .catchError((error) => print("Failed to update train voice: $error"));
    setState(() {
      restMap = restMap;
    });
    trainMusicTime.text = '';
    trainMusicName.text = '';
  }

  void actionSaveSkill() {
     Firestore.instance.collection('exercise' + widget.workoutID.toString()).document(widget.workoutSkillID)
      .updateData({'durationTime': durationTime, 'restTime': restTime})
      .then((value) => print("Skill Updated"))
      .catchError((error) => print("Failed to update skill: $error"));
    Navigator.of(context).pop();
  }
}