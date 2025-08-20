import 'dart:io';
import 'package:backyard/Arguments/profile_screen_arguments.dart';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_height.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Service/bus_apis.dart';
// import 'package:backyard/Model/session_model.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/View/Widget/search_tile.dart';
import 'package:backyard/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:share_plus/share_plus.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

import 'offers.dart';

class SearchResultArguments {
  const SearchResultArguments({this.categoryId});
  final String? categoryId;
}

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, this.categoryId});
  final String? categoryId;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<String> i = [
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
  ];
  late final homeController =
      navigatorKey.currentContext?.read<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getTrendingOffers();
      setLoading(false);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> getTrendingOffers() async {
    await BusAPIS.getTrendingOffers(widget.categoryId ?? "");
  }

  void setLoading(bool val) {
    homeController?.setLoading(val);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Search Result',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        // backgroundColor: Colors.white,
        child: CustomPadding(
          horizontalPadding: 0.w,
          topPadding: 0,
          child: Consumer2<HomeController, UserController>(
              builder: (context, val, val2, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTile(showFilter: false),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyText(
                        title: 'Nearby Business',
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
                if (val2.loading)
                  Center(
                    child:
                        CircularProgressIndicator(color: MyColors().greenColor),
                  )
                else if (val2.busList.isEmpty)
                  Center(
                    child: CustomEmptyData(
                      title: 'No Nearby Business Found',
                      hasLoader: false,
                    ),
                  )
                else
                  CustomHeight(
                      prototype: businessTile(context: context),
                      listView: ListView.builder(
                          itemCount: val2.busList.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.h),
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: ClampingScrollPhysics()),
                          shrinkWrap: true,
                          itemBuilder: (_, index) => businessTile(
                              user: val2.busList[index], context: context))),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                  child: const MyText(
                    title: 'Trending Offers',
                    size: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // offerList(),
                if (val.loading)
                  Center(
                    child:
                        CircularProgressIndicator(color: MyColors().greenColor),
                  )
                else if ((val.offers ?? []).isEmpty)
                  Center(
                    child: CustomEmptyData(
                      title: 'No Trending Offers Found',
                      hasLoader: false,
                    ),
                  )
                else
                  Expanded(
                      child: ListView.builder(
                          itemCount: val.offers?.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.h),
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: ClampingScrollPhysics()),
                          shrinkWrap: true,
                          itemBuilder: (_, index) =>
                              OfferTile(model: val.offers?[index])))
              ],
            );
          }),
        ));
  }

  Widget offerList() {
    return Expanded(
        child: ListView.builder(
            // itemCount:s.length,
            itemCount: 10,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
            physics: AlwaysScrollableScrollPhysics(
                parent: const ClampingScrollPhysics()),
            shrinkWrap: true,
            itemBuilder: (_, index) => OfferTile()));
  }

  businessTile({User? user, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: () {
          // HomeController.i.endUser.value=u??User();
          AppNavigation.navigateTo(AppRouteName.USER_PROFILE_ROUTE,
              arguments: ProfileScreenArguments(
                  isBusinessProfile: true,
                  isMe: false,
                  isUser: false,
                  user: user));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset(
            //   img ?? ImagePath.random1,
            //   scale: 2,
            // ),
            CustomImage(
                photoView: false,
                width: 30.w,
                height: 10.h,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10),
                url: user?.profileImage),
            SizedBox(
              height: 1.h,
            ),
            MyText(title: user?.name ?? "")
          ],
        ),
      ),
    );
  }
}
