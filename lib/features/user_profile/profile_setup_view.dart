import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/api_client/my_backyard_api_client.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/address_autocomplete_text_form_field.dart';
import 'package:backyard/core/design_system/widgets/app_bar_back_button.dart';
import 'package:backyard/core/design_system/widgets/custom_network_image.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/core/repositories/google_maps_repository.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/core/services/business_service.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_dropdown.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/profile_complete_dialog.dart';
import 'package:backyard/legacy/View/Widget/upload_media.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ProfileSetupView extends StatefulWidget {
  final bool isEditProfile;

  const ProfileSetupView({super.key, required this.isEditProfile});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  late UserRoleEnum? role = context.read<UserController>().user?.role;

  bool get isBusiness => role == UserRoleEnum.Business;

  String? imageProfile;
  final _form = GlobalKey<FormState>();
  String title = 'Complete Profile';

  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final addressTextController = TextEditingController();

  bool get addressNotSelected {
    final homeController = context.read<HomeController>();
    final addressDetails = homeController.currentUserAddress;
    return addressDetails == null || addressDetails.geometry == null || addressDetails.formattedAddress == null;
  }

  final availabilities = <BusinessSchedulingModel>[];

  bool errorText = false;

  var imageType = ImageTypeEnum.asset;

  Map<UserRoleEnum, String> descriptions = {
    UserRoleEnum.User: 'Consumer Interface',
    UserRoleEnum.Business: 'Business + Consumer Interface',
  };

  bool _internalLoading = true;

  @override
  void initState() {
    super.initState();

    final userController = context.read<UserController>();
    final userProfile = userController.user;

    availabilities.addAll(userProfile?.days ?? []);

    nameTextController.text = userProfile?.name ?? '';
    emailTextController.text = userProfile?.email ?? '';

    if (widget.isEditProfile) {
      phoneTextController.text = userProfile?.phone ?? '';
      addressTextController.text = userProfile?.address ?? userProfile?.zipCode ?? '';

      descriptionTextController.text = userProfile?.description ?? '';
      imageProfile = userProfile?.profileImage ?? '';
      title = 'Edit Profile';
      imageType = ImageTypeEnum.network;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await initCategory();
        await initAddress();
      } finally {
        _internalLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rolesToChoose = [UserRoleEnum.User, UserRoleEnum.Business];
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BaseView(
        bgImage: widget.isEditProfile ? '' : ImagePath.bgImage1,
        child: Consumer2<UserController, HomeController>(
          builder: (context, userController, homeController, _) {
            final categoriesList = homeController.categories ?? <CategoryModel>[];
            return Form(
              key: _form,
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: CustomAppBar(screenTitle: title, leading: AppBarBackButton(), bottom: 0.h),
                  ),
                  Expanded(
                    child: CustomPadding(
                      topPadding: 2.h,
                      child: SizedBox(
                        width: Utils.isTablet ? 60.w : null,
                        child: ListView(
                          reverse: false,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Row(
                              mainAxisAlignment:
                                  widget.isEditProfile ? MainAxisAlignment.center : MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        ImageGalleryClass().imageGalleryBottomSheet(
                                          context: context,
                                          onMediaChanged: (val) {
                                            if (val != null) {
                                              imageProfile = val;
                                              imageType = ImageTypeEnum.file;
                                              setState(() {
                                                errorText = (imageProfile ?? '').isEmpty;
                                              });
                                            }
                                          },
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 140,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: CustomColors.primaryGreenColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ClipOval(
                                                child:
                                                    imageType == ImageTypeEnum.network
                                                        ? CustomNetworkImage(
                                                          imageUrl:
                                                              "${MyBackyardApiClient.publicUrl}${imageProfile ?? ""}",
                                                          fit: BoxFit.cover,
                                                        )
                                                        : imageType == ImageTypeEnum.file
                                                        ? Image.file(File(imageProfile ?? ''), fit: BoxFit.cover)
                                                        : Image.asset(ImagePath.noUserImage, fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              backgroundColor: CustomColors.whiteColor,
                                              radius: 14.0,
                                              child: CircleAvatar(
                                                backgroundColor: CustomColors.primaryGreenColor,
                                                radius: 13.0,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    ImageGalleryClass().imageGalleryBottomSheet(
                                                      context: context,
                                                      onMediaChanged: (val) {
                                                        if (val != null) {
                                                          imageProfile = val;
                                                          imageType = ImageTypeEnum.file;
                                                          setState(() {
                                                            errorText = (imageProfile ?? '').isEmpty;
                                                          });
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: Image.asset(ImagePath.editIcon, scale: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (errorText)
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Missing profile picture',
                                            style: TextStyle(color: CustomColors.redColor, fontSize: 16.sp),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (!widget.isEditProfile)
                                  Expanded(
                                    child: Padding(
                                      padding: CustomSpacer.left.md,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: CustomSpacer.vertical.xs.vertical,
                                        children:
                                            rolesToChoose.map((el) {
                                              return GestureDetector(
                                                onTap: () {
                                                  role = el;
                                                  userController.setRole(el);
                                                  _form.currentState?.reset();
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: Utils.isTablet ? 23 : 18,
                                                      height: Utils.isTablet ? 23 : 18,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (role ?? UserRoleEnum.User) == el ? Colors.black : null,
                                                        border: Border.all(
                                                          width: 2,
                                                          color:
                                                              (role ?? UserRoleEnum.User) == el
                                                                  ? Colors.transparent
                                                                  : Colors.black,
                                                        ),
                                                      ),
                                                      child:
                                                          (role ?? UserRoleEnum.User) == el
                                                              ? Icon(
                                                                Icons.check,
                                                                size: Utils.isTablet ? 16 : 14,
                                                                color:
                                                                    widget.isEditProfile
                                                                        ? Colors.white
                                                                        : CustomColors.primaryGreenColor,
                                                              )
                                                              : null,
                                                    ),
                                                    SizedBox(width: 1.5.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            el.name,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          Text(
                                                            descriptions[el] ?? '',
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w300,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            if (!_internalLoading)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isBusiness) ...[
                                    CustomDropDown2(
                                      hintText: 'Select Category',
                                      bgColor:
                                          !widget.isEditProfile ? CustomColors.secondaryColor : CustomColors.container,
                                      dropDownData: categoriesList,
                                      dropdownValue: homeController.currentBusinessCategory,
                                      validator: (p0) => (p0 == null) ? "Category can't be empty" : null,
                                      onChanged: homeController.setCurrentBusinessCategory,
                                    ),
                                    SizedBox(height: 1.5.h),
                                  ],
                                  CustomTextFormField(
                                    controller: nameTextController,
                                    hintText: isBusiness ? 'Business Name' : 'Full Name',
                                    maxLength: 30,
                                    prefixWidget: Image.asset(
                                      ImagePath.person,
                                      scale: 2,
                                      color:
                                          widget.isEditProfile
                                              ? CustomColors.primaryGreenColor
                                              : CustomColors.primaryGreenColor,
                                    ),
                                    backgroundColor: !widget.isEditProfile ? null : CustomColors.container,
                                    validation: (p0) => p0?.validateEmpty(isBusiness ? 'Business Name' : 'First Name'),
                                  ),
                                  Padding(
                                    padding: CustomSpacer.top.xs,
                                    child: AddressAutocompleteTextFormField(
                                      hintText: 'Address',
                                      controller: addressTextController,
                                      validation: (p0) {
                                        return p0 == null || p0.isEmpty || addressNotSelected
                                            ? _selectAddressValidationMsg
                                            : null;
                                      },
                                      backgroundColor: !widget.isEditProfile ? null : CustomColors.container,
                                      onAddressSelected: homeController.setCurrentUserAddress,
                                    ),
                                  ),
                                  SizedBox(height: 1.5.h),
                                  if (userController.user?.socialType == null ||
                                      userController.user?.socialType == 'phone') ...[
                                    CustomTextFormField(
                                      hintText: 'Email Address',
                                      controller: emailTextController,
                                      onChanged: (v) {},
                                      readOnly:
                                          widget.isEditProfile
                                              ? (userController.user?.emailVerifiedAt != null)
                                              : (userController.user?.email ?? '').isNotEmpty,
                                      inputType: TextInputType.emailAddress,
                                      prefixWidget: Image.asset(
                                        ImagePath.email,
                                        scale: 2,
                                        color:
                                            widget.isEditProfile
                                                ? CustomColors.primaryGreenColor
                                                : CustomColors.primaryGreenColor,
                                      ),
                                      backgroundColor: !widget.isEditProfile ? null : CustomColors.container,
                                      validation: (p0) => p0?.validateEmail,
                                    ),
                                    SizedBox(height: 1.5.h),
                                  ],
                                  if (isBusiness)
                                    CustomTextFormField(
                                      prefixWidget: Image.asset(
                                        ImagePath.phone,
                                        scale: 2,
                                        color:
                                            widget.isEditProfile
                                                ? CustomColors.primaryGreenColor
                                                : CustomColors.primaryGreenColor,
                                      ),
                                      controller: phoneTextController,
                                      hintText: 'Phone Number',
                                      inputType: TextInputType.phone,
                                      contact: true,
                                      backgroundColor: !widget.isEditProfile ? null : CustomColors.container,
                                      validation: (value) {
                                        final cleanedPhoneNumber = value.toString().replaceAll(
                                          RegExp(r'[()-\s]'),
                                          '',
                                        ); // Remove brackets, dashes, and spaces

                                        if (!isNumeric(cleanedPhoneNumber)) {
                                          return 'Phone number field can"t be empty';
                                        }
                                        if (cleanedPhoneNumber.length < 10) {
                                          return 'Invalid Phone Number';
                                        }

                                        return null;
                                      },
                                    ),
                                  if (isBusiness) ...[
                                    SizedBox(height: 1.5.h),
                                    CustomTextFormField(
                                      hintText: 'Description',
                                      showLabel: false,
                                      maxLines: 10,
                                      minLines: 3,
                                      controller: descriptionTextController,
                                      borderRadius: 10,
                                      maxLength: 250,
                                      backgroundColor: !widget.isEditProfile ? null : CustomColors.container,
                                      validation: (p0) => p0?.validateEmpty('description'),
                                    ),
                                    SizedBox(height: 1.5.h),
                                  ],
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  if (MediaQuery.viewInsetsOf(context).bottom == 0)
                    Padding(
                      padding: CustomSpacer.vertical.xs + CustomSpacer.horizontal.md,
                      child: Row(
                        spacing: CustomSpacer.horizontal.xs.horizontal,
                        children: [
                          if (isBusiness)
                            Expanded(
                              child: MyButton(
                                width: Utils.isTablet ? 60.w : 90.w,
                                title: 'Update Hours',
                                borderColor: widget.isEditProfile ? CustomColors.black : null,
                                bgColor: widget.isEditProfile ? CustomColors.whiteColor : CustomColors.secondaryColor,
                                textColor: CustomColors.black,
                                onTap: () async {
                                  final newAvailabilities = await context.pushRoute(
                                    BusinessAvailabilityRoute(availabilities: availabilities),
                                  );

                                  if (newAvailabilities == null ||
                                      newAvailabilities is! List<BusinessSchedulingModel>) {
                                    return;
                                  }

                                  availabilities.clear();
                                  availabilities.addAll(newAvailabilities);
                                  setState(() {});
                                },
                              ),
                            ),
                          if (!isBusiness || availabilities.isNotEmpty)
                            Expanded(
                              child: MyButton(
                                width: Utils.isTablet ? 60.w : 90.w,
                                title: widget.isEditProfile ? 'Save' : 'Continue',
                                onTap: saveProfile,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> initCategory() async {
    final userController = context.read<UserController>();
    final userProfile = userController.user;

    await getIt<BusinessService>().getCategories();
    final categories = context.read<HomeController>().categories;
    final category = categories?.firstWhereOrNull((el) => el.id == userProfile?.categoryId);

    final homeController = context.read<HomeController>();
    homeController.setCurrentBusinessCategory(category);
  }

  Future<void> initAddress() async {
    final userController = context.read<UserController>();
    final userProfile = userController.user;

    final address = userProfile?.address;
    final addressOptions = address == null ? null : await getIt<GoogleMapsRepository>().getAddressesByQuery(address);
    final addressData =
        addressOptions == null || addressOptions.isEmpty || !addressOptions.any((el) => el.placeId != null)
            ? null
            : await getIt<GoogleMapsRepository>().getPlaceDetails(addressOptions.first.placeId!);

    final homeController = context.read<HomeController>();
    homeController.setCurrentUserAddress(addressData);
  }

  Future<void> saveProfile() async {
    final homeController = context.read<HomeController>();
    final userController = context.read<UserController>();

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => errorText = (imageProfile ?? '').isEmpty);

    if (!_form.currentState!.validate() || errorText) return;
    if (addressNotSelected) {
      return showSnackbar(context: context, content: _selectAddressValidationMsg);
    }

    _form.currentState!.save();

    final currentUser = userController.user;
    final addressDetails = homeController.currentUserAddress;
    final addressLocation = addressDetails?.geometry?.location;
    await getIt<UserAuthRepository>().completeProfile(
      fullName: nameTextController.text,
      zipCode: addressDetails?.postalCode ?? currentUser?.zipCode,
      address: addressDetails?.formattedAddress ?? currentUser?.address,
      email:
          emailTextController.text != userController.user?.email && emailTextController.text.isNotEmpty
              ? emailTextController.text
              : null,
      phone: phoneTextController.text != (userController.user?.phone ?? '') ? phoneTextController.text : null,
      description: isBusiness ? descriptionTextController.text : null,
      lat: addressLocation?.lat ?? currentUser?.latitude,
      long: addressLocation?.lng ?? currentUser?.longitude,
      role: role!.name,
      categoryId: isBusiness ? (homeController.currentBusinessCategory?.id ?? userController.user?.categoryId) : null,
      days: availabilities.isEmpty ? userController.user?.days : availabilities,
      image:
          imageProfile == null
              ? null
              : imageType == ImageTypeEnum.file
              ? File(imageProfile ?? '')
              : null,
    );

    if (widget.isEditProfile) return unawaited(context.maybePop());
    return showProfileCompletedDialog(context);
  }
}

Future<void> showProfileCompletedDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: ProfileCompleteDialog(onConfirm: () => context.pushRoute(HomeRoute())),
          ),
        ),
      );
    },
  );
}

String _selectAddressValidationMsg = 'Please type an address and select from the list';
