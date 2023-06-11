import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/default.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';

import 'login.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController password = TextEditingController();

  String nameError = "";
  String emailError = "";
  String phoneNumberError = "";
  String dateOfBirthError = "";
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
                            " تسجيل جديد",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              
                                fontSize: 30,
                                color: CustomColors.primaryTextColor
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        CustomTextField(
                          controller: name,
                          hintText:"الاسم",
                          labelText: 'الاسم',
                          errorText: nameError,
                          keyboardType: TextInputType.name,
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: email,
                          hintText:"You@example.com",
                          labelText: 'البريد الالكتروني',
                          errorText: emailError,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: phoneNumber,
                          hintText: "05XXXXXXXX",
                          labelText: 'رقم الجوال',
                          errorText: phoneNumberError,
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          maxLength: 10,
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: dateOfBirth,
                          hintText:"dd/mm/yyyy",
                          labelText: 'تاريخ الميلاد',
                          errorText: dateOfBirthError,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[\d/]'))
                          ],
                          maxLength: 10,
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                            controller: password,
                            hintText:"كلمة المرور",
                            labelText: 'كلمة المرور',
                            errorText: passwordError,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true
                        ),

                        const SizedBox(height: 25),

                        CustomButton(
                            onPressed:() async {
                              _signUp();
                            },
                            text: "تسجيل"
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            TextButton(
                                onPressed:() async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LogIn()),
                                  );
                                },
                                child: const Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      
                                        color: CustomColors.primaryTextColor
                                    )
                                )
                            ),

                            const SizedBox(width: 10),

                            const Text(
                                " لديك حساب؟",
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  
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
    final String mName = name.text;
    final String mEmail = email.text;
    final String mPhoneNumber = phoneNumber.text;
    final String mDateOfBirth = dateOfBirth.text;
    final String mPassword = password.text;

    if(mName.trim().characters.isEmpty){
      if(mounted){
        setState(() {
          nameError = "الرجاء ادخال الاسم";
        });
      }
      return false;
    } else {
      if(mounted){
        setState(() {
          nameError = "";
        });
      }
    }

    if(mEmail.trim().characters.isEmpty || !mEmail.trim().isEmail){
      if(mounted){
        setState(() {
          emailError = "الرجاء ادخال بريد إلكتروني";
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

    if(mPhoneNumber.trim().length < 10){
      if(mounted){
        setState(() {
          phoneNumberError = "الرجاء ادخال رقم الجوال";
        });
      }
      return false;
    } else {
      if(mounted){
        setState(() {
          phoneNumberError = "";
        });
      }
    }

    //To validate if date of birth is valid
    if (mDateOfBirth.split('/').length != 3) {
      if (mounted) {
        setState(() {
          dateOfBirthError = "الرجاء ادخال تاريخ الميلاد بصيغة 00/00/0000";
        });
      }
      return false;
    } else {
      final String day = mDateOfBirth.split('/')[0];
      final String month = mDateOfBirth.split('/')[1];
      final String year = mDateOfBirth.split('/')[2];

      if(day.length != 2 || month.length != 2 || year.length != 4){
        if (mounted) {
          setState(() {
            dateOfBirthError = "التاريخ غير صالح";
          });
        }
        return false;
      }else{
        final age = DateTime.now().difference(DateTime(int.parse(year), int.parse(month), int.parse(day)));

        if(age.inDays < 1){
          if (mounted) {
            setState(() {
              dateOfBirthError = "التاريخ غير صالج";
            });
          }
          return false;
        }else {
          if (mounted) {
            setState(() {
              dateOfBirthError = "";
            });
          }
        }
      }
    }

    if(mPassword.trim().length < 8){
      if(mounted){
        setState(() {
          passwordError = "يجب ان تكون كلمة المرور ٨ على الاقل";
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

  void _signUp() async {
    if(_validate()){
      await Auth().signUp(email.text.trim(), password.text.trim());

      if(Auth().isSignedIn){

        final user = User(
          id: Auth().uID,
          name: name.text,
          email: email.text,
          phoneNumber: phoneNumber.text,
          dateOfBirth: dateOfBirth.text,
        );

        await UserDatabase().createUser(user.toMap());

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