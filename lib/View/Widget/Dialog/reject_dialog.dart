import 'dart:async';
import 'package:backyard/Component/custom_radio_tile.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../Component/custom_buttom.dart';
import '../../../../../Component/custom_text.dart';
import '../../../Arguments/screen_arguments.dart';
import '../../../Component/custom_textfield.dart';
import '../../../Component/custom_toast.dart';

class RejectDialog extends StatefulWidget {
  RejectDialog(
      {super.key,
      required this.onYes,
      this.title,
      this.subTitle,
      this.description});
  Function(String) onYes;
  String? title, subTitle, description;

  @override
  State<RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<RejectDialog> {
  List<String> options = [
    'I don’t need it anymore.',
    'I don’t find it useful',
    'Other',
  ];
  int i = 999;
  String reason = '';
  TextEditingController other = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors().whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      // height: responsive.setHeight(75),
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: MyColors().secondaryColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.close_outlined,
                    color: Colors.transparent,
                  ),
                  MyText(
                    title: widget.title ?? 'Reject',
                    clr: MyColors().whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigation.navigatorPop();
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors().secondaryColor.withOpacity(.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          title: widget.subTitle ?? 'Reject Policy:',
                          size: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: .5.h,
                        ),
                        MyText(
                            title: widget.description ??
                                'Reject the ride within a specific timeframe (05 minutes) without incurring additional fees.',
                            size: 12,
                            clr: MyColors().greyColor.withOpacity(.6)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ListView.builder(
                      itemCount: options.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            i = index;
                            if (index < 2) {
                              reason = options[index];
                            } else {
                              reason = other.text;
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 1.h),
                            alignment: Alignment.center,
                            child: Row(children: [
                              CustomRadioTile(
                                v: (i == index),
                                color: MyColors().secondaryColor,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Expanded(
                                  child: MyText(
                                title: options[index],
                                size: 15,
                              )),
                            ]),
                          ),
                        );
                      }),
                  SizedBox(
                    height: 1.h,
                  ),
                  if (i == 2) ...[
                    MyTextField(
                      height: 8.h,
                      hintText: 'Description',
                      showLabel: false,
                      maxLines: 4,
                      minLines: 4,
                      controller: other,
                      borderRadius: 10,
                      maxLength: 275,
                      backgroundColor:
                          MyColors().secondaryColor.withOpacity(.3),
                      borderColor: MyColors().secondaryColor,
                      hintTextColor: MyColors().grey,
                      textColor: MyColors().black,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                  MyButton(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (reason.isEmpty && i != 2) {
                          CustomToast()
                              .showToast(message: 'Please select any reason');
                        } else if (other.text.isEmpty && i == 2) {
                          CustomToast().showToast(
                              message: 'Reason field can\'t be empty');
                        } else {
                          AppNavigation.navigatorPop();
                          // HomeController.i.jumpTo(i: 1);
                          widget.onYes(reason.isNotEmpty ? reason : other.text);
                        }
                      },
                      title: "Submit"),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.5.h,
            ),
          ],
        ),
      ),
    );
  }

  onWillPop(context) async {
    AppNavigation.navigateTo(
      AppRouteName.HOME_SCREEN_ROUTE,
    );
    return false;
  }
}
