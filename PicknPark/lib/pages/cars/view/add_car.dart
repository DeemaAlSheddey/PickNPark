import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';

class AddCar extends StatefulWidget {
  const AddCar({Key? key}) : super(key: key);

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {

  final TextEditingController type = TextEditingController();
  final TextEditingController license = TextEditingController();

  String typeError = "";
  String licenseError = "";

  late Timer _dialogTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
              "إضافة سيارة جديدة",
              style: TextStyle(
                fontFamily: 'Tajawal',
                
                  fontSize:23
              )
          ),
          backgroundColor: CustomColors.primaryColor,
          toolbarHeight: 140,
          actions: [
            SizedBox(
              width: 110,
              child: Image.asset(
                'Assets/car.png', 
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30)),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
  
                    const SizedBox(height: 120),
  
                    CustomTextField(
                      controller: type,
                      hintText: "مثال : فورد",
                      labelText: 'نوع السيارة',
                      errorText: typeError,
                      suffixIcon: const Icon(Icons.drive_eta, color: CustomColors.primaryTextColor),
                      keyboardType: TextInputType.name,
                    ),
  
                    const SizedBox(height: 15),
  
                    CustomTextField(
                      controller: license,
                      hintText: "XXXX - 0000",
                      labelText: 'لوحة السيارة',
                      errorText: licenseError,
                      suffixIcon: const Icon(Icons.numbers, color: CustomColors.primaryTextColor),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\d-]'))
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    
                    CustomButton(
                        onPressed: () => addCar(),
                        text: 'حفظ'
                        
                    ),
                  ],
                )
              ),
            )
        )
    );
  }
  
  bool _validate(){
    final String carType = type.text;
    final String mLicense = license.text;

    if(carType.trim().characters.isEmpty){
      if(mounted){
        setState(() {
          typeError = "الرجاء ادخال نوع السيارة";
        });
      }
      return false;
    } else {
      if(mounted){
        setState(() {
          typeError = "";
        });
      }
    }

    if(mLicense.trim().length < 3){
      if(mounted){
        setState(() {
          licenseError = "الرجاء ادخال لوحة السيارة بصيغة xxx-xxxx";
        });
      }
      return false;
    } else {

      final numbers = [];
      final letters = [];

      for(int i = 0; i < mLicense.trim().length; i++){
        final char = mLicense.trim()[i];

        if(char.isNum){
          numbers.add(char);
        } else if(char.isAlphabetOnly){
          letters.add(char);
        }
      }

      String error = "";

      if( letters.length > 3  ){
        error = " pnmtالرجاء ادخال لوحة السيارة بصيغة xxx-xxxx";
      } else if(numbers.isEmpty || numbers.length > 4){
        error = "الرجاء ادخال لوحة السيارة بصيغة xxx-xxxx";
      }

      if(mounted){
        setState(() {
          licenseError = error;
        });
      }

      if(error.isNotEmpty){
        return false;
      }
    }

    return true;
  }
  
  void addCar() async {

    if(_validate()) {
      final car = Car(
        userId: Auth().uID,
        type: type.text.trim(),
        license: license.text.trim(),
      );

      await const CarDatabase().createCar(car.toMap());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context){
          _dialogTimer = Timer(const Duration(milliseconds: 1200), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: Colors.white,
            content: const Text (
              "تم اضافة السيارة بنجاح",
              style: TextStyle(
                fontFamily: 'Tajawal',
                  fontSize: 16,
                  color: Colors.black
              ),
            ),
          );
        },
      ).then((value) {
        if (_dialogTimer.isActive) {
          _dialogTimer.cancel();
        }

        Navigator.pop(context);
      });
    }
  }
}
