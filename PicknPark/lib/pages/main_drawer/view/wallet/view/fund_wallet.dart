import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:picknpark/config/config.dart';
import 'package:picknpark/controllers/controllers.dart';
import 'package:picknpark/pages/shared/shared.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:picknpark/app.dart';
import 'package:picknpark/services/services.dart';

import '../widgets/widgets.dart';


class FundWallet extends StatefulWidget {
  const FundWallet({Key? key}) : super(key: key);

  @override
  State<FundWallet> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {

  final TextEditingController amount = TextEditingController();

  String amountError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تعبئة المحفظة",
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 28
          )
        ),
        backgroundColor: CustomColors.primaryColor,
        toolbarHeight: 140,
        actions: [
          Container(
            width: 110,
            padding: const EdgeInsets.only(left:10,right:20),
            child: Image.asset(
              'Assets/eWallet.png',
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [

              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Center(
                        child: Text(
                          "رصيد المحفظة",
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                              color: CustomColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          const SizedBox(width: 10),

                          GetX<UserController>(
                              builder: (controller) {
                                return Text(
                                  "﷼${controller.user.value.walletBalance}",
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                );
                              }
                          ),

                          const Expanded(child: SizedBox()),

                          const Text(
                            "رصيد المحفظة",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: CustomColors.primaryColor,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          const SizedBox(width: 10),

                          Image.asset(
                              "Assets/wallet.png",
                              width: 20
                          ),

                          const SizedBox(width: 10),
                        ],
                      ),

                    ]),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: amount,
                hintText: "المبلغ ",
                labelText: 'ادخل المبلغ',
                errorText: amountError,
                keyboardType: TextInputType.number,
                showPrefixIcon: false,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'\d'))],
                maxLength: 7,
              ),

              const SizedBox(height: 30),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumPad(
                    buttonSize: 56,
                    buttonColor: CustomColors.primaryColor,
                    iconColor: CustomColors.primaryColor,
                    controller: amount,
                    delete: () {
                      amount.text = amount.text
                          .substring(0, amount.text.length - 1);
                    },
                    onSubmit: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              CustomButton(
                  onPressed: () => _pay(),
                  text: 'الدفع'
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Map<dynamic, dynamic> paymentIntent = {};

  bool _validate() {
    final String mAmount = amount.text;

    if(mAmount.trim().isEmpty || int.parse(mAmount.trim()) < 5){
      if(mounted){
        setState(() {
          amountError = "يجب ان يكون المبلغ ٥ ريال على الاقل";
        });
      }
      return false;
    } else {
      if(mounted){
        setState(() {
          amountError = "";
        });
      }
    }

    return true;
  }

  void _pay() async {
    if(_validate()){
      try {

        final fundAmount = int.parse(amount.text.trim());

        await StripeService().publishableKey;

        await stripe.Stripe.instance.applySettings();

        //todo change currency
        paymentIntent = await createPaymentIntent((fundAmount * 100).toString(), 'USD');

        final transactionID = paymentIntent["id"];

        await stripe.Stripe.instance.initPaymentSheet(
            paymentSheetParameters: stripe.SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent['client_secret'],
                billingDetails: stripe.BillingDetails(
                  email: App.currentUser.email,
                  name: App.currentUser.name,
                ),
                customFlow: true,
                customerId: null,
                style: ThemeMode.dark,
                merchantDisplayName: 'PickNPark'
            )
        ).then((value){});

        displayPaymentSheet(transactionID);

      } catch (e, s) {
        if (kDebugMode) {
          print('exceptions: $e, $s');
        }
      }
    }

  }

  Future<void> displayPaymentSheet(String transactionID) async {

    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) async {

        await UserDatabase().updateUserDetails({
          'id': Auth().uID,
          'walletBalance': App.currentUser.walletBalance + int.parse(amount.text.trim()),
        });

        Fluttertoast.showToast(
            msg: 'تم شحن المحفظة بنجاح',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0
        );

      }).onError((error, stackTrace){
        if (kDebugMode) {
          print('error: $error, stacktrace: $stackTrace');
        }
      });
    } on stripe.StripeException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      Fluttertoast.showToast(
          msg: 'لم يتم اكتمال العملية',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<Map<dynamic, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      final Uri apiUrl = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final String apiKey = await StripeService().secretKey;

      final Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency.toLowerCase(),
        'payment_method_types[]': 'card',
      };

      final http.Response response = await http.post(
          apiUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
          body: body
      );


      if (response.statusCode == 200) {
        return jsonDecode(response.body) ?? {};
      } else {
        if (kDebugMode) {
          print('خطأ شحن في الرصيد');
        }
        return {};
      }


    } catch (err) {

      if (kDebugMode) {
        print('خطأ في شحن الرصيد ${err.toString()}');
      }
      return {};
    }
  }

  int calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100 ;
    return calculatedAmount;
  }
}


