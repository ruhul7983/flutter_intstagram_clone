
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/resources/stroage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
      String description,
      String uid,
      String username,
      String profImage,
      Uint8List file,
      ) async {
    String res = "Something went wrong";
    try{
      String photoUrl =await StorageMethods().uploadImage('posts', file, true);
      String postId = Uuid().v1();

      PostClass post = PostClass(description: description,
          uid: uid,
          postId: postId,
          username: username,
          postUrl: photoUrl,
          datePublished: DateTime.now(),
          likes: [],
          profImage: profImage,
      );
      _firestore.collection("post").doc(postId).set(post.toJson());
      res = 'success';

    }catch(err){
      res = "Try again";
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes)async{
    try{
        if(likes.contains(uid)){
          await _firestore.collection("post").doc(postId).update({
            'likes':FieldValue.arrayRemove([uid]),
          });
        }else{
          await _firestore.collection("post").doc(postId).update({
            'likes':FieldValue.arrayUnion([uid]),
          });
        }
    }catch(err){
      print(err.toString());
    }
  }

  //storing comment
  Future<void> postComment(String postId,String text,String uid, String name, String profilePic)async{
    try{
      if(text.isNotEmpty){
        String commentId = Uuid().v1();
        await _firestore.collection("post").doc(postId).collection("comments").doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'uid':uid,
          'text':text,
          'commentId':commentId,
          'datePublished':DateTime.now(),

        });
      }else{
        print("Text is Empty");
      }
    }catch(err){
      print(err.toString());
    }
  }

  //deleting post
  Future<void> deletePost(String postId,String uid)async {
    try{
      if(uid == FirebaseAuth.instance.currentUser!.uid){
        await _firestore.collection("post").doc(postId).delete();
      }
    }catch(err){

    }
  }

  //followers

  Future<void> followUser(String uid,String followId)async{
    try{
     DocumentSnapshot snap=  await _firestore.collection('users').doc(uid).get();
     List following  = (snap.data()! as dynamic)['following'];
     if(following.contains(followId)){
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          'followers': FieldValue.arrayRemove([followId]),
        });
     }else{
       await _firestore.collection("users").doc(followId).update({
         'followers': FieldValue.arrayUnion([uid]),
       });
       await _firestore.collection("users").doc(uid).update({
         'followers': FieldValue.arrayUnion([followId]),
       });
     }



    }catch(err){

    }
  }

}