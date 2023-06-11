import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static String errorMessage = "";

  bool get isSignedIn {
    if (_auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  String get uID {
    if(isSignedIn){
      return _auth.currentUser!.uid;
    }else {
      return "";
    }
  }

  void authFailed(){
    if (kDebugMode) {
      print(errorMessage.toString());
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString().split('] ')[1];
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on Exception catch (e) {
      errorMessage = e.toString().split('] ')[1];
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<bool> resetPassword(String emailAddress) async  {
    try {
      await _auth.sendPasswordResetEmail(email: emailAddress);
      return true;
    } on Exception catch (e) {
      errorMessage = e.toString().split('] ')[1];
      authFailed();
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
