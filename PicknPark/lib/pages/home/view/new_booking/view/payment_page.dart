import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/controllers/controllers.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/app.dart';
import 'package:picknpark/pages/main_drawer/main_drawer.dart';
import 'package:picknpark/pages/reservations/reservations.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';

class PaymentPage extends StatefulWidget {

  final DateTime date;
  final String event;
  final int parkingSlot;
  final String zone;
  final int price;
  final String carLicense;
  const PaymentPage({Key? key, required this.date, required this.event,
    required this.parkingSlot, required this.zone, required this.price,
    required this.carLicense}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  late int reservationId;
  String paymentMethod = "wallet";

  @override
  void initState() {
    reservationId = generateRandomIntWithFiveDigits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         
        title:
          const Text(
            "الدفع",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 30
            )
          ),
          backgroundColor: CustomColors.primaryColor ,
          toolbarHeight: 140,
          actions: [
            Container(
              width: 110,
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Image.asset(
                'Assets/pay.png',
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 40),
        
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Center(
                          child: Text(
                            "الدفع",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: CustomColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          textAlign: TextAlign.end,
                          ),
                        ),
        
                        const SizedBox(height: 10),
        
                        GetX<UserController>(
                          builder: (controller) {
                            return _paymentMethod(
                              icon: Image.asset(
                                  "Assets/wallet.png",
                                  width: 20
                              ),
                              title: "المحفظة الإلكترونية",
                              trailing: "﷼${controller.user.value.walletBalance}",
                              value: 'wallet',
                              selectedValue: paymentMethod,
                            );
                          }
                        ),
        
                        Container(
                          alignment: Alignment.bottomLeft,
                          child:TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FundWallet()),
                              );
                            },
                            child: const Text(
                              'المحقظة',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
        
                        _paymentMethod(
                          icon: const Icon(
                            Icons.credit_card_outlined,
                            size: 20,
                            color: CustomColors.primaryColor,
                          ),
                          title: "بطاقة",
                          value: 'card',
                          selectedValue: paymentMethod,
                        ),
        
        
                      ]),
                ),
        
                const SizedBox(height: 30),
        
                Container(
                    width: 300,
                    height: 250,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("Assets/paymentDetails.png"),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 35,
                        bottom: 85,
                        left: 30,
                        right: 30
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
        
                                Text(
                                  "﷼${widget.price.toString()}",
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                      color: CustomColors.primaryColor,
                                      fontSize: 15
                                  ),
                                ),
        
                                const Expanded(child: SizedBox()),
        
                                const Text(
                                  'ريال',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                      color: CustomColors.primaryColor,
                                      fontSize: 15
                                  ),
                                ),
        
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
        
                const SizedBox(height: 5),
        SingleChildScrollView(child:
                CustomButton(
                  
                  text: ' الدفع',
                  onPressed:  () {
        
                    if((App.currentUser.walletBalance < widget.price) && paymentMethod == 'wallet'){
                      Fluttertoast.showToast(
                          msg: "الرصيد غير كافي",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 14.0
                      );
                      return;
                    }
        
                    if(paymentMethod == 'card'){
                      pay();
                    } else {
                      createReservation();
                    }
                  },
                ),),
        
                const SizedBox(height: 30),
        
              ],
            ),
          ),
        )
    );
  }

  Widget _paymentMethod({
    required Widget icon,
    required String title,
    String trailing = "",
    required String value,
    required String selectedValue,
  }) {
    return MaterialButton(
      onPressed: () {
        setState(() {
          paymentMethod = value;
        });
      },
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          const SizedBox(width: 2),

          if(trailing.isNotEmpty)
            Text(
              trailing,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),

          const Expanded(child: SizedBox()),

          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: CustomColors.primaryColor,
              fontSize: 18,
            ),
            textAlign: TextAlign.right,
          ),

          const SizedBox(width: 10),

          icon,

          const SizedBox(width: 10),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: CustomColors.primaryColor,
                  width: 1
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: AnimatedContainer(
              height: 10,
              width: 10,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value == selectedValue ? CustomColors.primaryColor : Colors.transparent
              ),
            ),
          ),

        ],
      ),
    );
  }

  String convertZoneToEnglish(String zone){
    if(zone == 'أ') {
      return 'A';
    }
    if(zone == 'ب') {
      return 'B';
    }
    if(zone=='ج') {
      return 'C';
    }
    return '';
  }

  int generateRandomIntWithFiveDigits() {
    int min = 10000, max = 99999;

    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void createReservation() async {
    final zone = convertZoneToEnglish(widget.zone);

    final snapshot = await FirebaseFirestore.instance
        .collection('parkings')
        .where('date', isEqualTo: widget.date.toString().substring(0, 10))
        .where('event', isEqualTo: widget.event)
        .where('zone', isEqualTo: 'Z-$zone')
        .where('status', isEqualTo: 'unavailable')
        .where('price', isEqualTo: widget.price)
        .get();

    final unavailableParkingIds = [];

    for (DocumentSnapshot doc in snapshot.docs) {
      if(doc.data() != null){
        unavailableParkingIds.add(doc.get('parkingId') ?? "");
      }
    }

    if(unavailableParkingIds.contains(widget.parkingSlot)){
      Fluttertoast.showToast(
          msg: "هذا الموقف محجوز، أختر موقف أخر",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0
      );
      return;
    }

    final reservation = Reservation(
        userId: Auth().uID,
        date: Timestamp.fromDate(widget.date),
        event: widget.event,
        zone: widget.zone,
        carLicense: widget.carLicense,
        status: true,
        parkingId: widget.parkingSlot,
        resId: reservationId,
    );

    await const ReservationDatabase().createReservation(reservation.toMap());

    String parkingSlotId = '${widget.event}-Z-${convertZoneToEnglish(widget.zone)}-SPOT${widget.parkingSlot}';

    final parking = Parking(
        id: parkingSlotId,
        userId: Auth().uID,
        date: widget.date.toString().substring(0, 10),
        event: widget.event,
        status: 'unavailable',
        zone: 'Z-$zone',
        parkingId: widget.parkingSlot,
        price: widget.price,
    );

    await const ParkingDatabase().createParking(parking.toMap());

    await UserDatabase().updateUserDetails({
      'id': Auth().uID,
      'walletBalance': App.currentUser.walletBalance - widget.price
    });

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationQR(reservationId: reservationId, fromNewBooking: true,)),
    );
  }


  Map<dynamic, dynamic> paymentIntent = {};

  void pay() async {
    try {
      final fundAmount = widget.price;

      await StripeService().publishableKey;

      await stripe.Stripe.instance.applySettings();

      //todo change currency
      paymentIntent =
      await createPaymentIntent((fundAmount * 100).toString(), 'USD');

      final transactionID = paymentIntent["id"];

      await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent['client_secret'],
              billingDetails: stripe.BillingDetails(
                email: App.currentUser.email,
                name: App.currentUser.name,
              ),
              customFlow: true,
              customerId: null,
              style: ThemeMode.dark,
              merchantDisplayName: 'PickNPark'
          )
      ).then((value) {});

      displayPaymentSheet(transactionID);
    } catch (e, s) {
      if (kDebugMode) {
        print('exceptions: $e, $s');
      }
    }
  }

  Future<void> displayPaymentSheet(String transactionID) async {

    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) async {

        await UserDatabase().updateUserDetails({
          'id': Auth().uID,
          'walletBalance': App.currentUser.walletBalance + widget.price,
        });

        createReservation();

      }).onError((error, stackTrace){
        if (kDebugMode) {
          print('error: $error, stacktrace: $stackTrace');
        }
      });
    } on stripe.StripeException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      Fluttertoast.showToast(
          msg: 'لا يمكن اكتمال عملية الدفع',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<Map<dynamic, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      final Uri apiUrl = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final String apiKey = await StripeService().secretKey;

      final Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency.toLowerCase(),
        'payment_method_types[]': 'card',
      };

      final http.Response response = await http.post(
          apiUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
          body: body
      );


      if (response.statusCode == 200) {
        return jsonDecode(response.body) ?? {};
      } else {
        if (kDebugMode) {
          print('لايمكن اكمال العملية');
        }
        return {};
      }


    } catch (err) {

      if (kDebugMode) {
        print('Error charging the user: ${err.toString()}');
      }
      return {};
    }
  }

  int calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100 ;
    return calculatedAmount;
  }
}
