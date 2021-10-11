import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/pages/conversation_screen.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return ChatRoomsTile(
              snapshot.data.docs[index].data()['chatroomId']
                  .toString().replaceAll('_', '').replaceAll(Constans.myName, ''),
                snapshot.data.docs[index].data()['chatroomId']
            );
          },
        ) : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constans.myName = await HelperFunctions.getUserNameLoggedPreference();
    databaseMethods.getChatRooms(Constans.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
        title: Image.asset(
          'assets/images/logo_splash.png',
          height: 30,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.pushNamed(context, '/search');
        },
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text(
                '${userName.substring(0,1).toUpperCase()}',
                style: primaryTextStyle
              ),
            ),
            SizedBox(width: 8),
            Text(userName, style: blackTextStyle)
          ],
        ),
      ),
    );
  }
}

