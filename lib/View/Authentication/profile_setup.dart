import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_switch.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Component/validations.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/places_model.dart';
import 'package:backyard/Service/api.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/general_apis.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/main.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:place_picker/place_picker.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/Widget/upload_media.dart';
import 'package:backyard/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/image_path.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Component/custom_background_image.dart';
import '../../Component/custom_padding.dart';
import '../../Component/custom_textfield.dart';
import '../../Utils/app_router_name.dart';
import '../Widget/Dialog/profile_complete_dialog.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key, required this.editProfile});
  final bool editProfile;
  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  late Role? role = context.read<UserController>().user?.role;
  late bool business = role == Role.Business;
  String? imageProfile;
  bool isMerchantSetupActive = false;
  TextEditingController firstName = TextEditingController();
  final _form = GlobalKey<FormState>();
  String title = 'Complete Profile';
  String buttonTitle = 'Continue';
  TextEditingController lastName = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  bool? geo = false;
  bool errorText = false;
  String country = 'US';
  String dialCode = "1";
  double lat = 0, lng = 0;
  bool emailReadOnly = false, phoneReadOnly = false;
  String? merchantUrl;
  imageType type = imageType.asset;
  late final userController = context.read<UserController>();
  late final userController2 = context.watch<UserController>();

  /// #Timer
  final Duration _duration = const Duration(seconds: 15);
  final CountDownController _countDownController = CountDownController();
  bool isTimeComplete = false;

  Map<Role, String> descriptions = {Role.User: "Consumer Interface", Role.Business: "Business + Consumer Interface"};

  @override
  void initState() {
    firstName.text = userController.user?.name ?? "";
    lastName.text = userController.user?.lastName ?? "";
    emailC.text = userController.user?.email ?? "";

    if (widget.editProfile) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await GeneralAPIS.getPlaces();
      });
      zipCode.text = userController.user?.zipCode ?? "";
      phone.text = userController.user?.phone ?? "";
      location.text = userController.user?.address ?? "";
      lat = userController.user?.latitude ?? 0;
      lng = userController.user?.longitude ?? 0;
      description.text = userController.user?.description ?? "";
      imageProfile = userController.user?.profileImage ?? "";
      title = 'Edit Profile';
      type = imageType.network;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child:
          widget.editProfile
              ? BaseView(bgImage: '', child: body())
              : CustomBackgroundImage(image: ImagePath.bgImage1, child: SafeArea(child: body())),
    );
  }

  body() {
    return Form(
      key: _form,
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomAppBar(screenTitle: title, leading: CustomBackButton(), bottom: 0.h),
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
                    Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ImageGalleryClass().imageGalleryBottomSheet(
                            context: context,
                            onMediaChanged: (val) {
                              if (val != null) {
                                imageProfile = val;
                                type = imageType.file;
                                setState(() {
                                  errorText = (imageProfile ?? "").isEmpty;
                                });
                              }
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundColor: MyColors().primaryColor,
                          child: CircleAvatar(
                            radius: 65.0,
                            backgroundImage:
                                (type == imageType.network
                                        ? NetworkImage("${API.public_url}${imageProfile ?? ""}")
                                        : type == imageType.file
                                        ? FileImage(File(imageProfile ?? ""))
                                        : const AssetImage(ImagePath.noUserImage))
                                    as ImageProvider,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: MyColors().whiteColor,
                                radius: 14.0,
                                child: CircleAvatar(
                                  backgroundColor: MyColors().primaryColor,
                                  radius: 13.0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      ImageGalleryClass().imageGalleryBottomSheet(
                                        context: context,
                                        onMediaChanged: (val) {
                                          if (val != null) {
                                            imageProfile = val;
                                            type = imageType.file;
                                            setState(() {
                                              errorText = (imageProfile ?? "").isEmpty;
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
                          ),
                        ),
                      ),
                    ),
                    if (errorText)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Image can't be empty",
                            style: TextStyle(color: widget.editProfile ? Colors.red : Colors.white, fontSize: 12.sp),
                          ),
                        ),
                      ),
                    SizedBox(height: 3.h),
                    if (!widget.editProfile) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MyText(
                          title: "Role Selection:",
                          center: true,
                          line: 2,
                          size: 18,
                          toverflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          clr: MyColors().black,
                        ),
                      ),
                      SizedBox(height: 1.8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < Role.values.length; i++)
                            GestureDetector(
                              onTap: () {
                                role = Role.values[i];
                                userController.setRole(Role.values[i]);
                                business = role == Role.Business;
                                _form.currentState?.reset();
                                setState(() {});
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: Utils.isTablet ? 23 : 18,
                                    height: Utils.isTablet ? 23 : 18,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (role ?? Role.User) == Role.values[i] ? Colors.black : null,
                                      border: Border.all(
                                        width: 2,
                                        color:
                                            (role ?? Role.User) == Role.values[i] ? Colors.transparent : Colors.black,
                                      ),
                                    ),
                                    child:
                                        (role ?? Role.User) == Role.values[i]
                                            ? Icon(
                                              Icons.check,
                                              size: Utils.isTablet ? 16 : 14,
                                              color: widget.editProfile ? Colors.white : MyColors().primaryColor,
                                            )
                                            : null,
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        Role.values[i].name,
                                        style: TextStyle(
                                          fontSize: Utils.isTablet ? 19 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        descriptions[Role.values[i]] ?? "",
                                        style: TextStyle(
                                          fontSize: Utils.isTablet ? 13 : 10,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    SizedBox(height: 3.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextField(
                          controller: firstName,
                          hintText: business ? "Business Name" : 'First Name',
                          maxLength: 30,
                          prefixWidget: Image.asset(
                            ImagePath.person,
                            scale: 2,
                            color: widget.editProfile ? MyColors().primaryColor : MyColors().primaryColor,
                          ),
                          backgroundColor: !widget.editProfile ? null : MyColors().container,
                          validation: (p0) => p0?.validateEmpty(business ? "Business Name" : 'First Name'),
                        ),
                        SizedBox(height: 1.5.h),
                        if (!business) ...[
                          MyTextField(
                            controller: lastName,
                            hintText: 'Last Name',
                            maxLength: 30,
                            prefixWidget: Image.asset(
                              ImagePath.person,
                              scale: 2,
                              color: widget.editProfile ? MyColors().primaryColor : MyColors().primaryColor,
                            ),
                            backgroundColor: !widget.editProfile ? null : MyColors().container,
                            validation: (p0) => p0?.validateEmpty("Last Name"),
                          ),
                          SizedBox(height: 1.5.h),
                        ],
                        if (userController.user?.socialType == null || userController.user?.socialType == "phone") ...[
                          MyTextField(
                            hintText: 'Email Address',
                            controller: emailC,
                            maxLength: 35,
                            onChanged: (v) {},
                            readOnly:
                                widget.editProfile
                                    ? (userController2.user?.emailVerifiedAt != null)
                                    : (userController2.user?.email ?? "").isNotEmpty,
                            inputType: TextInputType.emailAddress,
                            prefixWidget: Image.asset(
                              ImagePath.email,
                              scale: 2,
                              color: widget.editProfile ? MyColors().primaryColor : MyColors().primaryColor,
                            ),
                            backgroundColor: !widget.editProfile ? null : MyColors().container,
                            validation: (p0) => p0?.validateEmail,
                          ),
                          SizedBox(height: 1.5.h),
                        ],
                        if (business)
                          MyTextField(
                            prefixWidget: Image.asset(
                              ImagePath.phone,
                              scale: 2,
                              color: widget.editProfile ? MyColors().primaryColor : MyColors().primaryColor,
                            ),
                            controller: phone,
                            hintText: 'Phone Number',
                            inputType: TextInputType.phone,
                            contact: true,
                            // readOnly:
                            // widget.editProfile
                            //     ? (userController2.user?.socialType == "phone")
                            //     : (userController2.user?.phone ?? "")
                            //         .isNotEmpty
                            // ,
                            backgroundColor: !widget.editProfile ? null : MyColors().container,
                            validation: (value) {
                              final cleanedPhoneNumber = value.toString().replaceAll(
                                RegExp(r'[()-\s]'),
                                '',
                              ); // Remove brackets, dashes, and spaces
                              log(cleanedPhoneNumber);

                              if (!isNumeric(cleanedPhoneNumber)) {
                                return "Phone number field can\"t be empty";
                              }
                              if (cleanedPhoneNumber.length < 10) {
                                return "Invalid Phone Number";
                              }

                              return null;
                            },
                          ),
                        if (business) SizedBox(height: 1.5.h),
                        if (!business) ...[
                          MyTextField(
                            controller: zipCode,
                            hintText: 'Zip Code',
                            maxLength: 6,
                            prefixWidget: Icon(Icons.map, color: MyColors().primaryColor),
                            backgroundColor: !widget.editProfile ? null : MyColors().container,
                            validation: (p0) => p0?.validateZipCOde,
                          ),
                          SizedBox(height: 1.5.h),
                          if (!widget.editProfile)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  title: "Geo Location",
                                  fontWeight: FontWeight.w500,
                                  size: Utils.isTablet ? 18 : 15,
                                  clr: widget.editProfile ? Colors.black : Colors.white,
                                ),
                                CustomSwitch(
                                  switchValue: geo,
                                  onChange: (v) {},
                                  onChange2: (v) async {
                                    geo = v;
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                        ] else ...[
                          MyTextField(
                            prefixWidget: Image.asset(
                              ImagePath.location,
                              scale: 2,
                              color: widget.editProfile ? MyColors().primaryColor : MyColors().primaryColor,
                            ),
                            controller: location,
                            hintText: 'Address',
                            readOnly: true,
                            onTap: () async {
                              await getAddress(context);
                            },
                            backgroundColor: !widget.editProfile ? null : MyColors().container,
                          ),
                          SizedBox(height: 1.5.h),
                          MyTextField(
                            height: 8.h,
                            hintText: 'Description',
                            showLabel: false,
                            maxLines: 5,
                            minLines: 5,
                            controller: description,
                            borderRadius: 10,
                            maxLength: 275,
                            backgroundColor: !widget.editProfile ? null : MyColors().container,
                            validation: (p0) => p0?.validateEmpty("description"),
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
          SizedBox(height: 2.h),
          if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
            if (widget.editProfile && business) ...[
              MyButton(
                width: Utils.isTablet ? 60.w : 90.w,
                title: 'Update Hours',
                borderColor: MyColors().black,
                bgColor: MyColors().whiteColor,
                textColor: MyColors().black,
                onTap: () {
                  AppNavigation.navigateTo(
                    AppRouteName.SCHEDULE_SCREEN_ROUTE,
                    arguments: ScreenArguments(fromEdit: true),
                  );
                },
              ),
              SizedBox(height: 2.h),
            ],
            MyButton(
              width: Utils.isTablet ? 60.w : 90.w,
              title: buttonTitle,
              onTap: () {
                onSubmit();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ],
      ),
    );
  }

  Future<void> getAddress(context) async {
    LocationResult t = await Utils().showPlacePicker(context);
    if (isLatLongInCities(t.latLng ?? const LatLng(0, 0))) {
      print(t.formattedAddress.toString());
      lat = t.latLng?.latitude ?? 0;
      lng = t.latLng?.longitude ?? 0;
      location.text = t.formattedAddress ?? '';
    } else {
      CustomToast().showToast(message: "Application is not available in this address, it'll be available soon");
    }
  }

  onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      errorText = (imageProfile ?? "").isEmpty;
    });
    if ((_form.currentState?.validate() ?? false) && !(errorText)) {
      if (widget.editProfile) {
        AppNetwork.loadingProgressIndicator();
        await AuthAPIS.completeProfile(
          firstName: firstName.text,
          lastName: role == Role.Business ? lastName.text : null,
          categoryId: role == Role.Business ? userController.user?.categoryId : null,
          description: role == Role.Business ? description.text : null,
          isPushNotify: "1",
          email: emailC.text != userController.user?.email && emailC.text.isNotEmpty ? emailC.text : null,
          phone: phone.text != (userController.user?.phone ?? "") ? phone.text : null,
          days: userController.user?.days,
          address: role == Role.Business ? location.text : null,
          lat: role == Role.Business ? lat : null,
          long: role == Role.Business ? lng : null,
          zipCode: role == Role.Business ? null : zipCode.text,
          image:
              imageProfile == null
                  ? null
                  : type == imageType.file
                  ? File(imageProfile ?? "")
                  : null,
        );
        AppNavigation.navigatorPop();
        AppNavigation.navigatorPop();
      } else {
        if (role == Role.User) {
          AppNetwork.loadingProgressIndicator();
          final value = await AuthAPIS.completeProfile(
            firstName: firstName.text,
            lastName: lastName.text,
            isPushNotify: "1",
            email: emailC.text != userController.user?.email && emailC.text.isNotEmpty ? emailC.text : null,
            role: Role.User.name,
            zipCode: zipCode.text,
            // phone: phone.text != (userController.user?.phone ?? "")
            //     ? phone.text
            //     : null,
            image: imageProfile == null ? null : File(imageProfile ?? ""),
          );
          AppNavigation.navigatorPop();
          if (value) {
            completeDialog(
              onTap: () {
                AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
              },
            );
          }

          // final controller =
          //     navigatorKey.currentContext?.read<UserController>();
          // User? user = controller?.user;
          // user?.name = firstName.text;
          // user?.isPushNotify = 1;
          // user?.phone =
          //     phone.text != userController.user?.phone ? phone.text : null;
          // user?.email = emailC.text != userController.user?.email &&
          //         emailC.text.isNotEmpty
          //     ? emailC.text
          //     : null;
          // user?.profileImage = imageProfile.path;
          // AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_SCREEN_ROUTE,
          //     arguments: ScreenArguments(fromCompleteProfile: true));
        } else {
          Map<String, dynamic> arguments = {
            "name": firstName.text,
            "description": description.text,
            "isPushNotify": 1,
            "address": location.text,
            "lat": lat,
            "lng": lng,
            // "zipCode": zipCode.text,
            "email": emailC.text,
            "phone": phone.text,
            "image": imageProfile ?? "",
          };
          AppNavigation.navigateTo(
            AppRouteName.SCHEDULE_SCREEN_ROUTE,
            arguments: ScreenArguments(args: arguments, fromEdit: false),
          );
        }
      }
    }
  }

  completeDialog({required Function onTap}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
              content: ProfileCompleteDialog(
                onYes: (v) {
                  log('Yaha arha h 2');
                  onTap();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

bool isLatLongInCities(LatLng selectedLatLng) {
  // Define bounding boxes for all cities
  // final cityBounds = {
  //   "Tonawanda": [const LatLng(43.070, -78.950), const LatLng(43.005, -78.800)],
  //   "Houston": [const LatLng(30.110, -95.850), const LatLng(29.520, -95.080)],
  //   "Cypress": [const LatLng(30.010, -96.200), const LatLng(29.930, -95.550)],
  //   "Katy": [const LatLng(29.900, -95.900), const LatLng(29.680, -95.610)],
  //   "Spring": [const LatLng(30.130, -95.570), const LatLng(30.000, -95.300)],
  //   "The Woodlands": [
  //     const LatLng(30.240, -95.600),
  //     const LatLng(30.120, -95.450)
  //   ],
  //   "Tomball": [const LatLng(30.120, -95.680), const LatLng(30.070, -95.560)],
  //   "Conroe": [const LatLng(30.360, -95.570), const LatLng(30.260, -95.400)],
  //   "Richmond": [const LatLng(29.620, -95.830), const LatLng(29.520, -95.730)],
  //   "Sugar Land": [
  //     const LatLng(29.650, -95.700),
  //     const LatLng(29.520, -95.550)
  //   ],
  //   "Rosenberg": [const LatLng(29.600, -95.850), const LatLng(29.500, -95.750)],
  //   "Magnolia": [const LatLng(30.220, -95.770), const LatLng(30.150, -95.650)],
  //   "Willis": [const LatLng(30.450, -95.520), const LatLng(30.380, -95.420)],
  //   "Jersey Village": [
  //     const LatLng(29.910, -95.590),
  //     const LatLng(29.870, -95.550)
  //   ],
  //   "Heights": [const LatLng(29.800, -95.410), const LatLng(29.750, -95.380)],
  //   "Kenmore": [const LatLng(42.970, -78.890), const LatLng(42.960, -78.870)],
  //   "Buffalo": [const LatLng(42.960, -78.950), const LatLng(42.830, -78.770)],
  //   "Amherst": [const LatLng(43.050, -78.820), const LatLng(42.960, -78.730)],
  //   "Williamsville": [
  //     const LatLng(42.970, -78.750),
  //     const LatLng(42.940, -78.720)
  //   ],
  //   "Clarence": [const LatLng(43.020, -78.650), const LatLng(42.960, -78.570)],
  //   "Niagara Falls": [
  //     const LatLng(43.120, -79.070),
  //     const LatLng(43.010, -78.900)
  //   ],
  //   "Lewiston": [const LatLng(43.190, -79.070), const LatLng(43.140, -78.940)],
  //   "North Tonawanda": [
  //     const LatLng(43.060, -78.890),
  //     const LatLng(43.030, -78.830)
  //   ],
  //   "Orchard Park": [
  //     const LatLng(42.800, -78.780),
  //     const LatLng(42.720, -78.650)
  //   ],
  //   "Hamburg": [const LatLng(42.770, -78.930), const LatLng(42.710, -78.820)],
  // };
  final controller = navigatorKey.currentContext!.read<HomeController>();
  // Check if the selectedLatLng is within any city's bounding box
  for (PlacesModel bounds in (controller.places ?? [])) {
    LatLng topLeft = LatLng(bounds.topLeftLatitude ?? 0, bounds.topLeftLongitude ?? 0);
    LatLng bottomRight = LatLng(bounds.bottomRightLatitude ?? 0, bounds.bottomRightLongitude ?? 0);

    if (selectedLatLng.latitude <= topLeft.latitude &&
        selectedLatLng.latitude >= bottomRight.latitude &&
        selectedLatLng.longitude >= topLeft.longitude &&
        selectedLatLng.longitude <= bottomRight.longitude) {
      return true;
    }
  }

  return false;
}
