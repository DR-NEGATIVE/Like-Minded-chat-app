import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lm_login/helper/helperfunctions.dart';
import 'package:lm_login/helper/auth.dart';
//import 'package:group_chat_app/pages/chat_page.dart';
//import 'package:group_chat_app/pages/search_page.dart';
import 'package:lm_login/group_stuff/auth_services.dart';
import 'package:lm_login/database.dart';
import 'package:lm_login/group_stuff/database2.dart';
import 'package:lm_login/group_stuff/group_title.dart';
import 'package:lm_login/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:lm_login/services.dart';
import 'package:lm_login/group_stuff/search_grouporiginal.dart';

class MyOrdersPage extends StatefulWidget with NavigationStates {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyOrdersPage> {
  // data
  final AuthMethods _auth = AuthMethods();
  User _user;
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;

  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    _value();
  }

  // widgets
  _value() async {
    _user = await FirebaseAuth.instance.currentUser;
  }

  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            SizedBox(height: 20.0),
            Text(
                "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        ));
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            print("pahseclear");
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        userName: snapshot.data['userName'],
                        groupId:
                            _destructureId(snapshot.data['groups'][reqIndex]),
                        groupName: _destructureName(
                            snapshot.data['groups'][reqIndex]));
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // functions
  _getUserAuthAndJoinedGroups() async {
    // _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        print(value);
        _email = value;
      });
    });
    //'6Pt8Xy68k6uClDs7upxi'
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      setState(() {
        _groups = snapshots;
      });
    });
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _customAppbar4() {
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
                  backgroundImage: AssetImage('assets/logos/element.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18),
                child: Text(
                  'GROUPS',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 25, left: 20, right: 15, bottom: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 2)),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://pbs.twimg.com/media/CHd03RhUcAAGSh_.jpg'),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 25, left: 10, right: 20, bottom: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40),
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

  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppbar4(),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.symmetric(vertical: 50.0),
      //     children: <Widget>[
      //       Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
      //       SizedBox(height: 15.0),
      //       Text(_userName,
      //           textAlign: TextAlign.center,
      //           style: TextStyle(fontWeight: FontWeight.bold)),
      //       SizedBox(height: 7.0),
      //       ListTile(
      //         onTap: () {},
      //         selected: true,
      //         contentPadding:
      //             EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      //         leading: Icon(Icons.group),
      //         title: Text('Groups'),
      //       ),
      //       ListTile(
      //         onTap: () {
      //           // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //           //   builder: (context) =>
      //           //   ProfilePage(userName: _userName, email: _email)));
      //         },
      //         contentPadding:
      //             EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      //         leading: Icon(Icons.account_circle),
      //         title: Text('Profile'),
      //       ),
      //       ListTile(
      //         onTap: () async {
      //           // await _auth.signOut();
      //           //Navigator.of(context).pushAndRemoveUntil(
      //           //  MaterialPageRoute(builder: (context) => AuthenticatePage()),
      //           //(Route<dynamic> route) => false);
      //         },
      //         contentPadding:
      //             EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      //         leading: Icon(Icons.exit_to_app, color: Colors.red),
      //         title: Text('Log Out', style: TextStyle(color: Colors.red)),
      //       ),
      //     ],
      //   ),
      // ),
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }
}
