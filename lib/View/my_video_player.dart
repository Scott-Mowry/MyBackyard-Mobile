// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:backyard/Component/custom_image.dart';
// import 'package:backyard/Component/custom_text.dart';
// import 'package:backyard/Component/custom_videoplayer.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Model/chat_model.dart';
// import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Utils/enum.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:backyard/View/Widget/bordered_container.dart';
// import 'package:backyard/View/Widget/live_comment_tile.dart';
// import 'package:backyard/View/Widget/stacked_image.dart';
// import 'package:sizer/sizer.dart';
//
// import '../Controller/global_controller.dart';
// import '../Utils/image_path.dart';
//
// class MyVideoPlayer extends StatefulWidget {
//   String url;
//   bool? showSellerProfileOnly;
//   MyVideoPlayer({required this.url,this.showSellerProfileOnly});
//   @override
//   State<MyVideoPlayer> createState() => _MyVideoPlayerState();
// }
//
// class _MyVideoPlayerState extends State<MyVideoPlayer> {
//
//   TextEditingController message = TextEditingController();
//   List fav = [false,false,false,false,false,false,false,false,false,false,];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // checkProductInCart();
//     getData();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeController>(
//         builder: (d) {
//         return Scaffold(
//           body: Stack(
//             children: [
//               Container(
//                 height: 100.h,
//                 width: 100.w,
//                 child: CustomVideoPlayer(url: widget.url,),
//                 //color: Colors.red,
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 5.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     //mainAxisAlignment: MainAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         height: 40.h,
//                         padding: EdgeInsets.symmetric(horizontal: 3.w)+EdgeInsets.only(bottom: 1.h),
//                         decoration: BoxDecoration(
//                          // color: Colors.red,
//                          //  gradient: LinearGradient(
//                          //    colors: [
//                          //      //Colors.transparent,
//                          //       MyColors().purpleColor.withOpacity(.8),
//                          //      Colors.transparent,
//                          //      // Colors.transparent,
//                          //      // MyColors().purpleColor,
//                          //    ],
//                          //    begin: Alignment.bottomCenter,
//                          //    end: Alignment.topCenter,
//                          //  ),
//                         ),
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: Builder(
//                                   builder: (context) {
//                                     return d.liveStreaming.value.comments==null?SizedBox():ListView.builder(
//                                       // physics: const NeverScrollableScrollPhysics(),
//                                         physics: const BouncingScrollPhysics(),
//                                         shrinkWrap: true,
//                                         reverse: true,
//                                         itemCount: d.liveStreaming.value.comments?.length,
//                                         itemBuilder: (context,index){
//                                           return LiveCommentTile(c:d.liveStreaming.value.comments?[d.liveStreaming.value.comments!.length - index-1]??Chat());
//                                         });
//                                   }
//                               ),
//                             ),
//                             _buildMessageComposer(p:d.liveStreaming.value.productsCount.obs),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Container(
//               //   //height: 100.h,width: 100.w,
//               //   color: Colors.yellow,
//               //   alignment: Alignment.bottomCenter,
//               //   margin: EdgeInsets.only(bottom: 40.0),
//               //   child:
//               //   Column(
//               //     crossAxisAlignment: CrossAxisAlignment.end,
//               //     //mainAxisAlignment: MainAxisAlignment.end,
//               //     mainAxisSize: MainAxisSize.min,
//               //     children: [
//               //       Container(
//               //         height: 40.h,
//               //         padding: EdgeInsets.symmetric(horizontal: 3.w)+EdgeInsets.only(bottom: 1.h),
//               //         decoration: BoxDecoration(
//               //           color: Colors.red,
//               //           // gradient: LinearGradient(
//               //           //   colors: [
//               //           //     Colors.transparent,
//               //           //     // MyColors().purpleColor.withOpacity(.8),
//               //           //     Colors.transparent,
//               //           //     // Colors.transparent,
//               //           //     // MyColors().purpleColor,
//               //           //   ],
//               //           //   begin: Alignment.bottomCenter,
//               //           //   end: Alignment.topCenter,
//               //           // ),
//               //         ),
//               //         child: Column(
//               //           children: [
//               //             Expanded(
//               //               child: Builder(
//               //                 builder: (context) {
//               //                   return d.liveStreaming.value.comments==null?SizedBox():ListView.builder(
//               //                     // physics: const NeverScrollableScrollPhysics(),
//               //                       physics: const BouncingScrollPhysics(),
//               //                       shrinkWrap: true,
//               //                       reverse: true,
//               //                       itemCount: d.liveStreaming.value.comments?.length,
//               //                       itemBuilder: (context,index){
//               //                         return LiveCommentTile(c:d.liveStreaming.value.comments?[d.liveStreaming.value.comments!.length - index-1]??Chat());
//               //                       });
//               //                 }
//               //               ),
//               //             ),
//               //             _buildMessageComposer(p:d.liveStreaming.value.productsCount.obs),
//               //           ],
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 3.w)+EdgeInsets.only(top: 6.h),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: (){onBack();},
//                       child: Icon(
//                         Icons.arrow_back_ios_rounded,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     SizedBox(width: 3.w),
//                     if(d.influencerUser.value.id!='' && !influencer)...[
//                       StackedImage(seller: d.sellerUser.value,influencer: d.influencerUser.value)
//                     ]else...[
//                       GestureDetector(
//                         onTap: (){
//                           // if(!seller){
//                           //   AppNavigation.navigateTo( AppRouteName.SELLER_PROFILE_ROUTE,);
//                           // } else{
//                           //   AppNavigation.navigateTo( AppRouteName.HOME_SCREEN_ROUTE,arguments: ScreenArguments(index: 3));
//                           // }
//                         },
//                         child: CircleAvatar(
//                           radius:2.5.h,
//                           backgroundColor: MyColors().pinkColor,
//                           child: CircleAvatar(
//                             radius:2.3.h,
//                             backgroundColor: MyColors().whiteColor,
//                             child: CustomImage(
//                               height: 5.5.h,
//                               width: 5.5.h,
//                               isProfile: true,
//                               photoView: false,
//                               url: d.sellerUser.value.userImage,
//                               radius: 100,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     SizedBox(width: 2.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                               onTap: (){
//                                 // if(!seller){
//                                 //   AppNavigation.navigateTo( AppRouteName.SELLER_PROFILE_ROUTE,);
//                                 // }
//                               },child: MyText(title: '${d.sellerUser.value.firstName} ${d.sellerUser.value.lastName}',clr: MyColors().whiteColor,size: 15,fontWeight: FontWeight.w600,)),
//                           Row(
//                             children: [
//                               if(d.influencerUser.value.id!='' &&  !influencer)
//                                 GestureDetector(
//                                     onTap: (){
//                                       // if(!seller){
//                                       //   AppNavigation.navigateTo( AppRouteName.SELLER_PROFILE_ROUTE,);
//                                       // }
//                                     },child: MyText(title:'${d.influencerUser.value.firstName} ${d.influencerUser.value.lastName}  ',clr: MyColors().whiteColor,size: 12,fontWeight: FontWeight.w600)),
//                               // if(!influencer)
//                                 BorderedContainer(child:MyText(title: ' ${d.liveStreaming.value.category} ',clr: MyColors().purpleColor,size: 11,fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ],),
//                     ),
//                     BorderedContainer(child:MyText(title: '  WAS LIVE  ',clr: MyColors().purpleColor,size: 11,fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//               // Scaffold(
//               //   body:Container(
//               //     decoration: BoxDecoration(
//               //       gradient: LinearGradient(
//               //         colors: [
//               //           MyColors().purpleColor.withOpacity(.8),
//               //           Colors.transparent,
//               //           // Colors.transparent,
//               //           // MyColors().purpleColor,
//               //         ],
//               //         begin: Alignment.bottomCenter,
//               //         end: Alignment.topCenter,
//               //       ),
//               //     ),
//               //     child: Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //       children: [
//               //         Padding(
//               //           padding: EdgeInsets.symmetric(horizontal: 3.w)+EdgeInsets.only(top: 6.h),
//               //           child: Row(
//               //             children: [
//               //               GestureDetector(
//               //                 onTap: (){AppNavigation.navigatorPop(context);},
//               //                 child: Icon(
//               //                   Icons.arrow_back_ios_rounded,
//               //                   color: Colors.white,
//               //                   size: 18,
//               //                 ),
//               //               ),
//               //               SizedBox(width: 3.w),
//               //               StackedImage(seller: '',influencer: '',),
//               //               SizedBox(width: 2.w),
//               //               Expanded(
//               //                 child: Column(
//               //                   crossAxisAlignment: CrossAxisAlignment.start,
//               //                   mainAxisAlignment: MainAxisAlignment.start,
//               //                   children: [
//               //                     GestureDetector(
//               //                         onTap: (){
//               //                           AppNavigation.navigateTo( AppRouteName.SELLER_PROFILE_ROUTE,);
//               //                         },child: MyText(title: "John Smith",clr: MyColors().whiteColor,)),
//               //                     Row(
//               //                       children: [
//               //                         GestureDetector(
//               //                             onTap: (){
//               //                               AppNavigation.navigateTo( AppRouteName.SELLER_PROFILE_ROUTE,);
//               //                             },child: MyText(title: "
//               //                             Jacob Smith",clr: MyColors().whiteColor,size: 13,)),
//               //                         BorderedContainer(child:MyText(title: 'CLOTHS',clr: MyColors().purpleColor,size: 10,)),
//               //                       ],
//               //                     ),
//               //                   ],),
//               //               ),
//               //               BorderedContainer(child:MyText(title: '  LIVE  ',clr: MyColors().purpleColor,size: 10,)),
//               //               SizedBox(width: 2.w,),
//               //               BorderedContainer(child:Row(children: [
//               //                 Image.asset(ImagePath.eyeIcon,width: 5.w,),
//               //                 MyText(title: ' 59',clr: MyColors().purpleColor,size: 10,)
//               //               ],),),
//               //             ],
//               //           ),
//               //         ),
//               //
//               //         // SingleChildScrollView(
//               //         //   reverse: true,
//               //         //   physics: BouncingScrollPhysics(),
//               //         //   child: Container(
//               //         //     height: 40.h,width: 100.w,
//               //         //     decoration: BoxDecoration(
//               //         //       gradient: LinearGradient(
//               //         //         colors: [
//               //         //           MyColors().purpleColor.withOpacity(.8),
//               //         //           Colors.transparent,
//               //         //           // Colors.transparent,
//               //         //           // MyColors().purpleColor,
//               //         //         ],
//               //         //         begin: Alignment.bottomCenter,
//               //         //         end: Alignment.topCenter,
//               //         //       ),
//               //         //     ),
//               //         //   child: Padding(
//               //         //     padding: EdgeInsets.symmetric(horizontal: 3.w),
//               //         //     child: Column(children: [
//               //         //       Expanded(
//               //         //         child: ListView.builder(
//               //         //             physics: NeverScrollableScrollPhysics(),
//               //         //             shrinkWrap: true,
//               //         //             reverse: true,
//               //         //             itemCount: 3,
//               //         //             itemBuilder: (context,index){
//               //         //               return Column(
//               //         //                 children: [
//               //         //                   SizedBox(height: 2.h),
//               //         //                   Row(
//               //         //                     mainAxisAlignment: MainAxisAlignment.start,
//               //         //                     crossAxisAlignment: CrossAxisAlignment.start,
//               //         //                     children: [
//               //         //                       CustomImage(
//               //         //                         height: 4.5.h,
//               //         //                         width: 4.5.h,
//               //         //                         isProfile: true,
//               //         //                         photoView: false,
//               //         //                       ),
//               //         //                       SizedBox(width: 2.w),
//               //         //                       Expanded(
//               //         //                         child: Column(
//               //         //                           crossAxisAlignment: CrossAxisAlignment.start,
//               //         //                           mainAxisSize: MainAxisSize.min,
//               //         //                           children: [
//               //         //                             MyText(title: "James",clr: MyColors().whiteColor,),
//               //         //                             MyText(title: 'Lorem ipsum dolor sit amet consectetur adipiscing elit facilisi euismod.',clr:  MyColors().whiteColor,size: 12,fontWeight: FontWeight.w300),
//               //         //                           ],
//               //         //                         ),
//               //         //                       ),
//               //         //                     ],
//               //         //                   ),
//               //         //
//               //         //                 ],
//               //         //               );
//               //         //             }),
//               //         //       ),
//               //         //       SizedBox(height: 2.h),
//               //         //       _buildMessageComposer(),
//               //         //     ],),
//               //         //   ),),
//               //         // )
//               //         Container(
//               //           height: 40.h,width: 100.w,
//               //           padding: EdgeInsets.symmetric(horizontal: 3.w)+EdgeInsets.only(bottom: 1.h),
//               //           child: Column(
//               //             children: [
//               //               Expanded(
//               //                 child: ListView.builder(
//               //                   // physics: const NeverScrollableScrollPhysics(),
//               //                     physics: const BouncingScrollPhysics(),
//               //                     shrinkWrap: true,
//               //                     reverse: true,
//               //                     itemCount: 12,
//               //                     itemBuilder: (context,index){
//               //                       return Column(
//               //                         children: [
//               //                           SizedBox(height: 2.h),
//               //                           Row(
//               //                             mainAxisAlignment: MainAxisAlignment.start,
//               //                             crossAxisAlignment: CrossAxisAlignment.start,
//               //                             children: [
//               //                               CustomImage(
//               //                                 height: 4.5.h,
//               //                                 width: 4.5.h,
//               //                                 isProfile: true,
//               //                                 photoView: false,
//               //                               ),
//               //                               SizedBox(width: 2.w),
//               //                               Expanded(
//               //                                 child: Column(
//               //                                   crossAxisAlignment: CrossAxisAlignment.start,
//               //                                   mainAxisSize: MainAxisSize.min,
//               //                                   children: [
//               //                                     MyText(title: "James",clr: MyColors().whiteColor,),
//               //                                     MyText(title: 'Lorem ipsum dolor sit amet consectetur adipiscing elit facilisi euismod.',clr:  MyColors().whiteColor,size: 12,fontWeight: FontWeight.w300),
//               //                                   ],
//               //                                 ),
//               //                               ),
//               //                               IconButton(
//               //                                   onPressed: () {FocusManager.instance.primaryFocus?.unfocus();deleteComment(context);},
//               //                                   icon: Icon(Icons.more_vert_rounded,color: MyColors().whiteColor,))
//               //                             ],
//               //                           ),
//               //
//               //                         ],
//               //                       );
//               //                     }),
//               //               ),
//               //               _buildMessageComposer(),
//               //             ],
//               //           ),
//               //         ),
//               //
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         );
//       }
//     );
//   }
//   _buildMessageComposer({required RxInt p}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 3.w)+EdgeInsets.only(bottom: 1.h),
//       // alignment: Alignment.bottomCenter,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // if(user || seller)
//           //   GestureDetector(
//           //     onTap: (){
//           //       FocusManager.instance.primaryFocus?.unfocus();
//           //       if(user) {
//           //         getSellerProducts(loading: true);
//           //         showProducts(context);
//           //       } else{
//           //         AppNavigation.navigateTo( AppRouteName.PRODUCT_CATALOG_SCREEN_ROUTE);
//           //       }
//           //     },
//           //     child: Stack(
//           //       children: [
//           //         Container(
//           //           height: 6.h,
//           //           width: 6.h,
//           //           margin: EdgeInsets.only(right: 2.w,top: .5.h),
//           //           decoration: BoxDecoration(
//           //             shape: BoxShape.circle,
//           //             color: MyColors().whiteColor,
//           //           ),child: Image.asset(ImagePath.productIcon,color: MyColors().pinkColor,scale: 4,),
//           //         ),
//           //         Positioned(
//           //           right: -.01.w,
//           //           // top: 0.5.h,
//           //           child: CircleAvatar(
//           //             radius: 11,
//           //             backgroundColor: MyColors().pinkColor,
//           //             child:CircleAvatar(
//           //                 radius: 10,
//           //                 backgroundColor: MyColors().whiteColor,
//           //                 child:MyText(title: '$p',clr: MyColors().pinkColor,size: 10,)
//           //             ),
//           //           ),
//           //         ),
//           //
//           //       ],
//           //     ),
//           //   ),
//           Flexible(
//             child: Container(
//               padding: EdgeInsets.only(left: 5.w,),
//               margin: EdgeInsets.only(bottom: 0.h, top: .0.h,left: 2.w,right: 0),
//               // height: 60.0,
//               decoration: BoxDecoration(
//                   color: MyColors().whiteColor,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xffE8E6E7))),
//               child: Row(
//                 children: <Widget>[
//                   Flexible(
//                     child: TextField(
//                       textCapitalization: TextCapitalization.sentences,
//                       onChanged: (value) {},
//                       controller: message,
//                       style: const TextStyle(
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: 'Type your comment...',
//                         hintStyle:GoogleFonts.roboto(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 13,
//                           color: MyColors().greyColor,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   IconButton(onPressed: (){
//                     if(message.text.trim().isNotEmpty){
//                       onComment(context);
//                     }
//                   }, icon: Image.asset(ImagePath.send)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   onBack(){
//     AppNavigation.navigatorPop(context);
//   }
//   onComment(context){
//     var h = HomeController.i;
//     h.roomID=h.liveStreaming.value.roomId;
//     print('h.roomID');
//     print(h.roomID);
//
//     h.commentStreamingSocket(context, comment: message.text);
//     message.text='';
//   }
//   getData(){
//     HomeController.i.getSavedStreamMessages();
//   }
//   bool influencer =GlobalController.values.userRole.value == UserRole.influencer;
//
// }