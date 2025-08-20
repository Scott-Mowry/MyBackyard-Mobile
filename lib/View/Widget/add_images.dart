import 'dart:io';
import 'package:backyard/Service/api.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';

import '../../Model/file_network.dart';
import '../../Utils/image_path.dart';

class AddImages extends StatelessWidget {
  AddImages({Key? key,required this.imagePath,this.onTapAdd,this.onTapRemove,required this.editProfile}) : super(key: key);
  List<FileNetwork> imagePath = [];
  int tempLength = 3;
  bool editProfile;
  Function? onTapAdd, onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                if(onTapAdd!=null)
                {
                  onTapAdd!();
                }
              },
              child: Container(
                width: 100.w,
                height: 12.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  image: DecorationImage(
                      image: AssetImage(
                          ImagePath.dottedBorder,
                      ),
                    fit: BoxFit.fill
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImagePath.upload,scale: 4,color:editProfile?MyColors().secondaryColor:null,),
                    SizedBox(height: 1.h,),
                    MyText(title: 'Upload pictures',size: 12,clr: editProfile?MyColors().secondaryColor:MyColors().whiteColor,fontStyle: FontStyle.italic,),
                  ],
                ),
              )
          ),
          SizedBox(height: 2.h,),
          Wrap(children: List.generate(imagePath.length, (index) => Padding(
            padding:  EdgeInsets.symmetric(horizontal:2.w,vertical: 2.w),
            child: Container(
                width: 25.w,
                height: 25.w,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyColors().whiteColor,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: MyColors().primaryColor),
                    image: index < imagePath.length
                        ? DecorationImage(
                        image:( imagePath[index].isNetwork?NetworkImage(
                            API.public_url+imagePath[index].path
                        ): FileImage(
                          File(imagePath[index].path),
                        )) as ImageProvider,
                        fit: BoxFit.cover)
                        : null),
                child: index < imagePath.length
                    ? Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          if(onTapRemove!=null)
                          {
                            onTapRemove!();
                          }
                          imagePath.removeAt(index);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: MyColors().primaryColor,
                          size: 20,
                        )))
                    : const SizedBox()),
          )),)
        ],
      ),
    );
  }
}