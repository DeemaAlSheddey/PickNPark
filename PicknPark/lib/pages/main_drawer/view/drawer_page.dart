import 'package:flutter/material.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/app.dart';
import 'package:picknpark/pages/intro/intro.dart';
import 'package:picknpark/pages/intro/start_page.dart';
import 'package:picknpark/pages/main_drawer/main_drawer.dart';
import 'package:picknpark/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.primaryColor,
      child: ListView(
        children: [
          ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${App.currentUser.name}مرحبا ',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),
              ),
            ),
          ),

          ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'رصيد المحفظة :  ${App.currentUser.walletBalance}  رس',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.white,
            thickness: 1,
          ),

          ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  'تعديل معلومات المستخدم',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                ),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditAccount()),);
                },
              ),
            ),
          ),

          ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  'المحفظة الإلكترونية ',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                ),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FundWallet()),);
                },
              ),
            ),
          ),

          ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  'اتصل بنا',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                ),
                onPressed: ()  async {
                  //callPhoneNumber('966592787013');
                  callUsPopUp(context);
                },
              ),
            ),
          ),

          ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                ),
                onPressed: ()  {
                  showPopup(context);
                },
              ),
            ),
          ),

          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 300),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: const Text(
                        (' AR | EN'),
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                        ),
                      ),
                      onPressed: () async {},
                    ),
                  ),
                ),
              ),

             
            ],
          ),
        ],
      ),
    );
  }

  void callPhoneNumber(String phoneNumber) async {
    String telUrl = 'tel:$phoneNumber';
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      throw 'لا يمكن الاتصال برقم $phoneNumber';
    }
  }

  showPopup(BuildContext context) {
    Alert(
      style: AlertStyle(
        titleStyle: const TextStyle(
          
            fontSize: 23,
            color: CustomColors.primaryTextColor,
            fontFamily: 'Tajawal'
        ),
        descStyle: const TextStyle(
            fontSize: 20,
            color: CustomColors.primaryTextColor,
            fontFamily: 'Tajawal'
        ),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: CustomColors.primaryTextColor,
            width: .0,
          ),
        ),
      ),
      closeIcon: Container(),
      context: context,
      desc: "متأكد من تسجيل الخروج؟",
      buttons: [
        DialogButton(
          height: 42,
          width: 95,
          radius: const BorderRadius.all(Radius.circular(50)),
          onPressed: () async {
            Navigator.pop(context);
          },
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
        DialogButton(
          height: 42,
          width: 95,
          radius: const BorderRadius.all(Radius.circular(50)),
          onPressed: () async {
            await Auth().logOut();

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const startPage())
            );
          }, //to do
          color: CustomColors.primaryColor,
          child: const Text(
            "نعم",
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Tajawal',
                color: Colors.white
            ),
          ),
        ),
      ],
    ).show();
  }

  callUsPopUp(BuildContext context) {
    Alert(
      style: const AlertStyle(
          titleStyle: TextStyle(
              fontSize: 23,
              color: CustomColors.primaryTextColor,
              fontFamily: 'Tajawal'
          ),
          descStyle: TextStyle(
              fontSize: 20,
              color: CustomColors.primaryTextColor,
              fontFamily: 'Tajawal'
          )
      ),
      closeIcon: const Icon(
        Icons.close,
        size: 24,
        color: Colors.black,
      ),
      context: context,
      buttons: [
        DialogButton(
          height: 50 ,
          width: 250,
          radius: const BorderRadius.all(Radius.circular(6)),
          onPressed: ()  async {
            callPhoneNumber('966592787013');},
          color: Colors.white,
          child: RichText(
            text: const TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                      Icons.phone,
                      color: Colors.black, size: 25
                  ),
                ),

                TextSpan(
                  text: " 96652787013",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Tajawal'
                  ),
                ),
              ],
            ),
          ),

        ),

      ],
    ).show();
  }

}
