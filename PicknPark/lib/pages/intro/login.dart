import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/pages/default.dart';
import 'package:picknpark/pages/intro/intro.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String emailError = "";
  String passwordError = "";

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
                        const SizedBox(height: 100),

                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "..نورتنا ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 20,
                              color: CustomColors.primaryTextColor,
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 30),
                          child: const Text(
                            " تسجيل الدخول",
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

                        const SizedBox(height: 12),

                        CustomTextField(
                            controller: password,
                            hintText:"كلمة المرور",
                            labelText: 'كلمة المرور',
                            errorText: passwordError,
                            suffixIcon: const Icon(Icons.lock, color: CustomColors.primaryTextColor),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true
                        ),

                        const SizedBox(height: 5),
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPassword()),
                              );
                            },
                            child: const Text(
                                "نسيت كلمة المرور؟ ",
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  
                                  color: CustomColors.subtitleTextColor
                                )
                            )
                          ),
                        ),
                        
                        const SizedBox(height: 25),

                        CustomButton(
                            onPressed:() async {
                              _login();
                            },
                            text: "تسجيل الدخول"
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            TextButton(
                                onPressed:() async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUp()),
                                  );
                                },
                                child: const Text(
                                    "تسجيل جديد",
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      
                                        color: CustomColors.primaryTextColor
                                    )
                                )
                            ),

                            const SizedBox(width: 10),

                            const Text(
                                "ليس لديك حساب؟",
                                style: TextStyle(fontFamily: 'Tajawal',
                                  
                                    color: CustomColors.subtitleTextColor
                                )
                            ),

                          ],
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
    final String mPassword = password.text;

    if(mEmail.trim().characters.isEmpty || !mEmail.trim().isEmail){
      if(mounted){
        setState(() {
          emailError = "الرجاء إدخال بريد إلكتروني صحيح";
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

    if(mPassword.trim().length < 8){
      if(mounted){
        setState(() {
          passwordError = "يجب ان تكون كلمة المرور ٨ أحرف على الاقل";
        });
      }
      return false;
    } else {
      if(mounted){
        setState(() {
          passwordError = "";
        });
      }
    }

    return true;
  }

  void _login() async {
    if(_validate()){
      await Auth().login(email.text.trim(), password.text.trim());

      if(Auth().isSignedIn){

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Default()),
        );
      } else {
        Auth().authFailed();
      }
    }
  }
}

