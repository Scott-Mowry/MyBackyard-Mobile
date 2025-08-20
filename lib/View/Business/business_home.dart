import 'dart:ui';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/offer_model.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/View/Widget/Dialog/reject_dialog.dart';
import 'package:backyard/View/Widget/search_tile.dart';
import 'package:flutter/material.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_empty_data.dart';
import 'package:sizer/sizer.dart';

class BusinessHome extends StatefulWidget {
  const BusinessHome({super.key});

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  TextEditingController s = TextEditingController();
  late final homeController = context.read<HomeController>();
  String search = "";

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
    homeController.setLoading(val);
  }

  Future<void> getOffers() async {
    await BusAPIS.getSavedOrOwnedOffers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
        // return Utils().onWillPop(context, currentBackPressTime: currentBackPressTime);
      },
      child: BaseView(
        bgImage: '',
        bottomSafeArea: false,
        topSafeArea: false,
        child: CustomRefresh(
          onRefresh: () => getOffers(),
          child: Consumer2<UserController, HomeController>(
              builder: (context, val, val2, _) {
            return CustomPadding(
              topPadding: 0.h,
              horizontalPadding: 0.w,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors().whiteColor,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          blurRadius: 10, // Spread of the shadow
                          spreadRadius: 5, // Size of the shadow
                          offset: const Offset(0, 4), // Position of the shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 7.h) +
                        EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomAppBar(
                          screenTitle: "Home",
                          leading: MenuIcon(),
                          trailing: NotificationIcon(),
                          bottom: 2.h,
                        ),
                        SearchTile(
                          showFilter: false,
                          // search: location,
                          onTap: () async {
                            // await getAddress(context);
                          },
                          onChange: (v) {
                            search = v;
                            val2.searchOffer(v);
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  if (val2.loading)
                    Column(
                      children: [
                        SizedBox(height: 20.h),
                        Center(
                          child: CircularProgressIndicator(
                              color: MyColors().greenColor),
                        ),
                      ],
                    )
                  else if ((val2.offers ?? []).isEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            Center(
                              child: CustomEmptyData(
                                title: 'No Offers Found',
                                hasLoader: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    (search.isNotEmpty
                        ? offerList(val2.searchOffers ?? [])
                        : offerList(val2.offers ?? []))
                  // Expanded(
                  //     child: ListView.builder(
                  //         // itemCount:s.length,
                  //         padding: EdgeInsets.symmetric(
                  //             horizontal: 3.w, vertical: 0.h),
                  //         physics: AlwaysScrollableScrollPhysics(
                  //             parent: const ClampingScrollPhysics()),
                  //         shrinkWrap: true,
                  //         itemBuilder: (_, index) => OfferTile()))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget offerList(List<Offer> val) {
    return Expanded(
        child: ListView(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (int index = 0; index < val.length; index++)
          OfferTile(model: val[index]),
        SizedBox(height: 5.h),
      ],
    ));
  }

  rejectDialog({required Function onTap}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
              content: RejectDialog(
                onYes: (v) {
                  onTap();
                },
              ),
            ),
          );
        });
  }
}
