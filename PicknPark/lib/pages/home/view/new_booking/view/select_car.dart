import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';

import 'payment_page.dart';

class SelectCar extends StatefulWidget {
  final DateTime date;
  final String event;
  final int parkingSlot;
  final String zone;
  final int price;

  const SelectCar({Key? key, required this.date, required this.event,
    required this.parkingSlot, required this.zone, required this.price}) : super(key: key);

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {

  late String event = "";
  Car selectedCar = Car.empty();
  late List<Car> cars = [];

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
             fontSize: 30
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
                  height: 265,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("Assets/rec.png"),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Container (
                    margin: const EdgeInsets.all(30),
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
                              value: widget.zone.toString(),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return PaymentPage(
                                      date: widget.date,
                                      event: widget.event,
                                      parkingSlot: widget.parkingSlot,
                                      zone: widget.zone,
                                      price: widget.price,
                                      carLicense: selectedCar.license
                                  );
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
    if (widget.event=="WL") {
      return "ونترووندرلاند";
    }
    if (widget.event=="BC") {
      return "بوليفارد سيتي";
    }
    if (widget.event=="BW") {
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
          selectedCar = cars.first;
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
}
