import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../Widgets/post_cart.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: Image.asset("assets/ic_instagram.png",color: primaryColor,height: 31,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.messenger_outline_outlined)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("post").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState ==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
            return PostCart(
              snap: snapshot.data!.docs[index].data(),
            );
          },);
        }
      ),
    );
  }
}
