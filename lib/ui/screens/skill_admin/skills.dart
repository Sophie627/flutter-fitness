import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:onboarding_flow/ui/screens/skill_admin/skill_form.dart';

class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List skillData = [];
  List skillID = [];
  bool isLoading = true;

  fetchSkillData() {
    Firestore.instance.collection('skill').snapshots().listen((data) {
      setState(() {
        skillData = [];
      });
      data.documents.forEach((doc) {
        skillData.add(doc);
        skillID.add(doc.documentID);
      });
      setState(() {
        skillData = skillData;
        skillID = skillID;
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
    print('skillData: $skillData');
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          "Skill Management",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkillFormScreen(
                        skillID: 'createskill!!!',
                      )),
                  ).then((value) => setState((){}));
                },
                child: Text('+ Add New Skill',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
              ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  strokeWidth: 1,
                ),
              )
              : skillList(),
            ),
          ]
        ),
      ),
    );
  }

  Widget skillList() {
    print(skillData.length);
    List<Widget> skillList = [];
    skillData.asMap().forEach((key, value) {
      skillList.add(
        Slidable(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Image.network(
                  value['url'],
                  height: 90.0,
                ),
                SizedBox(width: 20.0),
                Container(
                  child: Center(
                    child: Text(value['name'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                    ),
                  ), 
                ),
              ],
            )
          ),
          actionPane: SlidableDrawerActionPane(),
          actions: <Widget>[
            IconSlideAction(
              caption: 'More',
              color: Colors.grey.shade200,
              icon: Icons.more_horiz,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SkillFormScreen(
                    skillID: skillID[key],
                  )),
              ),
              closeOnTap: false,
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => deleteSkill(skillID[key]),
            ),
          ],
        ),
      );
    });
    return ListView(
      children: skillList,
    );
  }

  void deleteSkill(String skillID) {
    Firestore.instance.collection('skill').document(skillID).delete()
    .then((value) => print("Skill Deleted"))
    .catchError((onError) => print("Failed to delete skill: $onError"));
  }
}