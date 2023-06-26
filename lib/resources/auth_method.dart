import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/user.dart';



import 'package:instagram_clone/resources/stroage_method.dart';

class AuthMethods{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get user details
  Future<UserClass> getUserDetails() async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection("users").doc(currentUser.uid).get();
    return UserClass.fromSnap(snap);

  }

  signUp({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file, // for image
})async{
    String res = "Something went wrong";

    try{
      if(email.isNotEmpty ||password.isNotEmpty ||username.isNotEmpty ||bio.isNotEmpty ||file != null){
        //register user
       UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       //set data to firebase storage
      String photoUrl =await StorageMethods().uploadImage("profilePic", file, false);

       UserClass user = UserClass(email: email,
           uid: cred.user!.uid,
           bio: bio,
           username: username,
           photoUrl: photoUrl,
           followers: [],
           following: []);


        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
        res = "Success";
      }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }


  //for login user
  Future<String> loginUser({
    required String email,
    required String password,
}) async {
    String res = "Something went worng";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }else{
        return res = "Please enter all filed";
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }
  //signOut
  Future<void> signOut()async{
    await _auth.signOut();
  }
}