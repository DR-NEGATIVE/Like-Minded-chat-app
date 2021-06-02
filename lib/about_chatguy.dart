import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class chatGuy extends StatelessWidget {
  final String name;
  final String image;
  final String about;
  final String email;
  chatGuy({this.name, this.image, this.about, this.email});
  @override
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
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                Avtar(image),
                SizedBox(height: 15),
                Text(
                  'Name :' + " " + name,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 24,
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
                  "About Me : " + about,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 35,
                )
              ],
            ),
          ),
        ],
      ),
    );
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
              child: CachedNetworkImage(
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
                placeholder: (context, url) => CircularProgressIndicator(),
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
