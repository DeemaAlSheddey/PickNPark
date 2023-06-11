import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/services/services.dart';

import 'package:picknpark/services/database/default.dart';

class CarDatabase{

  final String carId;
  const CarDatabase({this.carId = ""});

  static CollectionReference carsCollection = FirebaseFirestore.instance.collection('cars');

  Future<String> createCar(Map<String, dynamic> car) async{
    try {
      final result = await carsCollection.add(car);

      await updateCarDetails({"id" : result.id});

      return result.id;
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
      return "";
    }
  }

  Future<void> updateCarDetails(Map<String, dynamic> values) async{
    try {
      await carsCollection.doc(values["id"]).update(values);
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
    }
  }

  Future<Car?> getCar(String carID) async {
    try {
      final result = await carsCollection.where("id", isEqualTo: carID).get();
      if(result.docs.isNotEmpty){
        for (QueryDocumentSnapshot documentSnapshot in result.docs) {
          return Car.fromDocumentSnapshot(documentSnapshot);
        }
      }
      return null;
    } on FirebaseException catch (e) {
      Default.showDatabaseError(e);
      return null;
    }
  }

  Stream<Car> get car {
    return carsCollection.where("id", isEqualTo: carId).snapshots().map((querySnapshot) {
      Car car = Car.empty();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        car = Car.fromDocumentSnapshot(documentSnapshot);
        break;
      }
      return car;
    });
  }

  Stream<List<Car>> get cars {
    return carsCollection.where("userId", isEqualTo: Auth().uID).snapshots().map((querySnapshot) {
      List<Car> cars = [];
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        cars.add(Car.fromDocumentSnapshot(documentSnapshot));
      }
      return cars;
    });
  }

  Future<List<Car>> getCars () async {
    final snapshot = await carsCollection.where("userId", isEqualTo: Auth().uID).get();

    List<Car> cars = [];
    for (QueryDocumentSnapshot documentSnapshot in snapshot.docs) {
      cars.add(Car.fromDocumentSnapshot(documentSnapshot));
    }

    return cars;
  }
}