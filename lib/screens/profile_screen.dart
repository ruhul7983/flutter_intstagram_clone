import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/follow_button.dart';
import 'package:instagram_clone/healpers/dialogs.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/loginScreen.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData()async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance.collection('post').where('uid',isEqualTo: widget.uid).get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(widget.uid);
      setState(() {

      });

    }catch(err){
      dialogs.showSnackbar(context, err.toString());
    }
    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator(),): Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
            //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(postLen, 'posts'),
                              buildStateColumn(followers, 'Followers'),
                              buildStateColumn(following, 'Following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? FollowButton(
                                      backGroundColor: mobileBackgroundColor,
                                      borderColor: Colors.grey,
                                      buttonName: 'Sign out',
                                      textColor: primaryColor,
                                      function: () async {
                                        await AuthMethods().signOut();
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>LoginScreen()));
                                      },
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          backGroundColor:Colors.white,
                                          borderColor: Colors.grey,
                                          buttonName: 'Unfollow',
                                          textColor: Colors.black,
                                          function: ()async{
                                            await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                            setState(() {
                                              isFollowing  = false;
                                              followers --;
                                            });
                                          },
                                        )
                                      : FollowButton(
                                          backGroundColor:
                                              Colors.blue,
                                          borderColor: Colors.blue,
                                          buttonName: 'Follow',
                                          textColor: Colors.white ,
                                          function: () async {
                                            await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                            setState(() {
                                              isFollowing  = true;
                                              followers ++;
                                            });
                                          },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(userData['username'],style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 1),
                  child: Text(userData['bio'],style: TextStyle(),),
                ),
                Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('post').where('uid',isEqualTo: widget.uid).get(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(
                                snap['postUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      },);
                },),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Column buildStateColumn(int num, String label){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(num.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
        Text(label,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.grey),),
      ],
    );
  }

}

