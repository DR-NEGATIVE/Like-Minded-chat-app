import 'package:flutter/material.dart';
import 'package:lm_login/Sign_Up.dart';
import './main_of_login.dart';
import './About_us.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lm_login/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lm_login/helper/auth.dart';
import 'package:lm_login/helper/helperfunctions.dart';
import 'sidebar/sidebar_layout.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Authenticate()));
}*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Like Minded',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFF478DE0),
          accentColor: Colors.black54,
          fontFamily: 'OpenSans',
          textTheme: TextTheme(
              headline1: TextStyle(fontSize: 80, color: Colors.black54),
              headline2: TextStyle(fontSize: 80, color: Colors.white))),
      darkTheme:
          ThemeData(brightness: Brightness.dark, accentColor: Colors.white70),

      //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),
      home: _isLoggedIn ? SideBarLayout() : Authenticate(),
      //home: HomePage(),
    );
  }
}
