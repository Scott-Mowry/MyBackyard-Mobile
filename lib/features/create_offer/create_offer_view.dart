import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/widgets/app_bar_back_button.dart';
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
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
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

  late final titleController = TextEditingController(text: widget.model?.title ?? '');
  late final discountController = TextEditingController(text: widget.model?.discountPrice?.toString() ?? '');
  late final rewardPointsController = TextEditingController(text: widget.model?.rewardPoints?.toString() ?? '');
  late final shortDetailController = TextEditingController(text: widget.model?.shortDetail ?? '');
  late final descriptionController = TextEditingController(text: widget.model?.description ?? '');
  late final actualPriceController = TextEditingController(text: widget.model?.actualPrice?.toString() ?? '');

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await BusinessAPIS.getCategories();
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
  }

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
          onRefresh: BusinessAPIS.getCategories,
          child: CustomPadding(
            topPadding: 0.h,
            horizontalPadding: 3.w,
            child: Consumer<HomeController>(
              builder: (context, homeController, _) {
                return Column(
                  children: [
                    CustomAppBar(
                      screenTitle: widget.edit ? 'Edit Offer' : 'Create Offer',
                      leading: AppBarBackButton(),
                      bottom: 2.h,
                    ),
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
                                                            ? const AssetImage(ImagePath.noUserImage)
                                                            : FileImage(permit))
                                                        as ImageProvider,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  : widget.model?.image != null
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
                                            backgroundColor: CustomColors.primaryGreenColor.withValues(alpha: 0.5),
                                            child: const Icon(Icons.edit_outlined, color: Colors.white),
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
                              ),
                              SizedBox(height: 2.h),
                              customTitle(title: 'Select Category'),
                              SizedBox(height: 1.h),
                              CustomDropDown2(
                                hintText: 'Select Category',
                                bgColor: CustomColors.container,
                                dropDownData: homeController.categories ?? [],
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
                              ),
                              SizedBox(height: 2.h),
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
                                      final val = await BusinessAPIS.editOffer(
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
                                      final val = await BusinessAPIS.addOffer(
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
