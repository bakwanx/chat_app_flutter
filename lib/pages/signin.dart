import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController(text: '');
  TextEditingController passwordTextEditingController = new TextEditingController(text: '');
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;


  signIn() async{
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      await authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value) async{
        if(value != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushNamedAndRemoveUntil(
              context,
              '/chat-room',
                  (route) => false
          );
        }
      });

      databaseMethods.getUserByEmail(emailTextEditingController.text).then((value){
        snapshotUserInfo = value;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()['name']);

      });

      HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.docs[0].data()['email']);

    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key:formKey ,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";
                        },
                        controller: emailTextEditingController,
                        decoration: textFieldInputDecoration("Email"),
                      ),
                      TextFormField(
                          obscureText: true,
                          validator: (val){
                            return val.isEmpty || val.length < 2 ? 'Please provide password 6+ character' : null;
                          },
                          controller: passwordTextEditingController,
                          decoration: textFieldInputDecoration("Password")
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8
                    ),
                    child: Text(
                      'Forgot Password ? ',
                      style: blackTextStyle.copyWith(
                        fontSize: 16
                      )
                    )
                  )
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      vertical: 20
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text(
                      'Sign In',
                      style: primaryTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      vertical: 20
                  ),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(
                    'Sign In With Google',
                    style: primaryTextStyle,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have account? ",
                      style: blackTextStyle,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Register Now",
                        style: blackTextStyle.copyWith(
                          decoration: TextDecoration.underline
                        )
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

