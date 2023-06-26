import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search for user',
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser? FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("users").where("username",isGreaterThanOrEqualTo:searchController.text ).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid'])));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl']),
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username']),
                ),
              );
          },);
        },
      ):FutureBuilder(
        future: FirebaseFirestore.instance.collection('post').get(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(imageUrl: (snapshot.data! as dynamic).docs[index]['postUrl']);
              },
            );;
          }
      ),
    );
  }
}
