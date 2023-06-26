import 'package:cloud_firestore/cloud_firestore.dart';

class PostClass{
  final String description;
  final String uid;
  final String postId;
  final datePublished;
  final String username;
  final String postUrl;
  final String profImage;
  final likes;

  PostClass({
  required this.description,
  required this.uid,
  required this.postId,
  required this.username,
  required this.postUrl,
  required this.datePublished,
  required this.likes,
  required this.profImage,
});
  Map<String,dynamic> toJson()=>{
    "username":username,
    "uid":uid,
    "description":description,
    "postId":postId,
    "profImage":profImage,
    "likes":likes,
    "postUrl":postUrl,
    "datePublished":datePublished,
  };

  static PostClass fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostClass(
      description: snapshot['description'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
    );
  }

}