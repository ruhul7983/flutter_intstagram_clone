import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/text_input_field.dart';
import 'package:instagram_clone/healpers/dialogs.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/signUpScreen.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../main.dart';
import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> loginuser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);

    if(res == "success"){
      //Navigate next page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResponsiveLayout(
                  webScreenLayout: webScreenLayout(),
                  mobileScreenLayout: mobileScreenLayout())));
    }else{
      dialogs.showSnackbar(context, "Some thing went wrong");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Image.asset(
                "assets/ic_instagram.png",
                color: primaryColor,
                height: 64,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: mq.height * 0.08),
              TextInputField(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,),
              SizedBox(height: mq.height * 0.04),
              TextInputField(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(height: mq.height * 0.04),
              InkWell(
                onTap: (){
                  loginuser();
                },
                child: Container(
                  child: _isLoading?Center(child: CircularProgressIndicator(color: primaryColor,),):Text("Log in"),
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
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child: Text("Don't have account?")),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUp()));
                      },
                        child: Container(
                            child: Text(
                      " Sign up.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
