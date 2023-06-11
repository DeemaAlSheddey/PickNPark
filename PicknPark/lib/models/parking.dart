import 'package:cloud_firestore/cloud_firestore.dart';

///Parking model class
class Parking {
  late String id,     ///ID of the parking
      userId,         ///ID of user that made the parking
      date, event, status, zone;
  late int parkingId, price;

  Parking({this.id = "", required this.userId, required this.date,
    required this.event, required this.status, required this.zone,
    required this.parkingId, required this.price});

  Parking.empty(){
    id =  '';
    userId = '';
    date =  '';
    event = '';
    status = '';
    zone =  '';
    parkingId = 0;
    price = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "date": date,
      "event": event,
      "status": status,
      "zone": zone,
      "parkingId": parkingId,
      "price": price,
    };
  }

  Parking.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get("id") as String;
    userId = snapshot.get('userId') as String;
    date = snapshot.get('date') as String;
    event = snapshot.get('event') as String;
    status = snapshot.get('status') as String;
    zone = snapshot.get('zone') as String;
    parkingId = (snapshot.get('parkingId') as num).toInt();
    price = (snapshot.get('price') as num).toInt();
  }
}
