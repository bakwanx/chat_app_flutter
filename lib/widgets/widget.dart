import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset(
      'assets/images/logo_splash.png',
      height: 30,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent)
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
      )
  );
}