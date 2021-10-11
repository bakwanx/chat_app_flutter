import 'package:chat_app/model/searchmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getAllUser() async{
    return await firestore.collection('users').get();
  }

  getUserByUsername(String username) async {
    return await firestore.collection('users')
        .where('name', isEqualTo: username).get();
  }

  getUserByEmail(String email) async {
    return await firestore.collection('users')
        .where('email', isEqualTo: email).get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('users')
        .add(userMap);
  }
  
  createChatRoom(String chatRoomId, chatRoomMap){
    firestore.collection('ChatRoom')
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
       print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    firestore.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap).catchError((e){
      e.toString();
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await firestore.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await firestore.collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}