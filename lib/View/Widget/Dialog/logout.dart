import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:sizer/sizer.dart';

class LogoutAlert extends StatefulWidget {
  @override
  State<LogoutAlert> createState() => _LogoutAlertState();
}

class _LogoutAlertState extends State<LogoutAlert> {
  @override
  Widget build(BuildContext c) {
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
                    title: 'Logout',
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
            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //       color: MyColors().black,borderRadius: const BorderRadius.vertical(top: Radius.circular(20))
            //   ),
            //   padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 3.w),
            //   child:
            //   MyText(title: 'Logout',clr: MyColors().whiteColor,fontWeight: FontWeight.w600,center: true,size: 20,),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                      child: MyText(
                    title: 'Are you sure want to\nlogout?',
                    size: 18,
                    center: true,
                  )),
                  SizedBox(
                    height: 3.h,
                  ),
                  MyButton(
                      onTap: () async {
                        AppNetwork.loadingProgressIndicator();
                        await AuthAPIS.signOut();
                      },
                      title: "Logout"),
                  // SizedBox(height: 1.h,),
                  // GestureDetector(
                  //     onTap: (){AppNavigation.navigatorPop(context);},
                  //     child: MyText(title: 'Not Now!',size: 17,center: true,clr: MyColors().secondaryColor,fontWeight: FontWeight.w600,)),
                  SizedBox(
                    height: 3.5.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
