import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_dropdown.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/category_product_model.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Widget/Dialog/custom_dialog.dart';
import 'package:backyard/legacy/View/Widget/upload_media.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class CreateOfferView extends StatefulWidget {
  final bool edit;
  final Offer? model;
  final bool wantKeepAlive;

  const CreateOfferView({super.key, this.edit = false, this.model, this.wantKeepAlive = false});

  @override
  State<CreateOfferView> createState() => _CreateOfferViewState();
}

class _CreateOfferViewState extends State<CreateOfferView> with AutomaticKeepAliveClientMixin {
  File permit = File('');
  final form = GlobalKey<FormState>();
  bool error = false;
  final titleController = TextEditingController();
  final discountController = TextEditingController();
  final rewardPointsController = TextEditingController();
  final shortDetailController = TextEditingController();
  final descriptionController = TextEditingController();
  final actualPriceController = TextEditingController();

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getCategories();
      setLoading(false);
      if (widget.edit) {
        selected =
            context
                .read<HomeController>()
                .categories
                ?.where((element) => element.id == widget.model?.category?.id)
                .firstOrNull;
        setState(() {});
      }
    });
    if (widget.edit) {
      titleController.text = widget.model?.title ?? '';
      discountController.text = widget.model?.discountPrice?.toString() ?? '';
      rewardPointsController.text = widget.model?.rewardPoints?.toString() ?? '';
      shortDetailController.text = widget.model?.shortDetail ?? '';
      descriptionController.text = widget.model?.description ?? '';
      actualPriceController.text = widget.model?.actualPrice?.toString() ?? '';
    }
    // TODO: implement initState
    super.initState();

    // getData();
  }

  Future<void> getCategories() async {
    await GeneralAPIS.getCategories();
  }

  void setLoading(bool val) => context.read<HomeController>().setLoading(val);

  List<Category> categories = [
    Category(id: 'Category 1', categoryName: 'Category 1'),
    Category(id: 'Category 2', categoryName: 'Category 2'),
    Category(id: 'Category 3', categoryName: 'Category 3'),
  ];
  CategoryModel? selected;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        bottomSafeArea: false,
        child: CustomRefresh(
          onRefresh: () async {
            await getCategories();
          },
          child: CustomPadding(
            topPadding: 0.h,
            horizontalPadding: 3.w,
            child: Consumer<HomeController>(
              builder: (context, val, _) {
                return val.loading
                    ? Center(child: CircularProgressIndicator(color: CustomColors.primaryGreenColor))
                    : Column(
                      children: [
                        CustomAppBar(
                          screenTitle: widget.edit ? 'Edit Offer' : 'Create Offer',
                          leading: MenuIcon(),
                          bottom: 2.h,
                        ),
                        // Wrap(children: List.generate(, (index) => )),
                        SizedBox(height: 2.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  permit.path != ''
                                      ? GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus?.unfocus();

                                          ImageGalleryClass().imageGalleryBottomSheet(
                                            context: context,
                                            onMediaChanged: (val) {
                                              if (val != null) {
                                                permit = File(val);
                                              }
                                            },
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: DottedBorder(
                                            // borderType: BorderType.RRect,
                                            // color:
                                            //     MyColors().secondaryColor,
                                            // dashPattern: [6, 6, 6, 6],
                                            // strokeWidth: 2,
                                            // radius: Radius.circular(12),
                                            // padding: EdgeInsets.all(6),
                                            options: RectDottedBorderOptions(
                                              color: CustomColors.secondaryColor,
                                              padding: EdgeInsets.all(6),
                                              strokeWidth: 2,
                                              dashPattern: [6, 6, 6, 6],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              child: Container(
                                                width: 100.w,
                                                height: 12.h,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        (permit.path == ''
                                                                ?
                                                                // AuthController.i.user.value.permit!=''?
                                                                // NetworkImage(APIEndpoints.baseImageURL+AuthController.i.user.value.permit) :
                                                                const AssetImage(ImagePath.noUserImage)
                                                                : FileImage(permit))
                                                            as ImageProvider,
                                                  ),
                                                  //   color: MyColors().secondaryColor.withValues(alpha: .26),
                                                  // border: Border.all(
                                                  //   color: MyColors().secondaryColor
                                                  // )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      // DottedBorder(
                                      //   options: RectDottedBorderOptions(
                                      //     color: MyColors().secondaryColor,
                                      //     padding: EdgeInsets.all(6),
                                      //     strokeWidth: 2,
                                      //     dashPattern: [6, 6, 6, 6],
                                      //   ),
                                      //   child: ClipRRect(
                                      //     borderRadius: BorderRadius.all(
                                      //       Radius.circular(12),
                                      //     ),
                                      //     child: Container(
                                      //       width: 100.w,
                                      //       height: 12.h,
                                      //       decoration: BoxDecoration(
                                      //         image: DecorationImage(
                                      //           fit: BoxFit.cover,
                                      //           image:
                                      //               (permit.path == ""
                                      //                       ?
                                      //                       // AuthController.i.user.value.permit!=''?
                                      //                       // NetworkImage(APIEndpoints.baseImageURL+AuthController.i.user.value.permit) :
                                      //                       const AssetImage(
                                      //                         ImagePath
                                      //                             .noUserImage,
                                      //                       )
                                      //                       : FileImage(
                                      //                         permit,
                                      //                       ))
                                      //                   as ImageProvider,
                                      //         ),
                                      //         //   color: MyColors().secondaryColor.withValues(alpha: .26),
                                      //         // border: Border.all(
                                      //         //   color: MyColors().secondaryColor
                                      //         // )
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // ),
                                      // )
                                      :
                                      // AuthController.i.user.value.permit!=''?
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     FocusManager.instance.primaryFocus?.unfocus();
                                      //     Get.bottomSheet(
                                      //       UploadMedia(
                                      //         file: (val) {
                                      //           permit.value = val!;
                                      //         },
                                      //         singlePick: true,
                                      //       ),
                                      //       isScrollControlled: true,
                                      //       backgroundColor: Theme
                                      //           .of(context)
                                      //           .selectedRowColor,
                                      //       shape: const RoundedRectangleBorder(
                                      //           borderRadius: BorderRadius.only(
                                      //               topLeft: Radius.circular(20),
                                      //               topRight: Radius.circular(20)
                                      //           )
                                      //       ),
                                      //     );
                                      //   },
                                      //   child: DottedBorder(
                                      //     borderType: BorderType.RRect,
                                      //     color: MyColors().primaryColor,
                                      //     dashPattern: [6, 6, 6, 6],
                                      //     strokeWidth: 2,
                                      //     radius: Radius.circular(12),
                                      //     padding: EdgeInsets.all(6),
                                      //     child: ClipRRect(
                                      //       borderRadius: BorderRadius.all(Radius.circular(12)),
                                      //       child: Container(
                                      //         width: 100.w,
                                      //         height: 12.h,
                                      //         decoration: BoxDecoration(
                                      //           image: DecorationImage(
                                      //               fit: BoxFit.cover,
                                      //               image:
                                      //               (permit.value.path == ""?
                                      //               AuthController.i.user.value.permit!=''?
                                      //               NetworkImage(APIEndpoints.baseImageURL+AuthController.i.user.value.permit) :
                                      //               const AssetImage(ImagePath.noUserImage) :
                                      //               FileImage(permit.value)) as ImageProvider
                                      //           ),
                                      //           //   color: MyColors().secondaryColor.withValues(alpha: .26),
                                      //           // border: Border.all(
                                      //           //   color: MyColors().secondaryColor
                                      //           // )
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ):
                                      (widget.model?.image != null)
                                      ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CustomImage(width: 100.w, height: 12.h, url: widget.model?.image),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              ImageGalleryClass().imageGalleryBottomSheet(
                                                context: context,
                                                onMediaChanged: (val) {
                                                  if (val != null) {
                                                    permit = File(val);
                                                    setState(() {});
                                                  }
                                                },
                                              );
                                            },
                                            child: Opacity(
                                              opacity: .7,
                                              child: CircleAvatar(
                                                backgroundColor: CustomColors.primaryGreenColor,
                                                child: const Icon(Icons.close, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : uploadMedia(),
                                  if (error)
                                    const Text(
                                      "Upload Image can't be empty",
                                      style: TextStyle(height: 1, color: Colors.red),
                                    ),
                                  SizedBox(height: 2.h),
                                  customTitle(title: 'Title'),
                                  SizedBox(height: 1.h),
                                  CustomTextFormField(
                                    hintText: 'Title',
                                    controller: titleController,
                                    maxLength: 32,
                                    showLabel: false,
                                    backgroundColor: CustomColors.container,
                                    validation: (p0) => p0?.validateEmpty('Title'),
                                    // borderColor: MyColors().secondaryColor,
                                    // hintTextColor: MyColors().grey,
                                    // textColor: MyColors().black,
                                  ),
                                  SizedBox(height: 2.h),
                                  customTitle(title: 'Select Category'),
                                  SizedBox(height: 1.h),
                                  CustomDropDown2(
                                    hintText: 'Select Category',
                                    bgColor: CustomColors.container,
                                    dropDownData: val.categories,
                                    dropdownValue: selected,
                                    validator: (p0) => (p0 == null) ? "Category can't be empty" : null,
                                    onChanged: (v) {
                                      selected = v;
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(height: 2.h),
                                  customTitle(title: 'Actual Price'),
                                  SizedBox(height: 1.h),
                                  CustomTextFormField(
                                    hintText: 'Actual Price',
                                    controller: actualPriceController,
                                    maxLength: 6,
                                    inputType: const TextInputType.numberWithOptions(decimal: true),
                                    showLabel: false,
                                    numberWithDecimal: true,
                                    backgroundColor: CustomColors.container,
                                    validation: (p0) => p0?.validateEmpty('Actual Price'),
                                    // borderColor: MyColors().secondaryColor,
                                    // hintTextColor: MyColors().grey,
                                    // textColor: MyColors().black,
                                  ),
                                  SizedBox(height: 2.h),
                                  customTitle(title: 'Discount Price'),
                                  SizedBox(height: 1.h),
                                  CustomTextFormField(
                                    hintText: 'Discount Price',
                                    controller: discountController,
                                    maxLength: 6,
                                    inputType: const TextInputType.numberWithOptions(decimal: true),
                                    showLabel: false,
                                    numberWithDecimal: true,
                                    backgroundColor: CustomColors.container,
                                    validation: (p0) => p0?.validateEmpty('Discount Price'),
                                    // borderColor: MyColors().secondaryColor,
                                    // hintTextColor: MyColors().grey,
                                    // textColor: MyColors().black,
                                  ),
                                  SizedBox(height: 2.h),

                                  // customTitle(
                                  //   title: 'Reward Points',
                                  // ),
                                  // SizedBox(
                                  //   height: 1.h,
                                  // ),
                                  // MyTextField(
                                  //   hintText: 'Reward Points',
                                  //   controller: rewardPointsController,
                                  //   maxLength: 6,
                                  //   inputType: TextInputType.number,
                                  //   showLabel: false,
                                  //   onlyNumber: true,
                                  //   backgroundColor: MyColors().container,
                                  //                     //   validation: (p0) =>
                                  //       p0?.validateEmpty("Reward Points"),
                                  //   // borderColor: MyColors().secondaryColor,
                                  //   // hintTextColor: MyColors().grey,
                                  //   // textColor: MyColors().black,
                                  // ),
                                  // SizedBox(
                                  //   height: 2.h,
                                  // ),
                                  customTitle(title: 'Short Details'),
                                  SizedBox(height: 1.h),
                                  CustomTextFormField(
                                    height: 8.h,
                                    hintText: 'Short Details',
                                    showLabel: false,
                                    maxLines: 5,
                                    minLines: 5,
                                    controller: shortDetailController,
                                    validation: (p0) => p0?.validateEmpty('Short Detail'),
                                    borderRadius: 10,
                                    maxLength: 275,
                                    backgroundColor: CustomColors.container,
                                  ),
                                  SizedBox(height: 2.h),
                                  customTitle(title: 'Description'),
                                  SizedBox(height: 1.h),
                                  CustomTextFormField(
                                    height: 8.h,
                                    hintText: 'Description',
                                    showLabel: false,
                                    maxLines: 5,
                                    minLines: 5,
                                    controller: descriptionController,
                                    validation: (p0) => p0?.validateEmpty('Description'),
                                    borderRadius: 10,
                                    maxLength: 275,
                                    backgroundColor: CustomColors.container,
                                  ),
                                  SizedBox(height: 2.h),
                                  MyButton(
                                    title: widget.edit ? 'Update' : 'Continue',
                                    onTap: () async {
                                      if (!widget.edit) {
                                        setState(() {
                                          error = permit.path.isEmpty;
                                        });
                                      }
                                      if ((form.currentState?.validate() ?? false) && !error) {
                                        if (widget.edit) {
                                          getIt<AppNetwork>().loadingProgressIndicator();
                                          final val = await BusAPIS.editOffer(
                                            offerId: widget.model?.id?.toString(),
                                            title: titleController.text,
                                            categoryId: selected?.id?.toString() ?? '',
                                            actualPrice: actualPriceController.text,
                                            discountPrice: discountController.text,
                                            rewardPoints: '2',
                                            shortDetail: shortDetailController.text,
                                            desc: descriptionController.text,
                                            image: permit,
                                          );
                                          context.maybePop();
                                          if (val) {
                                            context.maybePop();
                                            context.maybePop();
                                          }
                                        } else {
                                          getIt<AppNetwork>().loadingProgressIndicator();
                                          final val = await BusAPIS.addOffer(
                                            title: titleController.text,
                                            categoryId: selected?.id?.toString() ?? '',
                                            actualPrice: actualPriceController.text,
                                            discountPrice: discountController.text,
                                            rewardPoints: '2',
                                            shortDetail: shortDetailController.text,
                                            desc: descriptionController.text,
                                            image: permit,
                                          );
                                          context.maybePop();
                                          if (val) {
                                            titleController.text = widget.model?.title ?? '';
                                            discountController.clear();
                                            rewardPointsController.clear();
                                            shortDetailController.clear();
                                            descriptionController.clear();
                                            actualPriceController.clear();
                                            selected = null;
                                            setState(() {});
                                            completeDialog();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                  SizedBox(height: 3.h),
                                  // SizedBox(height: 10.h,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding customTitle({required String title}) {
    return Padding(padding: EdgeInsets.only(left: 3.w), child: MyText(title: title));
  }

  Container uploadMedia() {
    return Container(
      // height: 40.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              ImageGalleryClass().imageGalleryBottomSheet(
                context: context,
                onMediaChanged: (val) {
                  if (val != null) {
                    permit = File(val);
                    setState(() {});
                  }
                },
              );
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
                  Image.asset(ImagePath.upload, scale: 2, color: CustomColors.primaryGreenColor),
                  SizedBox(height: 1.h),
                  MyText(title: 'Upload image', size: 16, clr: CustomColors.black, fontWeight: FontWeight.w600),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Future completeDialog() {
    context.read<HomeController>().setIndex(0);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: CustomDialog(
              title: 'Successfully',
              // image: ImagePath.scan3,
              description:
                  widget.edit ? 'Offer have been successfully updated.' : 'Offer have been successfully created.',
              b1: 'Continue',
              // b2: 'Download QR Code',
              onYes: (v) {
                context.maybePop();
              },
              // button2: (v) {
              //   downloadDialog();
              // },
            ),
          ),
        );
      },
    );
  }
}
