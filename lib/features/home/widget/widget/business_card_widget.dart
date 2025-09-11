import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
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
            if (business.profileImage != null && business.profileImage!.isNotEmpty)
              CustomImage(
                width: 76.w,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10),
                url: business.profileImage,
              ),
            Expanded(
              child: Padding(
                padding: CustomSpacer.left.sm + CustomSpacer.vertical.xs,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            business.name ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                          ),
                        ),
                        if (category?.categoryName != null && category!.categoryName!.isNotEmpty)
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: CustomSpacer.left.xs,
                              child: Container(
                                padding: CustomSpacer.horizontal.xs + CustomSpacer.vertical.xxs,
                                decoration: BoxDecoration(
                                  color: CustomColors.primaryGreenColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  category!.categoryName?.split(' ').firstOrNull ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: CustomTextStyle.labelSmall.copyWith(color: CustomColors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: CustomSpacer.top.xxs,
                      child: Row(
                        children: [
                          Image.asset(
                            ImagePath.location,
                            color: CustomColors.primaryGreenColor,
                            height: 18,
                            fit: BoxFit.fitHeight,
                          ),
                          Flexible(
                            child: Padding(
                              padding: CustomSpacer.left.xxs,
                              child: Text(
                                business.address ?? 'Unknown',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                fontSize: 12,
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
                          maxLines: 2,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
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
