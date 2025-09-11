import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CategoriesView extends StatefulWidget {
  final bool wantKeepAlive;

  const CategoriesView({super.key, this.wantKeepAlive = false});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> with AutomaticKeepAliveClientMixin {
  TextEditingController s = TextEditingController();
  bool searchOn = false;
  List<MenuModel> categories = [
    MenuModel(name: 'Family Fun', image: ImagePath.familyFun),
    MenuModel(name: 'Home Services', image: ImagePath.homeServices),
    MenuModel(name: 'Food & Beverage', image: ImagePath.foodBeverage),
    MenuModel(name: 'Entertainment & Recreation', image: ImagePath.entertainRecreation),
    MenuModel(name: 'Retail & Boutique', image: ImagePath.retailBoutique),
    MenuModel(name: 'Liquor Stores', image: ImagePath.liquorStores),
    MenuModel(name: 'Flowers & Flower Services', image: ImagePath.flowerServices),
    MenuModel(name: 'Sports & Fitness', image: ImagePath.sportsFitness),
    MenuModel(name: 'General Retail', image: ImagePath.generalRetail),
    MenuModel(name: 'Bakery & coffee shop', image: ImagePath.bakeryCoffeeShop),
    MenuModel(name: 'Everything pets', image: ImagePath.everythingPets),
    MenuModel(name: 'Pool and Lawn Services', image: ImagePath.poolLawnServices),
    MenuModel(name: 'Health & Beauty', image: ImagePath.healthBeauty),
    MenuModel(name: 'Medical Services', image: ImagePath.medicalServices),
  ];

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => GeneralAPIS.getCategories());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        topSafeArea: false,
        bottomSafeArea: false,
        resizeBottomInset: false,
        child: CustomRefresh(
          onRefresh: GeneralAPIS.getCategories,
          child: Consumer<HomeController>(
            builder: (context, val, _) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.whiteColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          blurRadius: 10, // Spread of the shadow
                          spreadRadius: 5, // Size of the shadow
                          offset: const Offset(0, 4), // Position of the shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 7.h) + EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomAppBar(screenTitle: 'Offers & Discounts', leading: MenuIcon(), bottom: 2.h),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  if (val.categories == null)
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            Center(child: CustomEmptyData(title: 'No categories found', hasLoader: false)),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: Utils.isTablet ? 1.8 : 1.0,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 3.w,
                        ),
                        itemCount: val.categories?.length,
                        shrinkWrap: true,
                        padding: CustomSpacer.horizontal.md + CustomSpacer.top.xmd,
                        itemBuilder: (ctx, index) {
                          return Stack(
                            children: [
                              CustomImage(
                                width: 100.w,
                                height: 20.h,
                                borderRadius: BorderRadius.circular(10),
                                url: val.categories?[index].categoryIcon,
                              ),
                              GestureDetector(
                                onTap:
                                    () => context.pushRoute(
                                      SearchResultsRoute(categoryId: val.categories?[index].id?.toString()),
                                    ),
                                child: Container(
                                  width: 100.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF183400).withValues(alpha: .8),
                                        spreadRadius: 0,
                                        blurRadius: 0,
                                        offset: Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: MyText(
                                      title: val.categories?[index].categoryName ?? '',
                                      clr: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      size: Utils.isTablet ? 22 : 16,
                                      center: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
