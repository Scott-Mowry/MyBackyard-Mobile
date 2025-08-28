import 'package:auto_route/annotations.dart';
import 'package:backyard/boot.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Arguments/profile_screen_arguments.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_height.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
// import 'package:backyard/legacy/Model/session_model.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/User/offers.dart';
import 'package:backyard/legacy/View/Widget/search_tile.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchResultsArgs {
  const SearchResultsArgs({this.categoryId});
  final String? categoryId;
}

@RoutePage()
class SearchResultsView extends StatefulWidget {
  const SearchResultsView({super.key, this.categoryId});
  final String? categoryId;

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  List<String> i = [
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
  ];
  late final homeController = navigatorKey.currentContext?.read<HomeController>();

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
    await BusAPIS.getTrendingOffers(widget.categoryId ?? '');
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
                      SizedBox(height: 2.h),
                      MyText(title: 'Nearby Business', size: 16, fontWeight: FontWeight.w600),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
                if (val2.loading)
                  Center(child: CircularProgressIndicator(color: CustomColors.greenColor))
                else if (val2.busList.isEmpty)
                  Center(child: CustomEmptyData(title: 'No Nearby Business Found', hasLoader: false))
                else
                  CustomHeight(
                    prototype: businessTile(context: context),
                    listView: ListView.builder(
                      itemCount: val2.busList.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                      shrinkWrap: true,
                      itemBuilder: (_, index) => businessTile(user: val2.busList[index], context: context),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                  child: const MyText(title: 'Trending Offers', size: 16, fontWeight: FontWeight.w600),
                ),
                // offerList(),
                if (val.loading)
                  Center(child: CircularProgressIndicator(color: CustomColors.greenColor))
                else if ((val.offers ?? []).isEmpty)
                  Center(child: CustomEmptyData(title: 'No Trending Offers Found', hasLoader: false))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: val.offers?.length,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                      shrinkWrap: true,
                      itemBuilder: (_, index) => OfferTile(model: val.offers?[index]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget offerList() {
    return Expanded(
      child: ListView.builder(
        // itemCount:s.length,
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
        physics: AlwaysScrollableScrollPhysics(parent: const ClampingScrollPhysics()),
        shrinkWrap: true,
        itemBuilder: (_, index) => OfferTile(),
      ),
    );
  }

  Padding businessTile({User? user, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: () {
          // HomeController.i.endUser.value=u??User();
          AppNavigation.navigateTo(
            AppRouteName.USER_PROFILE_VIEW_ROUTE,
            arguments: ProfileScreenArguments(isBusinessProfile: true, isMe: false, isUser: false, user: user),
          );
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
              url: user?.profileImage,
            ),
            SizedBox(height: 1.h),
            MyText(title: user?.name ?? ''),
          ],
        ),
      ),
    );
  }
}
