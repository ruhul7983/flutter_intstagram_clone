import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/dimension.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({Key? key, required this.webScreenLayout, required this.mobileScreenLayout}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth>webScreenSize){
        //web screen
        return widget.webScreenLayout;
      }
      //mobile screen
      return widget.mobileScreenLayout;
    });
  }
}
