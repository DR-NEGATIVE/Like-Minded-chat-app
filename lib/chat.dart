import 'dart:io';
import 'database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          message:
                              snapshot.data.documents[index].data()["message"],
                          sendByMe: Constants.myName ==
                              snapshot.data.documents[index].data()["sendBy"],
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width - 60,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 4)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageEditingController,
                                  decoration: InputDecoration(
                                      hintText: "Send Message...",
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(80)),
                            child: Icon(
                              Icons.send,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  ),
                  //hm
                ],
              )
            : Container();
      },
    );
  }

  String image = "";
  QuerySnapshot ofcourseImage;
  _getUserImageforchatroom() async {
    await DatabaseMethods()
        .searchByName(widget.chatRoomId
            .replaceAll("_", "")
            .replaceAll(Constants.myName, ""))
        .then((val) {
      ofcourseImage = val;
      setState(() {
        image = ofcourseImage.docs[0].data()['userImage'];
      });
    });
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    _getUserImageforchatroom();
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        print(widget.chatRoomId);
        chats = val;
      });
    });
    super.initState();
  }

  _customAppbar2() {
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
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 2)),
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
              Container(
                margin: EdgeInsets.only(top: 18),
                child: Text(
                  widget.chatRoomId
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppbar2(),
      body: Stack(
        children: [
          chatMessages(),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff424242), const Color(0xff212121)]
                  : [const Color(0xff6A1B9A), const Color(0xff4A148C)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
