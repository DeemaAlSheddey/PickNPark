import 'dart:math';

import 'package:flutter/material.dart';
import 'package:picknpark/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpark/config/config.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:picknpark/app.dart';
import 'package:picknpark/pages/reservations/reservations.dart';
import 'package:picknpark/pages/shared/shared.dart';

class EditReservation extends StatefulWidget {
  final Reservation reservation;
  const EditReservation({Key? key, required this.reservation}) : super(key: key);

  @override
  State<EditReservation> createState() => _EditReservationState();
}

class _EditReservationState extends State<EditReservation> {

  bool isEnabled = false;
  DateTime selectedDate = DateTime.now();

  String refreshCode = '';

  @override
  void initState() {
    selectedDate = widget.reservation.date.toDate();
    refreshCode = generateCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            "تعديل الحجز",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize:26,
            ),
          ),
        ),
        backgroundColor: CustomColors.primaryColor,
        toolbarHeight: 140,
        actions: [
          SizedBox(
            width: 120,
            child: Image.asset(
              'Assets/Picture2.png',
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30)),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 210, 232, 255),
      body: Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [

                Container(
                  height: 90,
                  color: const Color.fromARGB(255, 210, 232, 255),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DatePicker(
                        DateTime.now(),
                        width: 70,
                        height: 90,
                        selectionColor: const Color.fromARGB(255, 175, 214, 255),
                        selectedTextColor: const Color.fromARGB(249, 0, 0, 0),
                        //only show 30 days
                        daysCount: 30,
                        locale: "ar",
                        onDateChange: (date) {
                          // New date selected
                          setState(() {
                            selectedDate = date;
                            refreshCode = generateCode();
                            isEnabled = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                     children: [
                       ParkingArea(
                           refreshCode: refreshCode,
                           date: selectedDate,
                           reservation: widget.reservation,
                           event: widget.reservation.event,
                           price: getPrice(widget.reservation),
                           zone: widget.reservation.zone,
                       ),
                     ],
                    ),
                  ),
                ),

              ],
            );
          }
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              transform:  Matrix4.translationValues(30.0, 0.0, 0.0),
              width: 20.0,
              height: 20.0,
              color: const Color.fromARGB(255, 210, 232, 255),
            ),
            const Text('متاح'),
            Container(
              transform:  Matrix4.translationValues(30.0, 0.0, 0.0),
              width: 40.0,
              height: 40.0,
              //color: CustomColors.primaryColor,
              child: const Image(image: AssetImage("Assets/reservedParking.png"),),
            ),
            const Text('محجوز'),
            Container(
              transform:  Matrix4.translationValues(30.0, 0.0, 0.0),
              width: 40.0,
              height: 40.0,
              //color: CustomColors.primaryColor,
              child: const Image(image: AssetImage("Assets/yourPark.png"),),
              //Assets/reservedParking.png
            ),
            const Text('موقفك'),
          ],
        ),
      ),
    );
  }

  String generateCode (){
    Random random = Random();
    String fields = "abcdefghijklmnopqrstuvwxyz0123456789";
    String code = "";
    for (int i = 0; i < 10; i++) {
      code += fields[random.nextInt(35)];
    }
    return code;
  }

  int getPrice(Reservation reservation){
    int price = 0;
    if(reservation.zone.contains('ب')) {
      price = 40;
    }
    if(reservation.zone.contains('أ')) {
      price = 60;
    }
    if(reservation.zone.contains('ج')) {
      price = 20 ;
    }

    return price;
  }
}

class ParkingArea extends StatefulWidget {
  final String refreshCode;
  final DateTime date;
  final String event;
  final String zone;
  final Reservation reservation;
  final int price;
  const ParkingArea({Key? key, required this.date, required this.event,
    required this.zone, required this.price, required this.refreshCode,
    required this.reservation}) : super(key: key);

  @override
  State<ParkingArea> createState() => _ParkingAreaState();
}

class _ParkingAreaState extends State<ParkingArea> {
  int _selectedSpot = -1;

  List<bool> _parkingSpots = List.generate(15, (index) => false);

  bool isEnabled = false;

  late List<int> unavailableParkingIds = [];
  late int parkingSlot;

  String refreshCode = "";

  @override
  void initState() {
    getUnavailableSpots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSpot != -1) {
      isEnabled = true;
    }

    if (widget.refreshCode.isNotEmpty && widget.refreshCode != refreshCode) {
      setState(() {
        _selectedSpot = -1;
        isEnabled = false;
        getUnavailableSpots();
        refreshCode = widget.refreshCode;
      });
    }

    return Column(
      children:[
        Container(
          width: 330,
          height: 450,
          margin: const EdgeInsets.only(left: 30, right: 20, top: 40),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/parkingArea.png"),
                  fit: BoxFit.fill
              )
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i < 8; i++)
                      _buildParkingSpot(i),
                  ],
                ),

                const SizedBox(width: 90),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 8; i < 15; i++)
                      _buildParkingSpot(i),
                  ],
                ),

              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: CustomButton(
              onPressed: () {
                if(isEnabled){

                  parkingSlot = _selectedSpot;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return SelectEditCar(
                              date: widget.date,
                              reservation: widget.reservation,
                              price: widget.price,
                              parkingSlot: _selectedSpot
                          );
                          
                        }),
                  );
                }
              },
              color: isEnabled ? CustomColors.primaryColor : Colors.grey.shade300,
              textColor: isEnabled ? Colors.white : Colors.grey.shade800,
              text: 'تأكيد التعديل'
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  void getUnavailableSpots() {
    final zone = convertZoneToEnglish(widget.zone);

    FirebaseFirestore.instance
        .collection('parkings')
        .where('date', isEqualTo: widget.date.toString().substring(0, 10))
        .where('event', isEqualTo: widget.event)
        .where('zone', isEqualTo: 'Z-$zone')
        .where('status', isEqualTo: 'unavailable')
        .where('price', isEqualTo: widget.price)
        .get()
        .then((snapshot) {

      unavailableParkingIds = [];

      for (DocumentSnapshot doc in snapshot.docs) {
        if(doc.data() != null){
          unavailableParkingIds.add(doc.get('parkingId') ?? "");
        }
      }
      setState(() {});
    });
  }

  Widget _buildParkingSpot(int index) {
    bool isSpotAvailable = true;

    for (var reservedIndex in unavailableParkingIds){
      if(reservedIndex == index) isSpotAvailable = false;
    }

    return GestureDetector(
      onTap: isSpotAvailable
          ? _parkingSpots[index]
          ? null : () => _selectParkingSpot(index)
          : null,
      child: Container(
        width: 118,
        height: 55,
        decoration: BoxDecoration(
          color: _selectedSpot == index
              ? Colors.white
              : _parkingSpots[index]
              ? Colors.white
              : const Color.fromARGB(255, 210, 232, 255),
          border: Border.all(),
        ),
        child: Stack(
          children: [
            if (_selectedSpot != index)
              Center(
                child: Text(
                  "$index${widget.zone}",
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),

            if (_selectedSpot == index)
              Center(
                child: Image.asset(
                  'Assets/yourPark.png',
                  fit: BoxFit.fill,
                ),
              ),

            if (!isSpotAvailable)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("Assets/reservedParking.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
          ],
        ),
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
    if(widget.zone=='ج') {
      return 'C';
    }
    return '';
  }

  void _selectParkingSpot(int index) {
    setState(() {
      _parkingSpots[index] = true;
      _selectedSpot = index;
      _parkingSpots = List.generate(15, (index) => false);
    });
  }
}

