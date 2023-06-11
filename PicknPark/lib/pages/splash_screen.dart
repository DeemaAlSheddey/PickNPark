import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:picknpark/config/colors.dart';
import 'package:picknpark/pages/intro/intro.dart';
import 'package:picknpark/pages/intro/start_page.dart';
import 'package:picknpark/services/services.dart';

import 'default.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Timer(const Duration(seconds: 4), () async {
      if(Auth().isSignedIn){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => startPage())
        );
      }else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const startPage()),
        );
      }
    });

    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: CustomColors.primaryColor,
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxWidth * 0.6,
                width: constraints.maxWidth * 0.6,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    "Assets/Logo.png",
                    color: Colors.white,
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
