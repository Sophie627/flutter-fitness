import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userID;
  final String firstName;
  final String email;
  final String profilePictureURL;
  final String state;
  final String club;
  final String position;
  final String jersey;
  final DateTime birthday;
  final List term;

  User({
    this.userID,
    this.firstName,
    this.email,
    this.profilePictureURL,
    this.state = '',
    this.birthday,
    this.club = '',
    this.jersey = '',
    this.position = '',
    this.term,
  });

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'email': email == null ? '' : email,
      'state': state == null ? '' : state,
      'birthday': birthday == null ? '' : birthday,
      'club': club == null ? '' : club,
      'jersey': jersey == null ? '' : jersey,
      'position': position == null ? '' : position,
      'term': term == null ? '' : term,
      'profilePictureURL': profilePictureURL,
      'appIdentifier': 'flutter-onboarding',
    };
  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      userID: doc['userID'],
      firstName: doc['firstName'],
      email: doc['email'],
      profilePictureURL: doc['profilePictureURL'],
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
