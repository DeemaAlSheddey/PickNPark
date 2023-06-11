import 'package:flutter/material.dart';

import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/cars/cars.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/database/database.dart';

class Cars extends StatefulWidget {
  const Cars({Key? key}) : super(key: key);

  @override
  State<Cars> createState() => _CarsState();
}

class _CarsState extends State<Cars> {

  Car selectedCar = Car.empty();
  late List<Car> cars = [];

  @override
  Widget build(BuildContext context) {
    getCars();

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [

              const SizedBox(height: 15),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if(cars.isEmpty){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(
                              Icons.drive_eta,
                              color: Colors.grey.shade700,
                              size: 200,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              "الرجاء اضافة سيارة",
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: Colors.grey.shade700,
                                fontSize: 18
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: cars.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final car = cars[index];

                        return Container(
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
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                            title: Text(
                              car.type,
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                color: CustomColors.primaryColor,
                                fontSize: 18
                              ),
                            ),
                            subtitle: Text(
                              car.license,
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                  color: Colors.grey.shade700,
                                  fontSize: 14
                              ),
                            ),
                            trailing: const Icon(
                              Icons.drive_eta,
                              color: CustomColors.primaryColor,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    );
                  }
                )
              ),

              CustomButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCar()));
                  },
                  text: "إضافة سيارة جديدة",
                  icon: Icons.add
              ),

              const SizedBox(height: 50)
            ],
          ),
        ),
    );
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
}

