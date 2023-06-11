import 'package:flutter/material.dart';
import 'package:picknpark/config/config.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservationQREdit extends StatefulWidget {
  final int reservationId;
  final bool fromNewBooking;
  final bool fromEditBooking;
  const ReservationQREdit({Key? key, required this.reservationId,
    this.fromNewBooking = false, this.fromEditBooking = false}) : super(key: key);

  @override
  State<ReservationQREdit> createState() => _ReservationQREditState();
}

class  _ReservationQREditState extends State<ReservationQREdit> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.fromNewBooking){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } if(widget.fromEditBooking){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title:
              Align(
              alignment: Alignment.centerRight,
              child: Text(
                '',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                    fontSize: 28
                ),
              ),
            ),
            backgroundColor: CustomColors.primaryColor,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(width: double.infinity),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [

                    Text(
                      " تم تعديل حجزك بنجاح ",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                          fontSize: 30,
                          color: CustomColors.primaryTextColor
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "لدخول المنطقة الرجاء مسح الباركود ",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                          fontSize: 18,
                          color: CustomColors.primaryTextColor
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                )
              ),

              QrImage(
                data: widget.reservationId.toString(),
                version: QrVersions.auto,
                size: 260.0,
                gapless: true,
                foregroundColor: CustomColors.primaryColor ,
              ),

              const Expanded(child: SizedBox())

            ],
          ),
      ),
    ) ;
  }
}
