import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:picknpark/models/models.dart' as models;
import 'package:picknpark/services/authentication.dart';

import 'package:picknpark/services/database/default.dart';

class UserDatabase{
  String uID;

  UserDatabase({this.uID = ""}){
    if(uID == ""){
      uID = Auth().uID;
    }
  }

  static CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(Map<String, dynamic> values) async {
    try {
      await usersCollection.doc(uID).set(values);

    } on FirebaseAuthException catch (e) {
      Default.showDatabaseError(e);
    }
  }

  Future<void> updateUserDetails(Map<String, dynamic> values) async {
    try {
      await usersCollection.doc(values["id"]).update(values);
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
    }
  }

  Stream<models.User> get user {
    if(uID.isNotEmpty) {
      return usersCollection.doc(uID).snapshots().map((documentSnapshot) {
        return models.User.fromDocumentSnapshot(documentSnapshot);
      });
    }else{
      return const Stream<models.User>.empty();
    }
  }

  Future<models.User?> getUser (String id) async {
    try {
      final result = await usersCollection.where("id", isEqualTo: id).get();
      if(result.docs.isNotEmpty){
        for (QueryDocumentSnapshot documentSnapshot in result.docs) {
          return models.User.fromDocumentSnapshot(documentSnapshot);
        }
      }
      return null;
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
      return null;
    }
  }
}