import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/View/Widget/Dialog/profile_complete_dialog.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Utils/my_colors.dart';
import 'package:http/http.dart' as http;

class AddCard extends StatefulWidget {
  AddCard({this.test});

  Map<String, dynamic>? test;

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController name = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController expiry = TextEditingController();

  // TextEditingController monthController = TextEditingController();
  // TextEditingController yearController = TextEditingController();
  TextEditingController cvc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: (widget.test != null) ? "Payment" : 'Add Card',
        showAppBar: true,
        bgImage: '',
        showBackButton: true,
        resizeBottomInset: false,
        child: CustomPadding(
          horizontalPadding: 3.w,
          topPadding: 0,
          child: InkWell(
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            focusColor: Colors.white,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                customTitle(
                  title: 'Card Holder',
                ),
                SizedBox(
                  height: 1.h,
                ),
                MyTextField(
                  hintText: 'Card Holder',
                  controller: name,
                  maxLength: 32,
                  showLabel: false,
                  backgroundColor: MyColors().container,
                ),
                SizedBox(
                  height: 2.h,
                ),
                customTitle(
                  title: 'Card Number',
                ),
                SizedBox(
                  height: 1.h,
                ),
                MyTextField(
                  hintText: 'Card Number',
                  cardFormat: true,
                  inputType: TextInputType.number,
                  controller: cardNumber,
                  maxLength: 19,
                  showLabel: false,
                  backgroundColor: MyColors().container,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTitle(
                            title: 'Expiry',
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          MyTextField(
                            hintText: 'MM/YY',
                            cardExpiration: true,
                            maxLength: 5,
                            inputType: TextInputType.number,
                            controller: expiry,
                            showLabel: false,
                            backgroundColor: MyColors().container,

                            // readOnly: true,
                            // onTap: (){
                            //   monthPick(context);
                            // },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTitle(
                            title: 'CVC',
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          MyTextField(
                            showLabel: false,
                            hintText: 'CVC',
                            inputType: TextInputType.number,
                            maxLength: 4,
                            controller: cvc,
                            cardFormat: true,
                            backgroundColor: MyColors().container,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Spacer(),
                MyButton(
                    onTap: () {
                      onSubmit();
                    },
                    title: "Add Now"),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ));
  }

  addCardValidation() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (name.text.isEmpty) {
      CustomToast()
          .showToast(message: "Card holder name field can't be empty.");
    } else if (cardNumber.text.isEmpty) {
      CustomToast().showToast(message: "Card Number field can't be empty.");
    } else if (cardNumber.text.length < 19) {
      CustomToast().showToast(message: "Please enter valid card number.");
    } else if (expiry.text.isEmpty) {
      CustomToast().showToast(message: "Expiry field can't be empty.");
    } else if (expiry.text.length < 5) {
      CustomToast().showToast(message: "Please enter valid MM/YY.");
    } else if (int.tryParse(expiry.text.split('/')[0])! > 12) {
      CustomToast().showToast(message: "Please enter valid month.");
    } else if (int.tryParse(expiry.text.split('/')[1])! < 24) {
      CustomToast().showToast(message: "Please enter valid year.");
    } else if (expiry.text.isEmpty) {
      CustomToast().showToast(message: "Expiry field can't be empty.");
    } else if (cvc.text.isEmpty) {
      CustomToast().showToast(message: "CVV field can't be empty.");
    } else if (cvc.text.length < 3) {
      CustomToast().showToast(message: "Please enter valid CVV.");
    } else {
      AppNetwork.loadingProgressIndicator();
      final val = await cardAPI();
      AppNavigation.navigatorPop();
      if (val) {
        AppNetwork.loadingProgressIndicator();
        final user = context.read<UserController>().user;
        final result = await AuthAPIS.completeProfile(
          firstName: user?.name,
          lastName: user?.lastName,
          description: user?.description,
          address: user?.address,
          lat: user?.latitude,
          long: user?.longitude,
          email: user?.email,
          phone: user?.phone,
          days: user?.days,
          image: File(user?.profileImage ?? ""),
        );
        AppNavigation.navigatorPop();
        if (result) {
          completeDialog(onTap: () {
            AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
          });
        }
      }
    }
  }

  Future<bool> cardAPI() async {
    try {
      final price = widget.test?["price"] as double;
      if (await AppNetwork.checkInternet()) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64.encode(utf8.encode('nzpL73LfqcrxyeVhMageUNcL97L1YeVw:1234'))}'
        };
        var request = http.Request(
            'POST',
            Uri.parse(
                'https://api.sandbox.epsgsecure.app/api/v2/transactions/charge'));
        request.body = json.encode({
          "name": name.text,
          "amount": price,
          "card": cardNumber.text.replaceAll(" ", ""),
          "expiry_month": int.parse(expiry.text.split('/')[0]),
          "expiry_year": 2000 + int.parse(expiry.text.split('/')[1]),
          "cvv2": cvc.text
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        final res = await http.Response.fromStream(response);
        final model = json.decode(res.body);
        if (response.statusCode == 200) {
          if (model["status_code"] == "A") {
            return true;
          }
        } else {
          CustomToast().showToast(message: model["error_message"].toString());
        }
      } else {
        CustomToast().showToast(message: "No Internet Connection");
      }
    } catch (e) {
      CustomToast().showToast(message: e.toString());
    }
    return false;
  }

  completeDialog({required Function onTap}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                content: ProfileCompleteDialog(
                  onYes: (v) {
                    log('Yaha arha h 2');
                    onTap();
                  },
                ),
              ),
            ),
          );
        });
  }

  onSubmit() {
    addCardValidation();
    // HomeController.i.name=name.text;
    // HomeController.i.cardNumber=cardNumber.text;
    // HomeController.i.expiry=expiry.text;
    // // HomeController.i.year=yearController.text;
    // HomeController.i.cvc=cvc.text;
    // HomeController.i.addCardValidation(context);
  }

  monthPick(context) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    print(selected);

    if (selected != null) {
      // monthController.text=Utils.getFormattedMonthYear(date:selected.toString());//.replaceFirst("T", " ").replaceFirst("Z", ""),);
    }
  }

  customTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w),
      child: MyText(title: title),
    );
  }
}
