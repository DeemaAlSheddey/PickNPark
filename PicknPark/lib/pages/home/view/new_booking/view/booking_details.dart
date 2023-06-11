import 'package:flutter/material.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/pages/home/home.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'select_parking_area.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({Key? key}) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {

 
 // late DateTime date;
  late String event = "";

  //DateTime newDate;
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  bool isEnabled = false;

  List<String>itemList = ['ونتروندرلاند',"بوليفارد وورلد","بوليفارد سيتي"];
  String selectedEvent = 'ونتروندرلاند';

  onSelectedEvent(DateTime today, String selectedEvent) {
    if (selectedEvent == 'بوليفارد وورلد') {
      setState(() {
        event = 'BW';
      });
    } else if (selectedEvent == 'ونتروندرلاند') {
      setState(() {
        event = 'WL';
      });
    } else if (selectedEvent == "بوليفارد سيتي") {
      setState(() {
        event = 'BC';
      });
    }

    /*TODO what is this for? should it be there?
    setState(() {
      date = today;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(

          
          title: const Align(
            alignment: Alignment.topRight,
            child: Text(
              "حجز اليوم",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 26,
              ),
            ),
          ),
          backgroundColor: CustomColors.primaryColor,
          toolbarHeight: 140,
          actions: [
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.only(right: 20),
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
          child: Column(
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
                          isEnabled = true; // for next button
                        });
                      },
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 50, right: 25),
                alignment: Alignment.centerRight,
                child: const Text(
                  "الفعاليات" ,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      fontSize: 28,
                      color: CustomColors.primaryColor
                  ),
                  textAlign: TextAlign.right,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 25),
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
                  child: PopupMenuButton<String>(
                    tooltip: "اختر الفعالية",
                    enabled: true,
                    color: Colors.white,
                    constraints: const BoxConstraints(
                      minHeight: 24,
                      maxHeight: 500,
                      minWidth: 320,
                      maxWidth: 320,
                    ),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) =>
                        itemList.map<PopupMenuItem<String>>((String event) {
                          return PopupMenuItem<String>(
                            value: event,
                            child: Text(
                                event,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  
                                    fontSize: 18
                                )
                            ),
                          );
                        }).toList(),
                    onSelected: (String event) {
                      setState(() => selectedEvent = event);
                    },
                    child: SizedBox(
                      height: 50,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            const Icon(
                              Icons.arrow_drop_down,
                              size: 21,
                              color: Colors.black,
                            ),

                            const SizedBox(width: 10),

                            Text(
                                selectedEvent,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                    fontSize: 18
                                )
                            ),

                          ],
                        ),
                    ),
                  )
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    CustomButton(
                      onPressed: () {
                        if(isEnabled){
                          onSelectedEvent(today, selectedEvent);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectParkingSpot(date: selectedDate, event: event)
                            ),
                          );
                        }
                      },
                      color: isEnabled ? CustomColors.primaryColor : Colors.grey.shade300,
                      textColor: isEnabled ? Colors.white : Colors.grey.shade800,
                      text: 'التالي'
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
}
