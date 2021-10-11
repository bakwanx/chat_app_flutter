
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/model/searchmodel.dart';
import 'package:chat_app/pages/conversation_screen.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {


  //final SearchModel searchModel;
  final String name;
  final String email;
  SearchTile({this.name, this.email});
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {

    createChatRooomAnsStartConversation(String username){
      if(username != Constans.myName){
        print('username ${username} && ${Constans.myName}');
        String chatRoomId = getChatRoomId(username, Constans.myName);
        List<String> users = [
          username,
          Constans.myName
        ];

        Map<String, dynamic> chatRoomMap = {
          'users' : users,
          'chatroomId' : chatRoomId
        };

        databaseMethods.createChatRoom(chatRoomId, chatRoomMap);

        //Navigator.pushNamed(context, '/conversation-screen');
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      }else{
        print('Cant send message to yourself');
      }

    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${name}',
                style: blackTextStyle,
              ),
              Text(
                '${email}',
                style: blackTextStyle,
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRooomAnsStartConversation(name);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Message',
                style: primaryTextStyle.copyWith(
                  fontSize: 12
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}