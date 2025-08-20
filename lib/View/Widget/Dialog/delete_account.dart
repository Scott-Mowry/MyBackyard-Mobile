import 'dart:async';
import 'package:backyard/Component/custom_radio_tile.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../Component/custom_buttom.dart';
import '../../../../../Component/custom_text.dart';

class DeleteDialog extends StatefulWidget {
  DeleteDialog(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onYes});
  String title, subTitle;
  Function onYes;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
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
                  color: MyColors().primaryColor,
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
                    title: 'Delete Account',
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  MyText(
                    title: 'Are you sure? Do you want to delete your account.',
                    size: 18,
                    fontWeight: FontWeight.w600,
                    center: true,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ListView.builder(
                      itemCount: options.length,
                      shrinkWrap: true,
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
                      borderColor: MyColors().secondaryColor,
                      backgroundColor:
                          MyColors().secondaryColor.withOpacity(.4),
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
                          widget.onYes();
                        }
                      },
                      title: "Delete Now"),
                  SizedBox(
                    height: 1.h,
                  ),
                  GestureDetector(
                      onTap: () {
                        AppNavigation.navigatorPop();
                      },
                      child: MyText(
                          title: 'Not Now!',
                          size: 17,
                          center: true,
                          clr: MyColors().primaryColor,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 1.5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
