import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/utils.dart';
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
  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: GeneralAPIS.getCategories,
      child: Consumer<HomeController>(
        builder: (context, val, _) {
          if (val.categories == null || val.categories!.isEmpty) {
            return Padding(
              padding: CustomSpacer.top.xl,
              child: Center(child: CustomEmptyData(title: 'No categories found', hasLoader: false)),
            );
          }

          return GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: Utils.isTablet ? 1.8 : 1.0,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.w,
            ),
            itemCount: val.categories?.length,
            shrinkWrap: true,
            padding: CustomSpacer.horizontal.md + CustomSpacer.top.xl,
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
                        () => context.pushRoute(TrendingOffersRoute(categoryId: val.categories?[index].id?.toString())),
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
          );
        },
      ),
    );
  }
}
