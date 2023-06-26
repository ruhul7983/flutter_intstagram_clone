import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Widgets/text_input_field.dart';
import 'package:instagram_clone/healpers/dialogs.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/loginScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../main.dart';
import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }
//h
  void signUp() {
    setState(() {
      _isLoading = true;
    });
    String res = AuthMethods().signUp(
        email: _emailController.text,
        password: _passwordController.text,
        username: _userNameController.text,
        bio: _bioController.text,
        file: _image!);

    if (res == 'Success') {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResponsiveLayout(
                  webScreenLayout: webScreenLayout(),
                  mobileScreenLayout: mobileScreenLayout())));
    }else{
      dialogs.showSnackbar(context, "Please fill all field");
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: mq.height * 0.09,
                ),
                Image.asset(
                  "assets/ic_instagram.png",
                  color: primaryColor,
                  height: 64,
                  fit: BoxFit.fitHeight,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage("assets/profile.png"),
                          ),
                    Positioned(
                        bottom: -10,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: Icon(
                            Icons.add_photo_alternate,
                          ),
                        ))
                  ],
                ),
                SizedBox(height: mq.height * 0.04),
                TextInputField(
                    textEditingController: _userNameController,
                    hintText: "Enter your username",
                    textInputType: TextInputType.text),
                SizedBox(height: mq.height * 0.04),
                TextInputField(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress),
                SizedBox(height: mq.height * 0.04),
                TextInputField(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                SizedBox(height: mq.height * 0.04),
                TextInputField(
                    textEditingController: _bioController,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.text),
                SizedBox(height: mq.height * 0.04),
                InkWell(
                  onTap: () {
                    signUp();
                  },
                  child: Container(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text("Sing up"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child: Text("Have a account?")),
                    InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                        child: Container(
                            child: Text(
                          " Log in.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
