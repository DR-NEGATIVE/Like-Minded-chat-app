import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lm_login/helper/helperfunctions.dart';
import 'package:lm_login/group_stuff/chat_page.dart';
import 'package:lm_login/group_stuff/database2.dart';
import 'package:lm_login/bloc.navigation_bloc/navigation_bloc.dart';

class SearchPage extends StatefulWidget with NavigationStates {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // data
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  User _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // initState()
  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUid();
  }

  // functions
  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = await FirebaseAuth.instance.currentUser;
  }

  _initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.blueAccent,
      duration: Duration(milliseconds: 1500),
      content: Text(message,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
    ));
  }

  _joinValueInGroup(
      String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid)
        .isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  // widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return groupTile(
                _userName,
                searchResultSnapshot.documents[index].data()["groupId"],
                searchResultSnapshot.documents[index].data()["groupName"],
                searchResultSnapshot.documents[index].data()["admin"],
              );
            })
        : Container();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    _joinValueInGroup(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage('assets/logos/okay.jpg'),
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Admin: $admin"),
      trailing: InkWell(
        onTap: () async {
          //updated
          await DatabaseService(uid: _user.uid)
              .togglingGroupJoin(groupId, groupName, userName);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
            _showScaffold('Successfully joined the group "$groupName"');
            Future.delayed(Duration(milliseconds: 2000), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(
                      groupId: groupId,
                      userName: userName,
                      groupName: groupName)));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showScaffold('Left the group "$groupName"');
          }
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black87,
                    border: Border.all(color: Colors.white, width: 1.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Joined', style: TextStyle(color: Colors.white)),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueAccent,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Join', style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  _customAppbar_sg() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).accentColor, width: 3)),
          color: Theme.of(context).primaryColor,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 35),
          child: Text(
            'Search Groups',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontFamily: 'Raleway'),
          ),
        ),
      ),
    );
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _customAppbar_sg(),
      body: // isLoading ? Container(
          //   child: Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // )
          // :
          Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, left: 15, bottom: 15, right: 15),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).primaryColor,
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
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          hintText: "Search groups...",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: Icon(Icons.search, color: Colors.white)))
                ],
              ),
            ),
            isLoading
                ? Container(child: Center(child: CircularProgressIndicator()))
                : groupList()
          ],
        ),
      ),
    );
  }
}
