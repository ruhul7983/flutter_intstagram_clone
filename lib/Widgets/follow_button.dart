import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backGroundColor;
  final Color borderColor;
  final Color textColor;
  final String buttonName;

  const FollowButton({Key? key, this.function, required this.backGroundColor, required this.borderColor, required this.buttonName, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 28),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backGroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(buttonName,style: TextStyle(color: textColor,fontWeight: FontWeight.bold),),
          height: 27,
          width: 250,
        ),
      ),
    );
  }
}
