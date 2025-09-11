import 'package:auto_route/annotations.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/features/offers/offer_card_widget.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Model/file_network.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class CustomerProfileView extends StatefulWidget {
  final bool isMe;
  final UserProfileModel? user;

  const CustomerProfileView({super.key, this.isMe = true, this.user});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  TextEditingController s = TextEditingController();
  late final homeController = context.read<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => BusinessAPIS.getCustomerOffers(widget.user?.id.toString() ?? ''),
    );
  }

  List<String> items = ['Contact Details', 'Offers & Discounts'];
  String i = 'Contact Details';
  List<FileNetwork> images = List<FileNetwork>.empty();
  bool business = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        child: CustomPadding(
          topPadding: 0.h,
          horizontalPadding: 3.w,
          child: Column(
            children: [
              CustomAppBar(screenTitle: widget.user?.name ?? '', leading: BackButton(), bottom: 2.h),
              profileCard(),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<HomeController> profileCard() {
    return Consumer<HomeController>(
      builder: (context, val, _) {
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () => BusinessAPIS.getCustomerOffers(widget.user?.id.toString() ?? ''),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    color: CustomColors.primaryGreenColor,
                    shape: BoxShape.circle,
                  ),
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
                SizedBox(height: 2.h),
                SizedBox(
                  width: 90.w,
                  child: MyText(
                    title: '${widget.user?.name ?? ""}',
                    fontWeight: FontWeight.w500,
                    size: 18,
                    align: TextAlign.center,
                    toverflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 90.w,
                  child: MyText(
                    title: widget.user?.email ?? '',
                    size: 16,
                    align: TextAlign.center,
                    toverflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 1.5.h),
                const MyText(title: 'Availed Offers', size: 14, fontWeight: FontWeight.w600),
                MyText(
                  title: widget.user?.offerCount?.toString() ?? '0',
                  size: 36,
                  clr: CustomColors.primaryGreenColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 2.h),
                if (val.customerOffers.isEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Center(child: CustomEmptyData(title: 'No Offers Found', hasLoader: false)),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: val.customerOffers.length,
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.h),
                      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: CustomSpacer.top.md,
                          child: OfferCardWidget(offer: val.customerOffers[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding userDetail({required String text, String title = ''}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: title != '' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title: title, size: 14, clr: CustomColors.black, fontWeight: FontWeight.w600),
          SizedBox(width: 2.w),
          Expanded(child: Align(alignment: Alignment.centerRight, child: MyText(title: text, size: 14))),
        ],
      ),
    );
  }

  Expanded sessionButton({required String title}) {
    return Expanded(
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? CustomColors.primaryGreenColor : CustomColors.whiteColor,
        borderColor: CustomColors.primaryGreenColor,
        textColor: i == title ? null : CustomColors.primaryGreenColor,
        height: 5.2.h,
        width: 40.w,
      ),
    );
  }
}
