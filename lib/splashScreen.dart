import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Theme.of(context).primaryColor,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: [
      //       Color(0xFF73AEF5),
      //       Color(0xFF61A4F1),
      //       Color(0xFF478DE0),
      //       Color(0xFF398AE5),
      //     ],
      //     stops: [0.1, 0.4, 0.7, 0.9],
      //   ),
      // ),
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 85,
                ),
                avtarImage(),
                SizedBox(
                  height: 65,
                ),
                Text(
                  ' LIKE MINDED ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 1.5,
                      decoration: TextDecoration.none,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 180,
                ),
                Container(
                  height: 70,
                  width: 70,
                  child: Image(
                    image: AssetImage('assets/logos/workingdbs.gif'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  avtarImage() {
    return Container(
      width: 150,
      height: 150,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(8),
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
          ]),
      child: Container(
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
            ]),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
                  DecorationImage(image: AssetImage('assets/logos/logo.jpg'))),
        ),
      ),
    );
  }
}
