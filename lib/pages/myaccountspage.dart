import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:lm_login/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lm_login/helper/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountsPage extends StatefulWidget with NavigationStates {
  @override
  final String Name;
  MyAccountsPage({this.Name});
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _myAccountPage(name: Name);
  }
}

class _myAccountPage extends State<MyAccountsPage> {
  @override
  File file;
  bool dataofstate = true;
  PickedFile _image;
  String name = "Loading..";
  String email = "Loading..";
  String about = "Loading..";
  String token = "";
  String image =
      'https://www.clickz.com/wp-content/uploads/2016/03/anontumblr-300x271.png';
  final _picker = ImagePicker();
  _myAccountPage({this.name});
  // _gettokenforuser() async {
  //   token = await FirebaseAuth.instance.currentUser.uid;
  // }
  TextEditingController aboutme = new TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;

  _getdetails() async {
    token = await FirebaseAuth.instance.currentUser.uid;
    print(token + "okkk");
    await DatabaseMethods().getUserDetailsbytoken(token).then((snap) {
      setState(() {
        print(snap.toString() + "kkk");
        name = snap.data()['userName'];
        email = snap.data()['userEmail'];
        about = snap.data()['about'];
        image = snap.data()['userImage'];
      });
    });
  }

  _updatedata() async {
    setState(() {
      dataofstate = false;
    });
    if (file == null && aboutme.text != "") {
      return helperofupdate('');
    }
    Reference reference = _storage.ref().child('/userProfile+$email');
    //StorageUploadTask uploadTask
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String location = await taskSnapshot.ref.getDownloadURL();
    return helperofupdate(location);
  }

  var blockofimage;
  _getuserimage() async {
    _image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      blockofimage = _image;
      file = File(_image.path);
    });
    print(file);
    Fluttertoast.showToast(
        msg: "Image is Selected Press Update to Update",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 10.0);
  }

  helperofupdate(String link) {
    if (aboutme.text != "" && file != null) {
      FirebaseFirestore.instance.collection('users').doc(token).update({
        'about': aboutme.text,
        'userImage': link,
      });
      setState(() {
        image = link;
        about = aboutme.text;
        dataofstate = true;
      });
    } else if (file == null && aboutme.text != "") {
      FirebaseFirestore.instance.collection('users').doc(token).update({
        'about': aboutme.text,
      });
      setState(() {
        about = aboutme.text;
        dataofstate = true;
      });
    } else if (file != null && aboutme.text == "") {
      FirebaseFirestore.instance.collection('users').doc(token).update({
        'userImage': link,
      });
      setState(() {
        image = link;
        file = null;
        dataofstate = true;
      });
    }
    Fluttertoast.showToast(
        msg: "Profile Updated Sucessfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 14.0);
  }

  void initState() {
    super.initState();
    //_gettokenforuser();
    _getdetails();
  }

  BoxDecoration hahayes =
      BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.075),
      offset: Offset(8, 8),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Colors.white,
      //offset: Offset(-3, -3),
      blurRadius: 8,
    )
  ]);
  Widget build(BuildContext context) {
    // TODO: implement build
    return (dataofstate)
        ? Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          print('hello');
                          _getuserimage();
                        },
                        child: Avtar(image),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Name :' + " " + name,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 64,
                        color: Colors.white,
                        thickness: 1,
                        endIndent: 15,
                        indent: 15,
                      ),
                      Text(
                        'Email :' + " " + email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 64,
                        color: Colors.white,
                        thickness: 1,
                        endIndent: 15,
                        indent: 15,
                      ),
                      Text(
                        'About me :' + " " + about,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 64,
                        color: Colors.white,
                        thickness: 1,
                        endIndent: 15,
                        indent: 15,
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: aboutme,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            hintText: 'Enter About me..',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _updatedata();
                        },
                        child: Container(
                          margin: EdgeInsets.all(25),
                          height: 50,
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'UPDATE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.075),
                                  offset: Offset(8, 8),
                                  blurRadius: 8,
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ));
  }

  Avtar(String add) {
    return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(8),
        decoration: hahayes,
        child: Container(
            decoration: hahayes,
            padding: EdgeInsets.all(3),
            child: Container(
              child: blockofimage != null
                  ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(file), fit: BoxFit.cover)))
                  : CachedNetworkImage(
                      imageUrl: add,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         image: DecorationImage(image: NetworkImage(),
              //   ),
              // ),
            )));
  }
}
