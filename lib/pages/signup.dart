import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/service/database.dart';

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController(text: '');
  TextEditingController emailTextEditingController = new TextEditingController(text: '');
  TextEditingController passwordTextEditingController = new TextEditingController(text: '');

  signMeUp(){

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

      Map<String, String> userInfoMap = {
        'name' : userNameTextEditingController.text,
        'email' : emailTextEditingController.text
      };

      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      authMethods.signUpWithEmailandPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/chat-room',
          (route) => false
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 2 ? 'Please provide username' : null;
                        },
                        controller: userNameTextEditingController,
                        decoration: textFieldInputDecoration("Username")
                      ),
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
                      ),
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
                    signMeUp();
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
                      'Sign Up',
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
                    'Sign Up With Google',
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
                      "Already have account? ",
                      style: blackTextStyle,
                    ),
                    Text(
                        "SignIn Now",
                        style: blackTextStyle.copyWith(
                            decoration: TextDecoration.underline
                        )
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
