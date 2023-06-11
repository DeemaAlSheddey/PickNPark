import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/services/services.dart';

import 'package:picknpark/services/database/default.dart';

class ReservationDatabase{

  final String reservationId;
  const ReservationDatabase({this.reservationId = ""});

  static CollectionReference reservationsCollection = FirebaseFirestore.instance.collection('reservations');

  Future<String> createReservation(Map<String, dynamic> reservation) async{
    try {
      final result = await reservationsCollection.add(reservation);

      await updateReservationDetails({"id" : result.id});

      return result.id;
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
      return "";
    }
  }

  Future<void> updateReservationDetails(Map<String, dynamic> values) async{
    try {
      await reservationsCollection.doc(values["id"]).update(values);
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
    }
  }

  Future<Reservation?> getReservation(String reservationID) async {
    try {
      final result = await reservationsCollection.where("id", isEqualTo: reservationID).get();
      if(result.docs.isNotEmpty){
        for (QueryDocumentSnapshot documentSnapshot in result.docs) {
          return Reservation.fromDocumentSnapshot(documentSnapshot);
        }
      }
      return null;
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
      return null;
    }
  }

  Stream<Reservation> get reservation {
    return reservationsCollection.where("id", isEqualTo: reservationId).snapshots().map((querySnapshot) {
      Reservation reservation = Reservation.empty();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        reservation = Reservation.fromDocumentSnapshot(documentSnapshot);
        break;
      }
      return reservation;
    });
  }

  Stream<List<Reservation>> get reservations {
    return reservationsCollection.where("userId", isEqualTo: Auth().uID).snapshots().map((querySnapshot) {
      List<Reservation> reservations = [];
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        reservations.add(Reservation.fromDocumentSnapshot(documentSnapshot));
      }
      return reservations;
    });
  }

  Future<void> deleteReservation (String reservationId) async {
    await reservationsCollection.doc(reservationId).delete();
  }
}