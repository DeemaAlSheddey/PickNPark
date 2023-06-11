import 'package:cloud_firestore/cloud_firestore.dart';

///Car model class
class Car {
  late String id,     ///ID of the car itself (auto-generated)
      userId,         ///ID of user that created the car
      type,
      license;

  Car({this.id = "", required this.userId, required this.type, required this.license});

  Car.empty(){
    id =  '';
    userId = '';
    type = '';
    license = '';
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "name": type,
      "license": license,
    };
  }

  Car.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get("id") as String;
    userId = snapshot.get('userId') as String;
    type = snapshot.get('name') as String;
    license = snapshot.get('license') as String;
  }
}
