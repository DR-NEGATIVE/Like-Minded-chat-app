import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './bloc.navigation_bloc/navigation_bloc.dart';

class About_Us extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _about_us();
  }
}

class _about_us extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Shader lock = LinearGradient(colors: [
      Color(0xFF9E7501),
      Colors.amber,
      Colors.redAccent,
      Color(0xFF0F0755)
    ]).createShader(Rect.fromLTWH(60, 50.0, 200.0, 10.0));
    return Container(
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
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  Avtar('assets/logos/SEA.png'),
                  SizedBox(height: 15),
                  Text(
                    'Vinay Kumar(Sharma)',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Dr | Dev ? Negative : ojhastar01',
                    style: TextStyle(
                        fontSize: 20,
                        foreground: new Paint()..shader = lock,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Front-End,Back-End ,UI Design',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hahabutton(
                        icon: FontAwesomeIcons.github,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      hahabutton(icon: FontAwesomeIcons.hackerrank),
                      SizedBox(
                        width: 25,
                      ),
                      hahabutton(icon: FontAwesomeIcons.linkedin)
                    ],
                  )
                ],
              ),
            ),
            // Divider(
            //   height: 64,
            //   color: Colors.white,
            //   thickness: 1,
            //   endIndent: 15,
            //   indent: 15,
            // ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  // Avtar('assets/logos/rachit.jpg'),
                  // SizedBox(height: 15),
                  // Text(
                  //   'Rachit',
                  //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  // ),
                  // Text(
                  //   'Sec-C 181500523',
                  //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                  // ),
                  // SizedBox(height: 15),
                  // Text(
                  //   'Front-End',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  // SizedBox(
                  //   height: 35,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     hahabutton(
                  //       icon: FontAwesomeIcons.github,
                  //     ),
                  //     SizedBox(
                  //       width: 25,
                  //     ),
                  //     hahabutton(icon: FontAwesomeIcons.hackerrank),
                  //     SizedBox(
                  //       width: 25,
                  //     ),
                  //     hahabutton(icon: FontAwesomeIcons.linkedin)
                  //   ],
                  // ),
                  // Divider(
                  //   height: 64,
                  //   color: Colors.white,
                  //   thickness: 1,
                  //   endIndent: 15,
                  //   indent: 15,
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   margin: EdgeInsets.only(top: 20, bottom: 20),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Avtar('assets/logos/kan.jpg'),
                  //       SizedBox(height: 15),
                  //       Text(
                  //         'Kanhaiya Sharma',
                  //         style: TextStyle(
                  //             fontSize: 30, fontWeight: FontWeight.w700),
                  //       ),
                  //       Text(
                  //         'Sec-G 181500306',
                  //         style: TextStyle(
                  //             fontSize: 30, fontWeight: FontWeight.w200),
                  //       ),
                  //       SizedBox(height: 15),
                  //       Text(
                  //         'Back-End Work',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //       SizedBox(
                  //         height: 35,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           hahabutton(
                  //             icon: FontAwesomeIcons.github,
                  //           ),
                  //           SizedBox(
                  //             width: 25,
                  //           ),
                  //           hahabutton(icon: FontAwesomeIcons.hackerrank),
                  //           SizedBox(
                  //             width: 25,
                  //           ),
                  //           hahabutton(icon: FontAwesomeIcons.linkedin)
                  //         ],
                  //       ),
                  //       Divider(
                  //         height: 64,
                  //         color: Colors.white,
                  //         thickness: 1,
                  //         endIndent: 15,
                  //         indent: 15,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   margin: EdgeInsets.only(top: 20, bottom: 20),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Avtar('assets/logos/ayush.jpg'),
                  //       SizedBox(height: 15),
                  //       Text(
                  //         'Ayush Pathak',
                  //         style: TextStyle(
                  //             fontSize: 30, fontWeight: FontWeight.w700),
                  //       ),
                  //       Text(
                  //         'Sec-F 181500176',
                  //         style: TextStyle(
                  //             fontSize: 30, fontWeight: FontWeight.w200),
                  //       ),
                  //       SizedBox(height: 15),
                  //       Text(
                  //         'Front-End Work',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //       SizedBox(
                  //         height: 35,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           hahabutton(
                  //             icon: FontAwesomeIcons.github,
                  //           ),
                  //           SizedBox(
                  //             width: 25,
                  //           ),
                  //           hahabutton(icon: FontAwesomeIcons.hackerrank),
                  //           SizedBox(
                  //             width: 25,
                  //           ),
                  //           hahabutton(icon: FontAwesomeIcons.linkedin)
                  //         ],
                  //       ),
                  //       Divider(
                  //         height: 64,
                  //         color: Colors.white,
                  //         thickness: 1,
                  //         endIndent: 15,
                  //         indent: 15,
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
          ],
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
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(add))),
        ),
      ),
    );
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
}

class hahabutton extends StatelessWidget {
  final IconData icon;

  hahabutton({this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
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
        ],
      ),
      child: Icon(
        icon,
        color: Colors.grey.shade600,
      ),
    );
  }
}

class about extends StatelessWidget {
  final String Name;
  final String wname;
  final String work;
  about({this.Name, this.wname, this.work});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
