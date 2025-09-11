import 'dart:io';

import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Model/file_network.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddImages extends StatelessWidget {
  final List<FileNetwork> imagePath;
  final int tempLength = 3;
  final bool editProfile;
  final Function? onTapAdd;
  final Function? onTapRemove;

  const AddImages({super.key, required this.imagePath, this.onTapAdd, this.onTapRemove, required this.editProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (onTapAdd != null) {
                onTapAdd!();
              }
            },
            child: Container(
              width: 100.w,
              height: 12.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(image: AssetImage(ImagePath.dottedBorder), fit: BoxFit.fill),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.upload, scale: 4, color: editProfile ? CustomColors.secondaryColor : null),
                  SizedBox(height: 1.h),
                  MyText(
                    title: 'Upload pictures',
                    size: 12,
                    clr: editProfile ? CustomColors.secondaryColor : CustomColors.whiteColor,
                    fontStyle: FontStyle.italic,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            children: List.generate(
              imagePath.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CustomColors.whiteColor,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: CustomColors.primaryGreenColor),
                    image:
                        index < imagePath.length
                            ? DecorationImage(
                              image:
                                  (imagePath[index].isNetwork
                                          ? NetworkImage(API.publicUrl + imagePath[index].path)
                                          : FileImage(File(imagePath[index].path)))
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      index < imagePath.length
                          ? Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                if (onTapRemove != null) {
                                  onTapRemove!();
                                }
                                imagePath.removeAt(index);
                              },
                              child: Icon(Icons.cancel, color: CustomColors.primaryGreenColor, size: 20),
                            ),
                          )
                          : const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
