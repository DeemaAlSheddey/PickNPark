import 'package:cloud_firestore/cloud_firestore.dart';

///User model class
class User {
  late String id, name, email, dateOfBirth, phoneNumber;
  late int walletBalance;

  User({this.id = "", required this.name, required this.email,
    required this.dateOfBirth, required this.phoneNumber, this.walletBalance = 0});

  User.empty(){
    id =  '';
    name = '';
    email = '';
    dateOfBirth = '';
    phoneNumber = '';
    walletBalance = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "dateOfBirth": dateOfBirth,
      "phoneNumber": phoneNumber,
      "walletBalance": walletBalance,
    };
  }

  User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get("id") as String;
    name = snapshot.get('name') as String;
    email = snapshot.get('email') as String;
    dateOfBirth = snapshot.get('dateOfBirth') as String;
    phoneNumber = snapshot.get('phoneNumber') as String;
    walletBalance = (snapshot.get('walletBalance') as num).toInt();
  }
}
