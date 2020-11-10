import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List userData = [];
  List userAdminData = [];
  bool isLoading = true;

  Future<void> deleteUserDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('Are you sure?'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('Will you really this user?',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                deleteUser(id); 
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel',
                style: TextStyle(
                  fontSize: 13.0
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  fetchUserData() {
    Firestore.instance.collection('users').snapshots().listen((data) {
      setState(() {
        userData = [];
      });
      data.documents.forEach((doc) {
        userData.add(doc);
        if (doc['role'] == 'admin') {
          userAdminData.add(true);
        } else {
          userAdminData.add(false);
        }
      });
      setState(() {
        userData = userData;
        userAdminData = userAdminData;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(userData);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          "User Management",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
      body: isLoading 
      ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          strokeWidth: 1,
        ),
      )
      : userList(context),
    );
  }

  Widget userList(BuildContext context){
    List<Widget> userList = [];
    userData.asMap().forEach((index, element) {
      userList.add(
        ListTile(
          title: Text(element['firstName']),
          subtitle: Text(element['email']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Checkbox(
                checkColor: Colors.black,
                value: userAdminData[index], 
                onChanged: (value) {
                  setState(() {
                    userAdminData[index] = value;
                  });
                  updateUserRole(element['userID'], index);
                }
              ),
              Text('Admin'),
              IconButton(
                icon: Icon(Icons.delete,
                  color: Colors.red,
                ), 
                onPressed: () {
                  deleteUserDialog(element['userID']);
                },
              ),
            ],
          ),
        )
      );
    });

    return ListView(
      children: ListTile.divideTiles(
        tiles: userList,
        context: context,
      ).toList(),
    );
  }

  void deleteUser(String userID) {
    Firestore.instance.collection('users').document(userID).delete()
    .then((value) => print("User Deleted"))
    .catchError((onError) => print("Failed to delete user: $onError"));
  }

  void updateUserRole(String userID, int index) {
    if (userData[index]['role'] == 'admin') {
      Firestore.instance.collection('users').document(userID)
      .updateData({'role': 'user'})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
    } else {
      Firestore.instance.collection('users').document(userID)
      .updateData({'role': 'admin'})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
    }
  }
}