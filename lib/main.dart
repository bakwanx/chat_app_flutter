
import 'package:chat_app/pages/chatRoomScreen.dart';
import 'package:chat_app/pages/conversation_screen.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/pages/signup.dart';
import 'package:chat_app/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashPage(),
        '/signin': (context) => SignIn(),
        '/signup': (context) => SignUp(),
        '/chat-room': (context) => ChatRoom(),
        '/search': (context) => SearchScreen(),
        //'/conversation-screen': (context) => ConversationScreen()
      }
    );
  }
}

