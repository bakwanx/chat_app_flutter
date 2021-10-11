import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_app/theme.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState() {
    Timer(Duration(seconds: 3),
            () => Navigator.pushNamed(context, '/signin')
    );
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/logo_splash.png',
            height: 100,
          ),
        ),
      ),
    );
  }
}
