import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass{
  final String email;
  final String uid;
  final String bio;
  final String photoUrl;
  final String username;
  final List followers;
  final List following;

  UserClass({
  required this.email,
  required this.uid,
  required this.bio,
  required this.username,
  required this.photoUrl,
  required this.followers,
  required this.following,
});
  Map<String,dynamic> toJson()=>{
    "username":username,
    "uid":uid,
    "email":email,
    "bio":bio,
    "photoUrl":photoUrl,
    "followers":followers,
    "following":following,
  };

  static UserClass fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserClass(
      email: snapshot['email'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

}