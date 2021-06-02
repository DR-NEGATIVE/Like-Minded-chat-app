import 'package:flutter/material.dart';

class MessageTiles extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  MessageTiles({this.message, this.sender, this.sentByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: sentByMe ? 0 : 24, right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          gradient: LinearGradient(
            colors: sentByMe
                ? [const Color(0xff424242), const Color(0xff212121)]
                : [const Color(0xff6A1B9A), const Color(0xff4A148C)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender.toUpperCase(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5)),
            SizedBox(height: 7.0),
            Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
