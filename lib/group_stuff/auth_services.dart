import 'package:firebase_auth/firebase_auth.dart';
import 'package:lm_login/helper/helperfunctions.dart';
import 'package:lm_login/modal/user.dart';
import 'package:lm_login/group_stuff/database2.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User_a _userFromFirebaseUser(User user) {
    return (user != null) ? User_a(userId: user.uid) : null;
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User result = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return _userFromFirebaseUser(result);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User result = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      // Create a new document for the user with uid
      await DatabaseService(uid: result.uid)
          .updateUserData(fullName, email, password);
      return _userFromFirebaseUser(result);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');

      return await _auth.signOut().whenComplete(() async {
        print("Logged out");
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          print("Logged in: $value");
        });
        await HelperFunctions.getUserEmailSharedPreference().then((value) {
          print("Email: $value");
        });
        await HelperFunctions.getUserNameSharedPreference().then((value) {
          print("Full Name: $value");
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
