import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageGalleryClass {
  ImagePicker picker = ImagePicker();
  XFile? getFilePath;
  CroppedFile? croppedImageFile;
  File? imageFile;

  Map<String, dynamic>? imageGalleryBottomSheet(
      {required BuildContext context,
      required ValueChanged<String?> onMediaChanged,
      bool? multiImage,
      bool? showFile = false}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.black,
        context: context,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
                // color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: SafeArea(
              child: Wrap(
                children: <Widget>[
                  //getCameraImage
                  GestureDetector(
                    onTap: () {
                      getCameraImage(
                        onMediaChanged: onMediaChanged,
                        context: context,
                        fromCreateFeed: false,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.0,
                          ),
                          Icon(
                            Icons.camera_enhance,
                            color: MyColors().primaryColor,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(
                                color: MyColors().primaryColor, fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  // const Divider(
                  //   color: AppColors.whiteColor,
                  //   height: 1.0,
                  // ),
                  //getGalleryImage
                  GestureDetector(
                    onTap: () {
                      // multiImage == true
                      //     ? getMultipleImages(
                      //         onMediaChanged: onMediaChanged, context: context)
                      //     :
                      getGalleryImage(
                          onMediaChanged: onMediaChanged, context: context);
                      //AppNavigation.navigatorPop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.0,
                          ),
                          Icon(
                            Icons.image,
                            color: MyColors().primaryColor,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(
                                color: MyColors().primaryColor, fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///// FILE UPLOAD //////////
                  if (showFile == true) ...[
                    //getPdfFile
                    GestureDetector(
                      onTap: () {
                        print("pdf");
                        getPdfFile(
                            onMediaChanged: onMediaChanged, context: context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Icon(
                              Icons.file_copy_sharp,
                              color: MyColors().primaryColor,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "File",
                              style: TextStyle(
                                  color: MyColors().primaryColor,
                                  fontSize: 18.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        });
    return null;
  }

  void getPdfFile(
      {required ValueChanged<String?> onMediaChanged,
      BuildContext? context}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "doc"],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        print(file.name);
        print("Bytes ${file.bytes}");
        print("Size ${file.size}");
        print(file.extension);
        print(file.path);
        onMediaChanged(file.path);
        //AppNavigation.navigatorPop();
      }
    } on PlatformException catch (e) {
      CustomToast().showToast(message: e.message ?? 'Something went wrong.');
    }
  }

  void getCameraImage({
    required ValueChanged<String?> onMediaChanged,
    BuildContext? context,
    bool? fromCreateFeed = false,
  }) async {
    try {
      final getFilePath = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (getFilePath != null) {
        cropImage(
          imageFilePath: getFilePath.path,
          onMediaChanged: onMediaChanged,
          context: context,
          fromCreateFeed: fromCreateFeed,
        );
      } else {
        // Handle the case when the image capture was canceled or failed.
        if (fromCreateFeed != null && !fromCreateFeed) {
          AppNavigation.navigatorPop();
        }
      }
    } on PlatformException catch (e) {
      // Handle any platform-specific exceptions.
    }
  }

  void getGalleryImage(
      {required ValueChanged<String?> onMediaChanged,
      BuildContext? context,
      bool? fromCreateFeed = false}) async {
    try {
      getFilePath =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (getFilePath != null) {
        cropImage(
            imageFilePath: getFilePath!.path,
            onMediaChanged: onMediaChanged,
            context: context,
            fromCreateFeed: fromCreateFeed);
      } else {
        fromCreateFeed! ? null : AppNavigation.navigatorPop();
        // AppNavigation.navigatorPop();
      }
    } on PlatformException catch (e) {
      // CustomToast().showToast(
      //     message: e.message ?? AppStrings.SOMETHING_WENT_WRONG_ERROR);
    }
  }

  void getMultipleImages(
      {required ValueChanged<List<String?>?> onMediaChanged,
      required BuildContext context}) async {
    try {
      // getFilePath =
      List<XFile> multiImages = await picker.pickMultiImage(imageQuality: 80);
      List<String> multiImagesPath = [];
      //print("Multi Images:${multiImages.length}");
      if (multiImages.length > 0) {
        for (int i = 0; i < multiImages.length; i++) {
          multiImagesPath.add(multiImages[i].path);
        }
      }
      //print("Multi Images PAth:${multiImagesPath.length}");
      onMediaChanged(multiImagesPath);
      AppNavigation.navigatorPop();
    } on PlatformException {
      // CustomToast().showToast(
      //     message: e.message ?? AppStrings.SOMETHING_WENT_WRONG_ERROR);
    }
  }

  void cropImage({
    String? imageFilePath,
    BuildContext? context,
    required ValueChanged<String?> onMediaChanged,
    bool? fromCreateFeed,
  }) async {
    final croppedImageFile = await ImageCropper().cropImage(
      sourcePath: imageFilePath!,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: <PlatformUiSettings>[
        // Create a list of PlatformUiSettings
        AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    // await ImageCropper().cropImage(
    //   sourcePath: imageFilePath!,
    //   // aspectRatioPresets: [
    //   //   CropAspectRatioPreset.square,
    //   //   CropAspectRatioPreset.ratio3x2,
    //   //   CropAspectRatioPreset.original,
    //   //   CropAspectRatioPreset.ratio4x3,
    //   //   CropAspectRatioPreset.ratio16x9,
    //   // ],
    //   uiSettings: <PlatformUiSettings>[
    //     // Create a list of PlatformUiSettings
    //     AndroidUiSettings(
    //       toolbarTitle: 'Edit Photo',
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: false,
    //       aspectRatioPresets: [
    //     CropAspectRatioPreset.square,
    //     CropAspectRatioPreset.ratio3x2,
    //     CropAspectRatioPreset.original,
    //     CropAspectRatioPreset.ratio4x3,
    //     CropAspectRatioPreset.ratio16x9,
    //   ],
    //     ),IOSUiSettings(aspectRatioPresets: [
    //     CropAspectRatioPreset.square,
    //     CropAspectRatioPreset.ratio3x2,
    //     CropAspectRatioPreset.original,
    //     CropAspectRatioPreset.ratio4x3,
    //     CropAspectRatioPreset.ratio16x9,
    //   ],)
    //   ],
    // );

    if (croppedImageFile != null) {
      onMediaChanged(File(croppedImageFile.path).path);
    } else {
      onMediaChanged(null);
    }

    if (context != null) {
      AppNavigation.navigatorPop();
    }
  }
}
