import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lm_login/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constant.dart';
import 'package:flutter/services.dart';
import './Sign_Up.dart';
import './homepage.dart';
import './services.dart';
import './About_us.dart';
import './database.dart';
import 'package:lm_login/group_stuff/auth_services.dart';
import 'package:lm_login/helper/helperfunctions.dart';
import 'sidebar/sidebar_layout.dart';
//import 'package:lm_login/group_stuff/database2.dart';

class Sign_up extends StatefulWidget {
  final Function toggleView;
  Sign_up(this.toggleView);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Sign();
  }
}

class Sign extends State<Sign_up> {
  @override
  bool _loading = false;
  User _user;
  TextEditingController _firstname = new TextEditingController();
  TextEditingController _lastname = new TextEditingController();
  TextEditingController _emailUser = new TextEditingController();
  TextEditingController _userpassword = new TextEditingController();
  String _userImage =
      "https://www.clickz.com/wp-content/uploads/2016/03/anontumblr-300x271.png";
  AuthMethods authMethods = new AuthMethods();
  AuthService _auth = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final valkey = GlobalKey<FormState>();
  Signup() async {
    if (valkey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      await authMethods
          .signUpWithEmailAndPassword(_emailUser.text, _userpassword.text)
          .then(
        (result) async {
          _user = await FirebaseAuth.instance.currentUser;
          if (result != null) {
            Map<String, dynamic> userDataMap = {
              "userName": _firstname.text.replaceAll(" ", "") +
                  ' ' +
                  _lastname.text.replaceAll(" ", ""),
              "userEmail": _emailUser.text,
              //custom
              "userImage": _userImage,
              "groups": [],
              "about": " Hey I'm On LM"
              //custom
            };

            databaseMethods.addUserInfo(userDataMap, _user.uid);
            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserNameSharedPreference(
                _firstname.text + ' ' + _lastname.text);
            await HelperFunctions.saveUserEmailSharedPreference(
                _emailUser.text);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SideBarLayout()));
          }
        },
      );
      Fluttertoast.showToast(
          msg: " Account Created Sucessfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 14.0);
    }
  }

  Widget First_name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 8.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _firstname,
            validator: (val) {
              return val.replaceAll(" ", "") != ""
                  ? null
                  : 'this field Cant be Empty';
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Enter your First Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget Password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _userpassword,
            validator: (val) {
              return val.length > 6 ? null : 'Password length should >6';
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Create New Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget Last_name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 8.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _lastname,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              hintText: 'Enter your Last Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget Email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _emailUser,
            validator: (value) {
              return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+")
                      .hasMatch(value)
                  ? null
                  : "please Provide Valid email";
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget Create_Btn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => Signup(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: (_loading)
            ? Center(
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              )
            : Form(
                key: valkey,
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF73AEF5),
                              Color(0xFF61A4F1),
                              Color(0xFF478DE0),
                              Color(0xFF398AE5),
                            ],
                            stops: [0.1, 0.4, 0.7, 0.9],
                          ),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 120.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              First_name(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Last_name(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Email(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Password(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Create_Btn(),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ));
  }
}
