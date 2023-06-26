
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/commnet_card.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _CommentController = TextEditingController();

  @override
  void dispose() {
    _CommentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final UserClass user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("post")
            .doc(widget.snap['postId'])
            .collection("comments").orderBy('datePublished',descending: true)
            .snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
            return CommentCard(snap: snapshot.data!.docs[index].data());
          },);
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
          padding: EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 8),
                  child: TextField(
                    controller: _CommentController,
                    decoration: InputDecoration(
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                 await FirestoreMethods().postComment(
                      widget.snap["postId"], _CommentController.text,
                      user.uid, user.username, user.photoUrl);
                 setState(() {
                   _CommentController.text = '';
                 });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                  child: Text("Post",style: TextStyle(color: Colors.blueAccent),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
