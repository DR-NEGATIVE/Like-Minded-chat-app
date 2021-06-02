import 'dart:ui';

import 'package:flutter/material.dart';
import './database2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../about_chatguy.dart';

class aboutGroupMember extends StatefulWidget {
  @override
  String groupID;
  String groupName;
  aboutGroupMember({this.groupID, this.groupName});
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _aboutGroupMember(groupID: groupID, groupName: groupName);
  }
}

class _aboutGroupMember extends State<aboutGroupMember> {
  @override
  String groupID;
  var mytime;
  String groupName;
  String backendsucks = "";
  String members = " lower ";
  List<Widget> users = new List<Widget>();
  var snapshot;
  void giveMeDetailsFirst() async {
    print("downward");
    await DatabaseService().getGroupdeatails(groupID).then((value) {
      setState(() {
        snapshot = value;
      });
    });
  }

  List adddata() {
    //for (int i = 0; i < 2; i++) {
    try {
      mytime = snapshot.docs[0].data()['members'];
      print(mytime);
      for (int i = 0; i < mytime.length; i++) {
        users.add(userInfoTile(
          nameOfUser: mytime[i].toString().split("_")[1],
        ));
      }
    } catch (e) {
      users.add(userInfoTile(
        nameOfUser: "NO DATA FOUND",
      ));
    }
    //  setState(() {
    //   backendsucks = snapshot.docs[0].data()['members'].toString();
    //   backendsucks = backendsucks.replaceAll('[', "");
    //   backendsucks = backendsucks.replaceAll(']', "");
    //   print(backendsucks);
    //   mytime = backendsucks.split(",");
    //   print(mytime[1]);
    // });
    // users.add(userInfoTile(nameOfUser: mytime[1].toString()));
    return users;
  }

  _aboutGroupMember({this.groupID, this.groupName});
  void initState() {
    giveMeDetailsFirst();

    super.initState();
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
                  widget.groupName + " Members",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(50));
  }

  Widget build(BuildContext context) {
    return snapshot != null
        ? Scaffold(
            appBar: _customAppbar12(),
            body: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: adddata(),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
    // TODO: implement build
  }
}

class userInfoTile extends StatelessWidget {
  String nameOfUser;
  userInfoTile({this.nameOfUser});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Container(
        child: Row(
          children: [
            Container(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/logos/okay.jpg'),
                backgroundColor: Theme.of(context).accentColor,
                radius: 30,
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2)),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Text(
                nameOfUser,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 20,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }
}
