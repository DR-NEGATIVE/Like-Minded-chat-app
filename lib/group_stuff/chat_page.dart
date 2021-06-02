import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lm_login/group_stuff/database2.dart';
import 'package:lm_login/group_stuff/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({this.groupId, this.userName, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return MessageTiles(
                            message: snapshot.data.documents[index]
                                .data()["message"],
                            sender:
                                snapshot.data.documents[index].data()["sender"],
                            sentByMe: widget.userName ==
                                snapshot.data.documents[index].data()["sender"],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 5,
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
                          _sendMessage();
                        },
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(80)),
                            child: Icon(
                              Icons.send,
                              color: Colors.black,
                            )),
                      )
                    ],
                  )
                ],
              )
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  _customAppbar12() {
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
                  backgroundImage: AssetImage('assets/logos/okay.jpg'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18),
                child: Text(
                  widget.groupName,
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
      appBar: _customAppbar12(),
      // appBar: AppBar(
      //   title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      //   backgroundColor: Colors.black87,
      //   elevation: 0.0,
      // ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
          ],
        ),
      ),
    );
  }
}
