import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/address_info_widget.dart';
import 'package:backyard/core/design_system/widgets/category_name_widget.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessCardWidget extends StatelessWidget {
  final UserProfileModel business;
  final CategoryModel? category;

  const BusinessCardWidget({super.key, required this.business, this.category});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(CustomRadius.s);
    final imageWidth = 76.w;
    return Card(
      elevation: 1,
      color: CustomColors.white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.pushRoute<void>(
            UserProfileRoute(isBusinessProfile: true, isMe: false, isUser: false, user: business),
          );
        },
        borderRadius: borderRadius,
        child: Row(
          children: [
            SizedBox(
              width: imageWidth,
              child: Stack(
                children: [
                  if (business.profileImage != null && business.profileImage!.isNotEmpty)
                    CustomImage(
                      width: imageWidth,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(10),
                      url: business.profileImage,
                    ),
                  if (category?.categoryName != null && category!.categoryName!.isNotEmpty)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: CustomSpacer.top.xxs,
                        child: CategoryNameWidget(name: category!.categoryName!.split(' ').first, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: CustomSpacer.left.xxs + CustomSpacer.all.xs,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name ?? 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                    ),
                    Padding(padding: CustomSpacer.top.xxs, child: AddressInfoWidget(address: business.address ?? '')),
                    Padding(
                      padding: CustomSpacer.top.xxs,
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: CustomColors.primaryGreenColor, size: 18),
                          Padding(
                            padding: CustomSpacer.left.xxs,
                            child: Text(
                              business.phone ?? 'Unknown',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (business.description != null && business.description!.isNotEmpty)
                      Padding(
                        padding: CustomSpacer.top.xs,
                        child: Text(
                          business.description!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
      ),
    );
  }
}
