import 'package:flutter/material.dart';
import 'package:picknpark/pages/shared/shared.dart';

import 'new_booking/new_booking.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Row(

                children: [
                  SizedBox(
                    height: 480,
                    child: Image.asset('Assets/WinterLandL2.jpg'),
                  ),

                  SizedBox(
                    height: 480,
                    child: Image.asset('Assets/BLVDWorldM.jpg'),
                  ),
                  SizedBox(
                    height: 480,
                    child: Image.asset('Assets/BLVDCityR.jpg'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            CustomButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingDetails()));
              },
              text: "حجز جديد",
              icon: Icons.add
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),

    );
  }
}

