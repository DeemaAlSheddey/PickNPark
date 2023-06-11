import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/services/services.dart';

import 'package:picknpark/services/database/default.dart';

class ParkingDatabase{

  final String parkingId;
  const ParkingDatabase({this.parkingId = ""});

  static CollectionReference parkingsCollection = FirebaseFirestore.instance.collection('parkings');

  Future<void> createParking(Map<String, dynamic> parking) async{
    try {
      await parkingsCollection.doc(parking['id']).set(parking);
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
    }
  }

  Future<void> updateParkingDetails(Map<String, dynamic> values) async{
    try {
      await parkingsCollection.doc(values["id"]).update(values);
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
    }
  }

  Future<Parking?> getParking(String parkingID) async {
    try {
      final result = await parkingsCollection.where("id", isEqualTo: parkingID).get();
      if(result.docs.isNotEmpty){
        for (QueryDocumentSnapshot documentSnapshot in result.docs) {
          return Parking.fromDocumentSnapshot(documentSnapshot);
        }
      }
      return null;
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
      return null;
    }
  }

  Stream<Parking> get parking {
    return parkingsCollection.where("id", isEqualTo: parkingId).snapshots().map((querySnapshot) {
      Parking parking = Parking.empty();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        parking = Parking.fromDocumentSnapshot(documentSnapshot);
        break;
      }
      return parking;
    });
  }

  Stream<List<Parking>> get parkings {
    return parkingsCollection.where("userId", isEqualTo: Auth().uID).snapshots().map((querySnapshot) {
      List<Parking> parkings = [];
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        parkings.add(Parking.fromDocumentSnapshot(documentSnapshot));
      }
      return parkings;
    });
  }
}