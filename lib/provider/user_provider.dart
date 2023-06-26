
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resources/auth_method.dart';

class UserProvider with ChangeNotifier{
  UserClass? _user;
  UserClass get getUser => _user!;
  final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUser() async{
    UserClass user = await _authMethods.getUserDetails();
     _user = user;
     notifyListeners();
  }

}