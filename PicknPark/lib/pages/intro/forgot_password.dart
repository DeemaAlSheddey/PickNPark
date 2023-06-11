import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController email = TextEditingController();

  String emailError = "";

  late Timer _dialogTimer;

  @override
  Widget build (BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children:[
              Stack(
                children: [

                  const Align(
                    alignment: Alignment.topLeft,
                    child:Image(
                      image:AssetImage("Assets/Loginbg.png"),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 130),

                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 30),
                          child: const Text(
                            " استعادة كلمة المرور",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              
                                fontSize: 30,
                                color: CustomColors.primaryTextColor
                            ),
                          ),
                        ),

                        const SizedBox(height: 120),

                        CustomTextField(
                          controller: email,
                          hintText:"You@example.com",
                          labelText: 'البريد الالكتروني',
                          errorText: emailError,
                          suffixIcon: const Icon(Icons.person, color: CustomColors.primaryTextColor),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 25),

                        CustomButton(
                            onPressed:() async {
                              _resetPassword();
                            },
                            text: "إعادة تعيين كلمة المرور"
                        ),

                        const SizedBox(height: 15),

                        CustomButton(
                            color: Colors.grey.shade300,
                            textColor: CustomColors.primaryColor,
                            onPressed:() {
                              Navigator.pop(context);
                            },
                            text: "تسجيل الدخول"
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validate(){
    final String mEmail = email.text;

    if(mEmail.trim().characters.isEmpty || !mEmail.trim().isEmail){
      if(mounted){
        setState(() {
          emailError = "الرجاء ادخال بريد الالكتروني";
        });
      }
      return false;
    } else {
      if(mounted){
        setState(() {
          emailError = "";
        });
      }
    }

    return true;
  }

  void _resetPassword() async {

    FocusManager.instance.primaryFocus?.unfocus(); //Un-focus text field to close keyboard if it is open;

    if(_validate()){
      await Auth().resetPassword(email.text.trim());

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
                "تم ارسال رابط تعيين كلمة المرور إلى بريدك الالكتروني",
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
      });
    }
  }
}

