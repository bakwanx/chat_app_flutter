import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/model/searchmodel.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/widgets/userSearchTile.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot, allResultSnapshot;
  bool isSearch = false;

  initiateSearch() async{
     await databaseMethods
          .getUserByUsername(searchTextEditingController.text)
        .then((val){
      setState(() {
        searchResultSnapshot = val;
      });
    });

    /* ini benar dapat semua user
    QuerySnapshot variable = await FirebaseFirestore.instance.collection('users').get();
    final _docData = variable.docs.map((doc) => doc.data()).toList();
    */

  }

  initiateUserAll() async{
    await databaseMethods
        .getAllUser()
        .then((val){
          setState(() {
            allResultSnapshot = val;
          });
    });

    /* ini benar dapat semua user
    QuerySnapshot variable = await FirebaseFirestore.instance.collection('users').get();
    final _docData = variable.docs.map((doc) => doc.data()).toList();
    */

  }

  Widget userList(){
    initiateUserAll();
    return allResultSnapshot != null ? ListView.builder(
        itemCount: allResultSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            name: allResultSnapshot.docs[index].data()['name'],
            email: allResultSnapshot.docs[index].data()['email'],
          );
        }
    ) : Expanded(child: Center(child: CircularProgressIndicator()));
  }



  Widget searchList(){
    return searchResultSnapshot != null ?  ListView.builder(
      itemCount: searchResultSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTile(
          name: searchResultSnapshot.docs[index].data()['name'],
          email: searchResultSnapshot.docs[index].data()['email'],
        );
      }
    ) : Expanded(child: Center(child: CircularProgressIndicator()));
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black45,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Search username...",
                        hintStyle: TextStyle(
                          color: Colors.white54
                        ),
                        border: InputBorder.none
                      )
                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isSearch = true;
                      });
                      initiateSearch();
                      if(searchTextEditingController.text.toString().isEmpty){
                        setState(() {
                          isSearch = false ;
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/search_white.png'
                      )
                    ),
                  )
                ],
              ),
            ),
            isSearch == false ? userList() : searchList()
          ],
        ),
      ),
    );
  }
}


