import 'package:cloud_firestore/cloud_firestore.dart';

///Reservation model class

class Reservation {
  late String id,     ///ID of the reservation (auto-generated)
      userId,         ///ID of user that made the reservation
      event, zone, carLicense;
  late Timestamp date;
  late bool status;
  late int parkingId, resId;

  Reservation({this.id = "", required this.userId, required this.date,
    required this.event, required this.status, required this.zone, required this.carLicense,
    required this.parkingId, required this.resId});

  Reservation.empty(){
    id =  '';
    userId = '';
    date =  Timestamp.now();
    event = '';
    zone =  '';
    carLicense =  '';
    status = false;
    parkingId = 0;
    resId = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "date": date,
      "event": event,
      "zone": zone,
      "carLicense": carLicense,
      "status": status,
      "parkingId": parkingId,
      "resId": resId,
    };
  }

  Reservation.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get("id") as String;
    userId = snapshot.get('userId') as String;
    date = snapshot.get('date') as Timestamp;
    event = snapshot.get('event') as String;
    zone = snapshot.get('zone') as String;
    carLicense = snapshot.get('carLicense') as String;
    status = snapshot.get('status') as bool;
    parkingId = (snapshot.get('parkingId') as num).toInt();
    resId = (snapshot.get('resId') as num).toInt();
  }
}
