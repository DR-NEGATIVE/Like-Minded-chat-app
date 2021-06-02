import 'package:flutter/material.dart';
import 'package:lm_login/group_stuff/chat_page.dart';
import 'package:lm_login/group_stuff/database2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './AboutGroupMember.dart';
import './pagerouteanim.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;
  String recent = "join the conversation";
  String current = ":)";

  GroupTile({this.userName, @required this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  _getrecentchatandmessage();
        Navigator.push(
            context,
            SlideRightRoute(
                page: ChatPage(
              groupId: groupId,
              userName: userName,
              groupName: groupName,
            )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: aboutGroupMember(
                    groupID: groupId,
                    groupName: groupName,
                  )));
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2)),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/logos/okay.jpg'),
              ),
            ),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join th conversation as $userName",
              style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}
