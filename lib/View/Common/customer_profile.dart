import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/file_network.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Model/user_model.dart';

/// TO BE DELETED
/// Made separate profile for business as in ALfa there needs to be much handling

class CustomerProfile extends StatefulWidget {
  CustomerProfile({super.key, this.isMe = true, this.user});
  bool isMe = true;
  User? user;
  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  TextEditingController s = TextEditingController();
  final homeController = navigatorKey.currentContext?.read<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getOffers();
      setLoading(false);
    });
    // TODO: implement initState
    super.initState();
  }

  void setLoading(bool val) {
    homeController?.setLoading(val);
  }

  Future<void> getOffers() =>
      BusAPIS.getCustomerOffers(widget.user?.id.toString() ?? "");

  List<String> items = ['Contact Details', 'Offers & Discounts'];
  String i = 'Contact Details';
  List<FileNetwork> images = List<FileNetwork>.empty();
  bool business =
      true; //GlobalController.values.userRole.value == UserRole.business;

  @override
  Widget build(BuildContext context) {
    print(business);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BaseView(
        bgImage: '',
        child: CustomPadding(
          topPadding: 0.h,
          horizontalPadding: 3.w,
          child: Column(
            children: [
              CustomAppBar(
                screenTitle: widget.user?.name ?? "", leading: BackButton(),
                // trailing: business?null: Image.asset(ImagePath.favorite,scale: 2,color: MyColors().redColor,),
                bottom: 2.h,
              ),
              profileCard()
            ],
          ),
        ),
      ),
    );
  }

  profileCard() {
    return Consumer<HomeController>(builder: (context, val, _) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () => getOffers(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    // color: Colors.red,
                    color: MyColors().primaryColor,
                    shape: BoxShape.circle),
                height: 15.9.h,
                width: 15.9.h,
                alignment: Alignment.center,
                child: CustomImage(
                  height: 15.h,
                  width: 15.h,
                  isProfile: true,
                  photoView: false,
                  url: widget.user?.profileImage,
                  radius: 100,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 90.w,
                child: MyText(
                    title:
                        '${widget.user?.name ?? ""} ${widget.user?.lastName ?? ""}',
                    fontWeight: FontWeight.w500,
                    size: 18,
                    align: TextAlign.center,
                    toverflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                width: 90.w,
                child: MyText(
                    title: widget.user?.email ?? "",
                    size: 16,
                    align: TextAlign.center,
                    toverflow: TextOverflow.ellipsis),
              ),
              SizedBox(height: 1.5.h),
              const MyText(
                  title: 'Availed Offers',
                  size: 14,
                  fontWeight: FontWeight.w600),
              MyText(
                  title: widget.user?.offerCount?.toString() ?? "0",
                  size: 36,
                  clr: MyColors().primaryColor,
                  fontWeight: FontWeight.w600),
              SizedBox(
                height: 2.h,
              ),
              if (val.loading) ...[
                CircularProgressIndicator(color: MyColors().primaryColor)
              ] else
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics()),
                    child: Column(
                      children: [
                        if (val.customerOffers.isEmpty) ...[
                          SizedBox(height: 14.h),
                          CustomEmptyData(
                              title: "No Offer Found", hasLoader: true)
                        ] else ...[
                          ListView.builder(
                              itemCount: val.customerOffers.length,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0.h),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (_, index) =>
                                  OfferTile(model: val.customerOffers[index]))
                        ],
                      ],
                    ),
                  ),
                ),
              // Container(decoration: BoxDecoration(color: MyColors().primaryColor,borderRadius: BorderRadius.circular(30)),
              //   padding: EdgeInsets.all(12)+EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Image.asset(ImagePath.coins,scale: 2,),
              //       MyText(title: '  150',fontWeight: FontWeight.w600,size: 16,clr: MyColors().whiteColor),
              //     ],),
              // ),
              // MyText(title: u.value.fullName,fontWeight: FontWeight.w600,size: 18,),
              // SizedBox(
              //   height: 2.h,
              // ),

              // if (!business) ...[
              // Row(
              //   children: [
              //     sessionButton(title: items[0]),
              //     SizedBox(
              //       width: 3.w,
              //     ),
              //     sessionButton(title: items[1]),
              //   ],
              // ),
              // SizedBox(
              //   height: 2.h,
              // ),

              // if (i == items[0]) ...[
              //   Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: MyColors().container,
              //       borderRadius: BorderRadius.circular(8),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.2), // Shadow color
              //           blurRadius: 10, // Spread of the shadow
              //           spreadRadius: 2, // Size of the shadow
              //           offset: const Offset(0, 4), // Position of the shadow
              //         ),
              //       ],
              //     ),
              //     padding: EdgeInsets.all(3.w),
              //     child: Column(
              //       children: [
              //         // if(u.value.email!='')...[
              //         //                 userDetail(title: ImagePath.location,text: u.value.location?.address??''),
              //         // ],
              //         userDetail(
              //             title: 'Phone Number', text: '+1 234 567 890'),
              //         userDetail(
              //             title: 'Email Address', text: 'abcd@gmail.com'),
              //         userDetail(
              //             title: 'Address',
              //             text: '812 lorum street, dummy address, USA'),
              //       ],
              //     ),
              //   ),
              // ],
              // if (i == items[1]) ...[
              // ListView.builder(
              //     // itemCount:s.length,
              //     itemCount: 8,
              //     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemBuilder: (_, index) => OfferTile(
              //         // availed: true,
              //         )),
              // ],
              // SizedBox(
              //   height: 2.h,
              // ),
              // ],
            ],
          ),
        ),
      );
    });
  }

  userDetail({required String text, String title = ''}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment:
            title != '' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            title: title,
            size: 14,
            clr: MyColors().black,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: MyText(
                  title: text,
                  size: 14,
                )),
          ),
        ],
      ),
    );
  }

  sessionButton({required String title}) {
    return Expanded(
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? MyColors().primaryColor : MyColors().whiteColor,
        borderColor: MyColors().primaryColor,
        textColor: i == title ? null : MyColors().primaryColor,
        height: 5.2.h,
        width: 40.w,
      ),
    );
  }
}
