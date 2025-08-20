import 'package:backyard/Controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Model/notification_model.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

import '../Utils/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Notifications',
      showAppBar: true,
      bgImage: '',
      showBackButton: true,
      resizeBottomInset: false,
      child: CustomRefresh(
        onRefresh: () async {
          await getData(loading: false);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child:
          // GetBuilder<HomeController>(
          //     builder: (d) {
          //     return d.notifications.isEmpty?CustomEmptyData(title: 'No notifications',): ListView.builder(
          //         physics: AlwaysScrollableScrollPhysics(parent: const ClampingScrollPhysics()),
          //         itemCount:d.notifications.length,
          //         padding: EdgeInsets.zero,
          //         itemBuilder: (context,index){
          //           return GestureDetector(
          //             onTap: (){
          //               AppNavigation.navigatorPop(context);
          //               // Utils().goToNotificationRoute(context: context,n: d.notifications[index],isPush: false);
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   border: Border.all(
          //                       color: MyColors().whiteColor
          //                   ),
          //                   borderRadius: BorderRadius.circular(10)
          //               ),
          //               margin: EdgeInsets.only(bottom: 0.h),
          //               padding: EdgeInsets.all(0.w),
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Padding(
          //                     padding: EdgeInsets.only(left: .5.h+2.w),
          //                     child: Row(children: [
          //                       // Expanded(child: MyText(title: d.notifications[index].time,size: 14,line: 1,)),
          //                       MyText(title: d.notifications[index].date,size: 14,line: 1,),
          //                     ],),
          //                   ),
          //                   // SizedBox(height: 1.h,),
          //                   Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       CustomImage(
          //                         height: 5.5.h,
          //                         width: 5.5.h,
          //                         isProfile: true,
          //                         photoView: false,
          //                         radius: 100,
          //                         url: d.notifications[index].user?.userImage,
          //                       ),
          //                       SizedBox(width: 2.w,),
          //                       Expanded(
          //                         child: Column(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             MyText(title: d.notifications[index].user?.fullName??'',size: 15,line: 1,fontWeight: FontWeight.w600,),
          //                             SizedBox(height: .5.h,),
          //                             MyText(title: d.notifications[index].body),
          //                           ],
          //                         ),
          //                       ),
          //                       SizedBox(width: 2.w,),
          //                       MyText(title: Utils.relativeTime(d.notifications[index].createdAt),size: 13),
          //                     ],),
          //                 ],),
          //             ),
          //           );
          //         });
          //   }
          // ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  shrinkWrap: true,
                  itemBuilder:
                      (_, index) => GestureDetector(
                        onTap: () {
                          // AppNavigation.navigateTo( AppRouteName.CHAT_SCREEN_ROUTE,arguments: ScreenArguments(u: User(id: 'ds',fullName: 'John Smith')));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors().whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: 10, // Spread of the shadow
                                spreadRadius: 2, // Size of the shadow
                                offset: const Offset(0, 4), // Position of the shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 2.h) + EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Image.asset(ImagePath.random2,scale: 2.5,),
                              // SizedBox(width: 3.w,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SizedBox(height: 1.h,),
                                    MyText(title: 'Auth Successful', size: 14, fontWeight: FontWeight.w600),
                                    MyText(
                                      title:
                                          'You have successfully signup as ${context.watch<UserController>().user?.role?.name ?? ""}',
                                      size: 13,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: MyText(title: '  5 mins ago', size: 13, clr: MyColors().grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // AppNavigation.navigateTo( AppRouteName.CHAT_SCREEN_ROUTE,arguments: ScreenArguments(u: User(id: 'ds',fullName: 'John Smith')));
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: MyColors().whiteColor,
              //       borderRadius: BorderRadius.all(Radius.circular(15)),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.1), // Shadow color
              //           blurRadius: 10, // Spread of the shadow
              //           spreadRadius: 2, // Size of the shadow
              //           offset: const Offset(0, 4), // Position of the shadow
              //         ),
              //       ],
              //     ),
              //     padding: EdgeInsets.all(12),
              //     margin: EdgeInsets.only(bottom: 2.h) +
              //         EdgeInsets.symmetric(horizontal: 3.w),
              //     child: Column(
              //       children: [
              //         Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             // Image.asset(ImagePath.random2,scale: 2.5,),
              //             // SizedBox(width: 3.w,),
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   // SizedBox(height: 1.h,),
              //                   MyText(
              //                     title: 'Employee Request',
              //                     size: 14,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                   MyText(
              //                     title:
              //                         'You have a new employee request from John Doe',
              //                     size: 13,
              //                   ),
              //                   GestureDetector(
              //                     onTap: () {
              //                       AppNavigation.navigateTo(
              //                           AppRouteName.USER_PROFILE_ROUTE);
              //                     },
              //                     child: CircleAvatar(
              //                       radius: 20,
              //                       backgroundImage: AssetImage(
              //                         ImagePath.random2,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Align(
              //                 alignment: Alignment.topRight,
              //                 child: MyText(
              //                   title: '  5 mins ago',
              //                   size: 13,
              //                   clr: MyColors().grey,
              //                 )),
              //           ],
              //         ),
              //         Divider(color: MyColors().grey),
              //         Row(
              //           children: [
              //             Expanded(
              //               child: ListTile(
              //                 title: const Text("Accept"),
              //                 trailing: Icon(
              //                   Icons.check,
              //                   color: MyColors().greenColor,
              //                 ),
              //               ),
              //             ),
              //             Expanded(
              //               child: ListTile(
              //                 title: const Text("Reject"),
              //                 trailing: Icon(
              //                   Icons.close,
              //                   color: MyColors().grey,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData({loading}) async {
    // await HomeController.i.getNotifications(loading: loading??true,context: context);
  }
}

class NotifcationTile extends StatelessWidget {
  NotifcationTile({super.key, required this.n});
  NotificationModel n;

  @override
  Widget build(BuildContext context) {
    // log("Notification Model:${n.toJson()}");

    return GestureDetector(
      onTap: () {
        // Utils().goToNotificationRoute(context: context,n: n,isPush: false);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: MyColors().whiteColor,
        margin: EdgeInsets.only(bottom: 1.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.pink
          ),
          padding: EdgeInsets.all(2.4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(title: n.title, size: 15, fontWeight: FontWeight.w600),
                  MyText(title: Utils.relativeTime(n.createdAt), size: 13),
                ],
              ),
              SizedBox(height: 5),
              MyText(title: n.body, size: 13),
            ],
          ),
        ),
      ),
    );
  }
}
