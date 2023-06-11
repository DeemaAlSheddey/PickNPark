import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/pages/home/view/new_booking/new_booking.dart';
import 'package:picknpark/pages/shared/shared.dart';
 
class SelectParkingSpot extends StatefulWidget {
  final DateTime date;
  final String event;

  const SelectParkingSpot({Key? key, required this.date, required this.event}) : super(key: key);

  @override
  State<SelectParkingSpot> createState() => _SelectParkingSpotState();
}

class _SelectParkingSpotState extends State<SelectParkingSpot> with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      if(mounted){
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar( leading: IconButton(
    icon: Icon(Icons.arrow_back), 
    onPressed: () => Navigator.pop(context),
  ),


        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
          // you can forcefully translate values left side using Transform
          transform:  Matrix4.translationValues(240.0, -50.0, 0.0),
          child: const Text(
              "",
              style: TextStyle(
                fontFamily: 'Tajawal',
                  fontSize:22
              )
          ),
        ),
        backgroundColor: CustomColors.primaryColor ,
        toolbarHeight: 140,
        actions: [ 
          Container(
            transform:  Matrix4.translationValues(-40.0, -15.0, 25.0),
            margin: const EdgeInsets.only(top:60),
            height: 100,
            child: Row(
              children: [
                _tab(
                  index: 0,
                  title: " منطقة أ",
                  subtitle: "ريال60"
                ),

                _tab(
                  index: 1,
                  title: "منطقةب",
                  subtitle: "ريال40"
                ),

                _tab(
                  index: 2,
                  title: "منطقة ج ",
                  subtitle: "ريال20"
                )
              ],
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
        ),
      ),
      
      body:
      TabBarView(
          controller: tabController,
          children: [
            ParkingArea(date: widget.date, event: widget.event, price: 60, zone: 'أ'),
            ParkingArea(date: widget.date, event: widget.event, price: 40, zone: 'ب'),
            ParkingArea(date: widget.date, event: widget.event, price: 20, zone: 'ج'),
          ]
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
              child: const Image(image: AssetImage("Assets/reservedParking.png"),),
            ),

            const Text('محجوز'),

            Container(
              transform:  Matrix4.translationValues(30.0, 0.0, 0.0),
              width: 40.0,
              height: 40.0,
              child: const Image(image: AssetImage("Assets/yourPark.png"),),
            ),

            const Text('موقفك'),
          ],
        ),
      ),
    );
  }

  Widget _tab({required int index, required String title, required String subtitle}) {
    final isSelected = index == tabController.index;

    return AnimatedContainer(
      height: 90,
      width: 80,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              blurRadius: 8,
              offset: const Offset(4 , 4),
              color: Colors.black.withOpacity(0.3)
          )
        ],
        color: isSelected ? Colors.white : const Color.fromARGB(248, 144, 114, 175)
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
        onPressed: () {
          tabController.animateTo(index);
          setState(() {});
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Tajawal',
                  fontSize: 15,
                  color: isSelected ? Colors.black : Colors.white
              ),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Tajawal',
                  fontSize: 15,
                  color: isSelected ? Colors.black : Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ParkingArea extends StatefulWidget {
  final DateTime date;
  final String event;
  final String zone;
  final int price;

  const ParkingArea({Key? key, required this.date, required this.event, required this.zone, required this.price}) : super(key: key);

  @override
  State<ParkingArea> createState() => _ParkingAreaState();
}

class _ParkingAreaState extends State<ParkingArea> {
  int _selectedSpot = -1;

  List<bool> _parkingSpots = List.generate(15, (index) => false);

  bool isEnabled = false;

  late List<int> unavailableParkingIds = [];
  late int parkingSlot;

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

        Expanded(
          child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                                  return SelectCar(
                                      date: widget.date,
                                      event: widget.event,
                                      parkingSlot: parkingSlot,
                                      zone: widget.zone,
                                      price: widget.price
                                  );
                                }
                            )
                        );
                      }
                    },
                    color: isEnabled ? CustomColors.primaryColor : Colors.grey.shade300,
                    textColor: isEnabled ? Colors.white : Colors.grey.shade800,
                    text: 'التالي'
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
     ), ),
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



