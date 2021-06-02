import 'package:flutter/material.dart';
import 'package:lm_login/constant.dart';
import 'package:lm_login/modal/user.dart';
import '../database.dart';
import '../chat.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';

class SearchGroup extends StatefulWidget with NavigationStates {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchGroup();
  }
}

class _SearchGroup extends State<SearchGroup> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;
  String _imageofsearch =
      "https://64.media.tumblr.com/9f9b498bf798ef43dddeaa78cec7b027/tumblr_o51oavbMDx1ugpbmuo7_540.png";
  QuerySnapshot _getimage;
  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
          _getuserinfo();
        });
      });
    }
  }

  _getuserinfo() async {
    await DatabaseMethods()
        .getUserInfo(searchResultSnapshot.docs[0].data()['userEmail'])
        .then((val) async {
      setState(() {
        _getimage = val;
        _imageofsearch = _getimage.docs[0].data()['userImage'];
      });
    });
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.docs[index].data()["userName"],
                searchResultSnapshot.docs[index].data()["userEmail"],
              );
            })
        : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userTile(String userName, String userEmail) {
    // this part have bugs
    // pixel problem
    // occur when email is too big
    // so i'm start using expanded here which causing grey screen when  realease build used
    //sorry for bad english
    //upadted expanded problem
    //old code in testing_unit
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 2),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 2)),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_imageofsearch),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16),
              ),
              Text(
                userEmail,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              print(userName);
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  _customAppbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: 100.0,
        decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).accentColor, width: 3)),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          'Search',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppbar(),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 40, left: 20, right: 20.0, bottom: 15.0),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          )
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "search username ...",
                                hoverColor: Theme.of(context).accentColor,
                                hintStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              initiateSearch();
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ))
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
