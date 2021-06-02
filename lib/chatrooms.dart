import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lm_login/helper/auth.dart';
import 'package:lm_login/helper/helperfunctions.dart';
import './services.dart';
import './database.dart';
import './chat.dart';
import './constants.dart';
import './bloc.navigation_bloc/navigation_bloc.dart';
import './about_chatguy.dart';
import 'package:lm_login/group_stuff/pagerouteanim.dart';
import 'package:lm_login/pages/searchgroup.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget with NavigationStates {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  String image_for_user =
      'https://64.media.tumblr.com/9f9b498bf798ef43dddeaa78cec7b027/tumblr_o51oavbMDx1ugpbmuo7_540.png';

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data()["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  QuerySnapshot ofcourseImage;
  _getUserImageforchatroom() async {
    await DatabaseMethods().searchByName('Dr Negative').then((val) {
      ofcourseImage = val;
      image_for_user = ofcourseImage.docs[0].data()['userImage'];
    });
    return image_for_user;
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  _customAppbar3() {
    var s = MediaQuery.of(context).size.width;
    s = s / 10;
    return PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Theme.of(context).accentColor, width: 3)),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 25, left: 30, right: 20, bottom: 10),
                height: s,
                width: s,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(s),
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 2)),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/logos/element.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18),
                child: Text(
                  'LIKE MINDED',
                  style: TextStyle(fontSize: 25, fontFamily: 'Raleway'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: s - 15, left: s - 20, right: s - 30, bottom: s - 30),
                height: s,
                width: s,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(s),
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 2)),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/logos/SEA.png'),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: s - 15, left: s - 30, bottom: s - 30),
                height: s,
                width: s,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(s),
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 2)),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/logos/2nd.png'),
                ),
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppbar3(),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, SlideRightRoute(page: SearchGroup()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _chatroomstuff(userName: userName, chatRoomId: chatRoomId);
  }
}

class _chatroomstuff extends State<ChatRoomsTile> {
  final String userName;
  final String chatRoomId;
  String image = "";
  String Email = "";
  String about = " ";
  QuerySnapshot ofcourseImage;
  _getUserImageforchatroom() async {
    await DatabaseMethods().searchByName(userName).then((val) {
      ofcourseImage = val;
      setState(() {
        image = ofcourseImage.docs[0].data()['userImage'];
        Email = ofcourseImage.docs[0].data()['userEmail'];
        about = ofcourseImage.docs[0].data()['about'];
      });
    });
  }

  void initState() {
    _getUserImageforchatroom();
    super.initState();
  }

  _chatroomstuff({this.userName, @required this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            SlideRightRoute(
                page: Chat(
              chatRoomId: chatRoomId,
            )));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).accentColor, width: 0.5)),
          color: Colors.black26,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return chatGuy(
                            name: userName,
                            image: image,
                            about: about,
                            email: Email,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 400),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // ignore: missing_required_param
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                      ));
                },
                child: CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}
