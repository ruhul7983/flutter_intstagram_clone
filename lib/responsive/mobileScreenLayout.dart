import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_screen_post.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {

  late PageController pageController;
  int _page = 0;
  void navigateToTab(int page){
    pageController.jumpToPage(page);

  }
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    // UserClass user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text("data"),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _page ==0? primaryColor:secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _page ==1? primaryColor:secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: _page ==2? primaryColor:secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _page ==3? primaryColor:secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _page ==4? primaryColor:secondaryColor,),
            label: "",
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigateToTab,
        currentIndex: _page,
      ),
    );
  }
}
