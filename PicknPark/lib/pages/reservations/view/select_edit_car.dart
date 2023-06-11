import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknpark/app.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/reservations/reservations.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';
import 'edit_reservation_qr .dart';

class SelectEditCar extends StatefulWidget {
  final DateTime date;
  final Reservation reservation;
  final int parkingSlot;
  final int price;

  const SelectEditCar({Key? key, required this.date, required this.reservation,
    required this.parkingSlot, required this.price}) : super(key: key);

  @override
  State<SelectEditCar> createState() => _SelectEditCarState();
}

class _SelectEditCarState extends State<SelectEditCar> {

  late String event = "";
  Car selectedCar = Car.empty();
  late List<Car> cars = [];
 late  String plate;

  //late String selectedCar;

  @override
  void initState () {
    event = getEvent();
    getCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "الدفع",
            style: TextStyle (
              fontFamily: 'Tajawal',
             fontSize: 28
            )
          ),
          backgroundColor:CustomColors.primaryColor,
          toolbarHeight: 140,
          actions: [
            Container(
              width: 110,
              padding: const EdgeInsets.only(left:10, right:20),
              child: Image.asset(
                'Assets/pay.png'
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30)),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [

              const SizedBox(height: 50),

              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        width: 1,
                        color: CustomColors.primaryColor
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          offset: const Offset(4 , 4),
                          color: Colors.black.withOpacity(0.3)
                      )
                    ]
                ),
                child: Center(
                    child: Builder(
                      builder: (context) {
                        final isEnabled = cars.isNotEmpty;
                        return PopupMenuButton<Car>(
                          tooltip: "اختر السيارة",
                          enabled: isEnabled,
                          color: Colors.white,
                          constraints: const BoxConstraints(
                            minHeight: 24,
                            maxHeight: 500,
                            minWidth: 320,
                            maxWidth: 320,
                          ),
                          position: PopupMenuPosition.under,
                           itemBuilder: (context) => cars.map<PopupMenuItem<Car>>((Car car) {
                            return PopupMenuItem<Car>(
                              value: car,
                              child: Text(
                                car.type,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 18
                                  
                                )
                                ,textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                          onSelected: (Car car) {
                            setState(() => selectedCar = car);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 21,
                                  color: isEnabled ? Colors.black : Colors.grey.shade700,
                                ),

                                const SizedBox(width: 10),

                                Text(
                                    isEnabled ? selectedCar.type : 'لا يوجد لديك سيارات مضافة',
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                        color: isEnabled ? Colors.black : Colors.grey.shade700,
                                        fontSize: 18
                                    )
                                ),

                                const SizedBox(width: 20),

                                Icon(
                                  Icons.drive_eta,
                                  size: 21,
                                  color: isEnabled ? Colors.black : Colors.grey.shade700,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    )
                ),
              ),

              const SizedBox(height: 50),

              const Text(
                  "تفاصيل الحجز" ,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      color: CustomColors.primaryColor,
                      fontSize: 15
                  )
              ),

              Container(
                  margin:const EdgeInsets.only(top: 10),
                  width: 300,
                  height: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("Assets/rec.png"),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Container (
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10
                    ),
                    color: Colors.white,
                    child: Column (
                        children: [

                          _item(
                            value: widget.date.toString().substring(0, 11),
                            icon: Icons.calendar_month_rounded,
                          ),

                          const Divider(
                            height: 1,
                            color: CustomColors.primaryColor,
                          ),

                          _item(
                              value: event,
                              icon: Icons.location_on_outlined
                          ),

                          const Divider(
                            height: 1,
                            color: CustomColors.primaryColor,
                          ),

                          _item(
                              value: widget.parkingSlot.toString(),
                              label: 'موقف'
                          ),

                          const Divider(
                            height: 1,
                            color: CustomColors.primaryColor,
                          ),

                          _item(
                              value: widget.reservation.zone.toString(),
                              label: 'منطقة'
                          ),
                        ]
                    ),
                  )
              ),

              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      CustomButton(
                        text: ' المتابعة',
                        onPressed:  () {
                          if(selectedCar.id.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "الرجاء اختيار سيارة",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 14.0
                            );
                            return;
                          }

                          editReservation();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ReservationQREdit (
                                  reservationId: widget.reservation.resId, fromEditBooking: true);
                                }
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 50),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

  String getEvent() {
    if (widget.reservation.event=="WL") {
      return "ونترووندرلاند";
    }
    if (widget.reservation.event=="BC") {
      return "بوليفارد سيتي";
    }
    if (widget.reservation.event=="BW") {
      return "بوليفارد وورلد";
    }

    return "";
  }

  void getCars() async {
    final result = await const CarDatabase().getCars();

    if(mounted) {
      setState(() {
        cars = result;
        if(cars.isNotEmpty){
          for(Car car in cars){
            if(car.license == widget.reservation.carLicense) {
              selectedCar = car;
            }
          }

          if(selectedCar.id.isEmpty){
            selectedCar = cars.first;
          }
        }
      });
    }
  }

  Widget _item({String? label, IconData? icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: CustomColors.primaryColor,
              fontSize: 15
            ),
          ),

          const Expanded(child: SizedBox()),

          if(label != null)
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: CustomColors.primaryColor,
                fontSize: 15
              ),
            ),


          if(icon != null && label != null)
            const SizedBox(width: 10),

          if(icon != null)
            Icon(
              icon,
              color: CustomColors.primaryColor,
              size: 21
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

  void editReservation() async {
   
   
   
   // await createParkingSpotsCollection();

    //update old parking status
    String convertZoneLetter = '';
    if('${widget.reservation.zone}' == "أ"){
      convertZoneLetter = 'A';
    } else if('${widget.reservation.zone}' == "ب"){
      convertZoneLetter = 'B';
    } else if('${widget.reservation.zone}' == "ج"){
      convertZoneLetter = 'C';
    }
    final zone = convertZoneToEnglish(widget.reservation.zone);


    CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');
    String reservationID= '${widget.reservation.id}';
    print(" resssss ffffffff"+reservationID);
    await reservationCollection.doc(reservationID).update({
      'date': Timestamp.fromDate(widget.date),
      'parkingId': widget.parkingSlot,
      'carLicense': selectedCar.license,
    });


    //old reservation (done)
    CollectionReference parkingCollection = FirebaseFirestore.instance.collection('parkings');
    //String parkingiddddd = '${widget.event}'+'-Z-A-'+'SPOT'+'${_selectedSpot}';
    //String parkingId = 'BC-Z-A-SPOT${widget.parkingSlot}';
    String ParkingId = '${widget.reservation.event}'+"-Z-"+zone+'-SPOT'+'${widget.reservation.parkingId}';
    print("id parkinggg ffffffff"+ ParkingId);
    await parkingCollection.doc(ParkingId).update({
      'status': 'available'
    });

    CollectionReference parkinggCollection = FirebaseFirestore.instance.collection('parkings');
    //String parkingiddddd = '${widget.event}'+'-Z-A-'+'SPOT'+'${_selectedSpot}';
    //String parkingId = 'BC-Z-A-SPOT${widget.parkingSlot}';
    String newParkingId = '${widget.reservation.event}'+"-Z-"+zone+'-SPOT'+'${widget.parkingSlot}';
    //String newparking= "${widget.parkingSlot}";
    print("slot parkinggg ffffffff"+newParkingId);
    await parkinggCollection.doc(newParkingId).update({
      'status': 'unavailable',
      'date':Timestamp.fromDate(widget.date),
    });

  }
  
}
