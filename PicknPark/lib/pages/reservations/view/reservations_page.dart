import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:picknpark/app.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/reservations/reservations.dart';
import 'package:picknpark/services/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class Reservations extends StatefulWidget {
  const Reservations({Key? key}) : super(key: key);

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

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
        body:// SingleChildScrollView(
        //child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

           const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: _tab(
                        index: 0,
                        title: "الماضية",
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _tab(
                        index: 1,
                        title: "القادمة",
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: ReservationsList(isNew: false),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: ReservationsList(isNew: true),
                    ),
                  ]
              ),
            ),
          ],
        ),
       // )

    );
  }

  Widget _tab({required int index, required String title}) {
    final isSelected = index == tabController.index;

    return AnimatedContainer(
      height: 42,
      width: double.infinity,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected ? CustomColors.primaryColor : Colors.grey.shade400
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
        onPressed: () {
          tabController.animateTo(index);
          setState(() {});
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Tajawal',
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.grey.shade800
            ),
          ),
        ),
      ),
    );
  }
}

class ReservationsList extends StatelessWidget {
  final bool isNew;
  const ReservationsList({Key? key, required this.isNew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reservation>>(
        stream: getStream(),
        builder: (context, snapshot) {

          List<Reservation> reservations = [];

          if(snapshot.hasData){
            reservations = snapshot.data ?? [];
          }

          if(reservations.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey.shade700,
                    size: 200,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    isNew
                        ? "لا يوجد لديك حجوزات قادمة."
                        : "لا يوجد لديك حجوزات ماضية",
                    style: TextStyle(fontFamily: 'Tajawal',
                        color: Colors.grey.shade700,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: reservations.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final reservation = reservations[index];

              return _listItem(context, reservation: reservation);
            },
          );
        }
    );
  }

  Stream<List<Reservation>> getStream() {
    Query query = ReservationDatabase.reservationsCollection
        .where("userId", isEqualTo: Auth().uID);

    //I saw that rStatus was used in the initial code but I have no idea when
    // the value of that is changed so I used the date instead

    final now = DateTime.now();

    final timestamp = Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    if(isNew){
      query = query.where('date', isGreaterThanOrEqualTo: timestamp);
    } else {
      query = query.where('date', isLessThan: timestamp);
    }

    return query.orderBy('date', descending: true).snapshots().map((querySnapshot) {
        List<Reservation> reservations = [];
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          reservations.add(Reservation.fromDocumentSnapshot(documentSnapshot));
        }
        return reservations;
    });
  }

  Widget _listItem(BuildContext context, {required Reservation reservation}) {

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ReservationQR(reservationId: reservation.resId, fromNewBooking: false);
        }));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 5),

                Text(
                  '${getPrice(reservation)} ريال ',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                      color: Colors.black,
                      fontSize: 14
                  ),
                ),

                SizedBox(
                  height: 120.0,
                  width: 120.0,
                  child: QrImage(
                    data: reservation.resId.toString(),
                    version: QrVersions.auto,
                    size: 120.0,
                    gapless: true,
                    foregroundColor: CustomColors.primaryColor ,
                  ),
                ),

                const Text(
                  ' انقر للتوسيع',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      color: Colors.black,
                      fontSize: 14
                  ),
                ),

                const SizedBox(height: 5),
              ],
            ),

            const Expanded(child: SizedBox()),

            Column(
              children: [
                Image.network(
                  getPicture(reservation),
                  width: 120,
                  height: 50,
                ),

                const SizedBox(height: 30),

                Text(
                  ' منطقه ${reservation.zone} ، موقف ${reservation.parkingId}',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                      color: CustomColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  reservation.date.toDate().toString().substring(0, 10),
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                      color: Colors.black,
                      fontSize: 14
                  ),
                ),


                if(isNew)
                  const SizedBox(height: 5),

                if(isNew)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outlined,
                          color: CustomColors.primaryColor,
                          size: 24.0,
                        ),
                        onPressed: () {
                          showPopup(context, reservation);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: CustomColors.primaryColor,
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditReservation(reservation: reservation)),
                          );
                          // Handle button press
                        },
                      )
                    ],
                  ),

                const SizedBox(height: 5),

              ],

            ),
          ],
        ),
      ),
    );
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

  String getPicture(Reservation reservation){
    String pic = "";
    if(reservation.event.contains('BC')) {
      pic= "https://resizer.wafyapp.com/?source=https://prod-wafy-api.s3.eu-central-1.amazonaws.com/images/articles/1226-20211026113858-3324285.jpg&width=900";
    }
    if(reservation.event.contains('WL')) {
      pic= "https://upload.wikimedia.org/wikipedia/en/e/ed/Riyadh_Winter_Wonderland_logo.png";
    }
    if(reservation.event.contains('BW')) {
      pic= "https://bestriyadh.com/wp-content/uploads/2023/02/00bfafeaa70759b84c230ad8ddfd8f5530e59c7f.png";
    }

    return pic;
  }

  showPopup(BuildContext context, Reservation reservation) {

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          backgroundColor: Colors.white,
          content: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text (
                  "هل أنت متأكد من حذف هذا الحجز؟",
                  style: TextStyle(
                    
                      fontSize: 20,
                      color: CustomColors.primaryTextColor,
                      fontFamily: 'Tajawal'
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 42,
                  child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 42,
                            minWidth: double.infinity,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.zero,
                            color: CustomColors.primaryColorLight,
                            child: const Text(
                              "لا",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: MaterialButton(
                            height: 42,
                            minWidth: double.infinity,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            onPressed: () {
                              deleteReservation(context, reservation);
                            }, //to do
                            color: CustomColors.primaryColor,
                            padding: EdgeInsets.zero,
                            child: const Text(
                              "نعم",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Tajawal',
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteReservation(BuildContext context, Reservation reservation) async {
    await const ReservationDatabase().deleteReservation(reservation.id);

    String parkingSlotId = '${reservation.event}-Z-${convertZoneToEnglish(reservation.zone)}-SPOT${reservation.parkingId}';

    await const ParkingDatabase().updateParkingDetails({
      'id': parkingSlotId,
      'status': 'available'
    });

    await UserDatabase().updateUserDetails({
      'id': Auth().uID,
      'walletBalance': App.currentUser.walletBalance + getPrice(reservation),
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
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

}



