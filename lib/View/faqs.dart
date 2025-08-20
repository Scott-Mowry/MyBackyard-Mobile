import 'dart:developer';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Model/faq_model.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../Utils/utils.dart';

class FAQScreen extends StatefulWidget {
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  int selectedIndex = 0;
  List<FAQs> faqs = [
    FAQs(
        question: 'Question 01?',
        answer:
            'Lorem ipsum dolor sit amet consectetur adipiscing, elit congue nisi rutrum platea lacinia sapien, sed vel cras torquent scelerisque. Tempus pharetra quam congue natoque aptent sollicitudin et bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.'),
    FAQs(
        question: 'Question 02?',
        answer:
            'Lorem ipsum dolor sit amet consectetur adipiscing, elit congue nisi rutrum platea lacinia sapien, sed vel cras torquent scelerisque. Tempus pharetra quam congue natoque aptent sollicitudin et bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.'),
    FAQs(
        question: 'Question 03?',
        answer:
            'Lorem ipsum dolor sit amet consectetur adipiscing, elit congue nisi rutrum platea lacinia sapien, sed vel cras torquent scelerisque. Tempus pharetra quam congue natoque aptent sollicitudin et bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.'),
    FAQs(
        question: 'Question 04?',
        answer:
            'Lorem ipsum dolor sit amet consectetur adipiscing, elit congue nisi rutrum platea lacinia sapien, sed vel cras torquent scelerisque. Tempus pharetra quam congue natoque aptent sollicitudin et bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.'),
    FAQs(
        question: 'Question 05?',
        answer:
            'Lorem ipsum dolor sit amet consectetur adipiscing, elit congue nisi rutrum platea lacinia sapien, sed vel cras torquent scelerisque. Tempus pharetra quam congue natoque aptent sollicitudin et bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.'),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Support & Help',
        showAppBar: true,
        bgImage: '',
        showBackButton: true,
        resizeBottomInset: false,
        child: CustomRefresh(
          onRefresh: () async {
            // await getData(loading: false);
          },
          child: Consumer<HomeController>(builder: (context, val, _) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title: 'FAQ',
                    fontWeight: FontWeight.w600,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  // d.faqs.isEmpty
                  //     ? CustomEmptyData(
                  //         title: 'No FAQs',
                  //         hasLoader: false,
                  //       )
                  //     :
                  Flexible(
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 12,
                        itemBuilder: (BuildContext, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: GestureDetector(
                              onTap: () {
                                // selectedIndex.value = index;
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: selectedIndex == index
                                            ? MyColors().secondaryColor
                                            : MyColors().primaryColor2,
                                        // border: Border.all(
                                        //     color: MyColors().greyColor
                                        // ),
                                        borderRadius: selectedIndex == index
                                            ? BorderRadius.vertical(
                                                top: Radius.circular(25))
                                            : BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(4.w),
                                    // margin: EdgeInsets.only(bottom: 2.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          title: "Question",
                                          size: 15,
                                          fontWeight: FontWeight.w600,
                                          clr: MyColors().whiteColor,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (selectedIndex == index) {
                                              selectedIndex = 1000;
                                            } else {
                                              selectedIndex = index;
                                            }
                                            // selectedIndex.refresh();
                                          },
                                          child: Icon(
                                            selectedIndex == index
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: MyColors().whiteColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (selectedIndex == index) ...[
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors().secondaryColor),
                                          color: MyColors().whiteColor,
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(12))),
                                      padding: EdgeInsets.all(4.w),
                                      margin: EdgeInsets.only(bottom: 2.h),
                                      child: MyText(title: "answer"),
                                    ),
                                  ],
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      // AppNavigation.navigateTo(context, AppRouteName.CHAT_SCREEN_ROUTE,arguments: ScreenArguments(isSupport:true,u: User(id: HomeController.i.adminID)));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagePath.support,
                          color: MyColors().secondaryColor,
                          scale: 1.5,
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.03,
                            text: TextSpan(
                              text: "",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: MyColors().secondaryColor,
                                // decoration: TextDecoration.underline
                              ),
                              children: [
                                TextSpan(
                                  text: 'Chat with support',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      decorationThickness: 2,
                                      color: MyColors().secondaryColor,
                                      decoration: TextDecoration.underline),
                                  // recognizer: TapGestureRecognizer()
                                  //   ..onTap = () async {
                                  //     AppNavigation.navigateTo(context, AppRouteName.CHAT_SCREEN_ROUTE,);
                                  //   },
                                ),
                                TextSpan(
                                  text: '   OR   ',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    decorationThickness: 2,
                                    color: MyColors().black,
                                  ),
                                  // recognizer: TapGestureRecognizer()
                                  //   ..onTap = () async {
                                  //     AppNavigation.navigateTo(context, AppRouteName.CHAT_SCREEN_ROUTE,);
                                  //   },
                                ),
                                TextSpan(
                                  text: 'support@email.com',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      decorationThickness: 2,
                                      color: MyColors().secondaryColor,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      launchURL(email: 'support@email.com');
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),

              ///
              // ListView.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: ques.length,
              //     itemBuilder: (BuildContext, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.only(bottom: 0.0),
              //         child: GestureDetector(
              //             onTap: () {
              //               selectedIndex.value = index;
              //             },
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Container(
              //                   width: 100.w,
              //                   // color: Color(0xffFFFAF2),
              //                   padding: EdgeInsets.symmetric(
              //                       horizontal: 5.w, vertical: 1.5.h),
              //                   child: Obx(() {
              //                     return Column(
              //                       children: [
              //
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment
              //                               .spaceBetween,
              //                           children: [
              //                             MyText(
              //                               title: ques[index] ?? "",
              //                               clr: MyColors().whiteColor,
              //                               fontWeight: FontWeight.w600,
              //                               size: 16,
              //                             ),
              //                             GestureDetector(
              //                               onTap: () {
              //                                 if (selectedIndex.value ==
              //                                     index) {
              //                                   selectedIndex.value =
              //                                   1000;
              //                                 }
              //                                 else {
              //                                   selectedIndex.value =
              //                                       index;
              //                                 }
              //                                 selectedIndex.refresh();
              //                               },
              //                               child: Icon(
              //                                 selectedIndex.value ==
              //                                     index
              //                                     ?
              //                                 Icons.close
              //                                     : Icons.expand_more,
              //                                 color: MyColors()
              //                                     .whiteColor,),
              //                             )
              //                           ],
              //                         ),
              //
              //                         if( selectedIndex.value == index)
              //                           Divider(),
              //
              //                       ],
              //                     );
              //                   }),
              //                 ),
              //                 Obx(() =>
              //                 selectedIndex.value ==
              //                     index
              //                     ? Column(
              //                   crossAxisAlignment:
              //                   CrossAxisAlignment
              //                       .start,
              //                   children: [
              //                     Padding(
              //                       padding: EdgeInsets
              //                           .symmetric(
              //                           horizontal:
              //                           5.w,
              //                           vertical:
              //                           1.1.h),
              //                       child: MyText(
              //                         title: ans[index],
              //                         clr: Colors.white,
              //                         size: 12,
              //                       ),
              //                     ),
              //                     SizedBox(height: 1.h,)
              //                   ],
              //                 )
              //                     : Container())
              //               ],
              //             )),
              //       );
              //     }),
              ///
              // GetBuilder<HomeController>(
              //     builder: (d) {
              //     return d.notifications.isEmpty?CustomEmptyData(title: 'No Notifications',):ListView.builder(
              //         physics: AlwaysScrollableScrollPhysics(parent: const ClampingScrollPhysics()),
              //         itemCount:d.notifications.length,
              //         padding: EdgeInsets.zero,
              //         itemBuilder: (context,index){
              //           return Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               // if(index==0)...[
              //               //   MyText(title: 'Today',size: 18,fontWeight: FontWeight.w700,),
              //               //   SizedBox(height: 10,)
              //               // ],
              //               // if(index==3)...[
              //               //   MyText(title: 'Yesterday',size: 18,fontWeight: FontWeight.w700,),
              //               //   SizedBox(height: 10,)
              //               // ],
              //               NotifcationTile(n: d.notifications[d.notifications.length-index-1],),
              //             ],
              //           );
              //         });
              //   }
              // ),
            );
          }),
        ));
  }

  // Future<void> getData({loading}) async {
  //   await HomeController.i.getFAQs(loading: loading ?? true, context: context);
  // }

  void launchURL({required String email}) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
