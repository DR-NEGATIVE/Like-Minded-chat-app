import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }

  // create group
  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });
  }

  // toggling the user group join
  Future togglingGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot.data()['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }

  // has user joined the group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data()['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('userEmail', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    // return await Firestore.instance
    //     .collection("users")
    //     .where('userEmail', isEqualTo: 'war@gmail.com')
    //     .snapshots();
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }

  // send message
  sendMessage(String groupId, chatMessageData) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getChats(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  getGroupdeatails(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('groupId', isEqualTo: groupId)
        .get();
  }
}
