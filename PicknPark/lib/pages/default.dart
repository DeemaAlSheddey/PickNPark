import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picknpark/config/colors.dart';
import 'package:picknpark/controllers/controllers.dart';
import 'package:picknpark/pages/cars/view/cars_page.dart';
import 'package:picknpark/pages/home/home.dart';
import 'package:picknpark/services/services.dart';

import 'main_drawer/main_drawer.dart';
import 'reservations/reservations.dart';

class Default extends StatefulWidget {
  Default({Key? key}) : super(key: key){
    Get.find<UserController>().bindUser();
  }

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {

  int selectedIndex = 1;

  final bucket = PageStorageBucket();
  final List<Widget> screens = [const Reservations(), const Home(), const Cars()];

  final pageNames = ["حجوزاتي", "الرئيسية", "السيارات"];
  final pageIcons = ["Assets/res.png", "Assets/Logo.png", "Assets/car2.png"];

  @override
  void initState() {
    StripeService().initialize();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GetX<UserController>(
            builder: (controller) {
              return PageStorage(
                bucket: bucket,
                child: screens[controller.currentTab.value],
              );
            }
          ),
          appBar: AppBar(
            title: Align(
              alignment: Alignment.centerRight,
              child: GetX<UserController>(
                builder: (controller) {
                  return Text(
                    pageNames[controller.currentTab.value],
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                        fontSize: 28),
                  );
                }
              ),
            ),
            backgroundColor: CustomColors.primaryColor,
            leading: Center(
              child: SizedBox(
                height: 36,
                width: 36,
                child: GetX<UserController>(
                    builder: (controller) {
                      return Image.asset(
                        pageIcons[controller.currentTab.value],
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      );
                  }
                ),
              ),
            ),
          ),
          endDrawer: const MainDrawer(),
          bottomNavigationBar: GetX<UserController>(
            builder: (controller) {
              return BottomNavigationBar(
                currentIndex: controller.currentTab.value,
                unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal',
                  color: CustomColors.primaryColorLight, fontSize: 14),
                unselectedItemColor: CustomColors.primaryColorLight,
                selectedItemColor: Colors.white,
                selectedLabelStyle: const TextStyle(fontFamily: 'Tajawal',
                  color: Colors.white, fontSize: 14),
                backgroundColor: CustomColors.primaryColor,
                onTap: (index) {
                  controller.changeTab(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.calendar_today,
                        size: 24,
                      ),
                      label: 'حجوزاتي'
                  ),

                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 24,
                      ),
                      label: 'الرئيسية'
                      
                  ),

                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.directions_car,
                        size: 24,
                      ),
                      label: 'السيارات'
                  )

                ],
              );
            }
          )
      ),
    );
  }
}



