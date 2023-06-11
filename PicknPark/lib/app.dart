import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/models/models.dart';
import 'package:picknpark/pages/splash_screen.dart';
import 'package:picknpark/controllers/controllers.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key){
    Get.put(UserController());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PickNPark",
      locale: const Locale('en', ''),
      theme: ThemeData(
        primaryColor: CustomColors.primaryColor,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: CustomColors.primaryColor,
          selectionColor: CustomColors.primaryColorLight,
          selectionHandleColor: CustomColors.primaryColor,
        ),
      ),
      home: const SplashScreen(),
    );
  }

  static User get currentUser {
    return Get.find<UserController>().user.value;
  }

}
