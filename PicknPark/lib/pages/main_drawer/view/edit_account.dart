import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/app.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'package:picknpark/services/services.dart';


class EditAccount extends StatefulWidget{
 const EditAccount({ super.key });
  @override
  // ignore: library_private_types_in_public_api
  _EditAccountState createState() => _EditAccountState();
}
  
class _EditAccountState extends State<EditAccount> {

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  String nameError = "";
  String emailError = "";
  String phoneNumberError = "";

  @override
  void initState() {
    name.text = App.currentUser.name;
    email.text = App.currentUser.email;
    phoneNumber.text = App.currentUser.phoneNumber;
    super.initState();
  }

  @override
    Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            "تعديل معلومات المستخدم",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
            ),
          ),
        ),
        backgroundColor: CustomColors.primaryColor,
        toolbarHeight: 140,
        actions: [
          SizedBox(
            width: 120,
            child: Image.asset(
              'Assets/EditAcount.png',
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 100),

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
                    enabled: false,
                    hintText:"You@example.com",
                    labelText: 'البريد الإلكتروني',
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

                  const SizedBox(height: 25),

                  CustomButton(
                      onPressed:() async {
                        save();
                      },
                      text: "حفظ"
                  ),

                  const SizedBox(height: 10),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validate(){
    final String mName = name.text;
    final String mPhoneNumber = phoneNumber.text;

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

    if(mPhoneNumber.trim().length < 10){
      if(mounted){
        setState(() {
          phoneNumberError = "الرجاء ادخال رقم الهاتف";
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
    return true;
  }


  void save() async {
    if(_validate()) {
      await UserDatabase().updateUserDetails({
        'id': Auth().uID,
        'name': name.text.trim(),
        'phoneNumber': phoneNumber.text.trim(),
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
