import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static String _secretKey = "";
  static String _publishableKey = "";

  Future<void> initialize() async {
    final snap = await FirebaseFirestore.instance
        .collection('appData').doc('stripe').get();

    Stripe.publishableKey = snap.data()?['publishableKey'] ?? "";
    _publishableKey = snap.data()?['publishableKey'] ?? "";
    _secretKey = snap.data()?['secretKey'] ?? "";
  }

  Future<String> get secretKey async {
    if(_secretKey.isEmpty){
      final snap = await FirebaseFirestore.instance
          .collection('appData').doc('stripe').get();

      _secretKey = snap.data()?['secretKey'] ?? "";
    }

    return _secretKey;
  }

  Future<String> get publishableKey async {
    if(_publishableKey.isEmpty){
      final snap = await FirebaseFirestore.instance
          .collection('appData').doc('stripe').get();

      Stripe.publishableKey = snap.data()?['publishableKey'] ?? "";
      _publishableKey = snap.data()?['publishableKey'] ?? "";
    }

    return Stripe.publishableKey;
  }
}