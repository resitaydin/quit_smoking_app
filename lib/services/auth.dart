import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginui/models/user.dart';
import 'package:loginui/services/database.dart';
//import 'package:loginui/services/database.dart';

class AuthService {
  // create auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool isSignUp = false;

  // create MyUser object based off firebase User object
  MyUser? _myUserFromUser(User? user) {
    // if User is not null return MyUser, otherwise return null
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // stream for if the users auth changes
  // mapping to get stream of MyUsers instead
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _myUserFromUser(user));
  }

  // sign-in with email/password
  Future signInWithEmailAndPassword(String email, String password) async {
    // try to register with firebase
    try {
      // get response from firebase
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // return converted MyUser

      User? user = result.user;
      return _myUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      // return messages depending on which
      switch (e.code.toString()) {
        case 'disabled-user':
          return 'Email corresponds to a disabled user';
        case 'invalid-credential':
          return 'The account does not exist or the password is wrong';
        case 'invalid-email':
          return 'Invalid email address';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return null;
    }
  }

  // register with email/password
  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    // try to register with firebase
    try {
      // get response from firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create a new doc for this user using the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData(0, 0, email, "", 0, 0, username);
      // return converted MyUser
      return _myUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      // return messages depending on which
      switch (e.code.toString()) {
        case 'invalid-email':
          return 'Please enter a valid email';
        case 'email-already-in-use':
          return 'User already found with this email';
        case 'weak-password':
          return 'Please use a stronger password';
        case 'operation-not-allowed':
          return 'Email password authentication disabled';
      }
    } catch (e) {
      return null;
    }
  }

  // sign-out
  Future signOut() async {
    // try sign out using firebase
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
