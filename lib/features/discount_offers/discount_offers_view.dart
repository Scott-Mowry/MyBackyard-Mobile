import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/legacy/Component/custom_bottomsheet_indicator.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Utils/app_size.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/custom_dialog.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class DiscountOffersArgs {
  const DiscountOffersArgs({this.model, this.fromSaved});

  final Offer? model;
  final bool? fromSaved;
}

@RoutePage()
class DiscountOffersView extends StatefulWidget {
  const DiscountOffersView({super.key, this.model, this.fromSaved});

  final Offer? model;
  final bool? fromSaved;

  @override
  State<DiscountOffersView> createState() => _DiscountOffersViewState();
}

class _DiscountOffersViewState extends State<DiscountOffersView> {
  late final user = context.read<UserController>().user;
  late bool business =
      (context.read<UserController>().isSwitch)
          ? false
          : context.read<UserController>().user?.role == UserRoleEnum.Business;

  String get data => json.encode({
    'title': widget.model?.title ?? '',
    'offer': (widget.fromSaved ?? false) ? widget.model?.offerId?.toString() : widget.model?.id?.toString(),
    'user_id': user?.id?.toString(),
  });

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Discount Offers',
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      trailingAppBar:
          business
              ? IconButton(
                onPressed: () {
                  editOffer(context);
                },
                icon: const Icon(Icons.more_horiz_rounded, size: 35, color: Colors.black),
              )
              : null,
      child: CustomPadding(
        horizontalPadding: 4.w,
        topPadding: 0,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CustomImage(
                        width: 95.w,
                        height: 32.h,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(10),
                        url: widget.model?.image,
                      ),
                      Container(
                        width: 95.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              CustomColors.primaryGreenColor.withValues(alpha: 0),
                              CustomColors.primaryGreenColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: CustomColors.black, borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.all(16) + EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyText(
                              title: '\$${widget.model?.actualPrice}   ',
                              fontWeight: FontWeight.w600,
                              size: 16,
                              clr: CustomColors.whiteColor,
                              cut: true,
                            ),
                            MyText(
                              title: '\$${widget.model?.discountPrice}',
                              fontWeight: FontWeight.w600,
                              size: 16,
                              clr: CustomColors.whiteColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      SizedBox(height: 1.h),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(child: MyText(title: widget.model?.title ?? '', fontWeight: FontWeight.w600, size: 16)),
                  Container(
                    constraints: BoxConstraints(maxWidth: 53.w),
                    decoration: BoxDecoration(
                      color: CustomColors.primaryGreenColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: MyText(
                      title: widget.model?.category?.categoryName ?? '',
                      clr: CustomColors.whiteColor,
                      size: Utils.isTablet ? 6.sp : 10.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    ImagePath.location,
                    color: CustomColors.primaryGreenColor,
                    height: 13.sp,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(width: 1.w),
                  SizedBox(
                    width: 85.w,
                    child: Text(
                      widget.model?.address ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: Utils.isTablet ? 6.sp : 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              textDetail(
                title: 'Offers Details:',
                description: widget.model?.description ?? '',
                // 'Classic checkerboard slip ons with office white under tone and reinforced waffle cup soles is a tone and reinforced waffle cup soles.CIassic ka checkerboard slip ons with office white hnan dunder tone and reinforced.'
              ),
              SizedBox(height: 2.h),
              if (!business) ...[
                if (widget.model?.ownerId != context.watch<UserController>().user?.id)
                  if (widget.model?.isClaimed == 0)
                    Opacity(
                      opacity: context.watch<UserController>().user?.subId == null ? .5 : 1,
                      child: MyButton(
                        title: widget.model?.isAvailed == 1 ? 'Download QR Code' : 'Redeem Offer',
                        onTap: () async {
                          if (context.read<UserController>().user?.subId != null) {
                            if (widget.model?.isAvailed == 1) {
                              downloadDialog2(context, data);
                            } else {
                              getIt<AppNetwork>().loadingProgressIndicator();
                              final val = await BusAPIS.availOffer(offerId: widget.model?.id?.toString());
                              context.maybePop();
                              if (val) {
                                setState(() {
                                  widget.model?.isAvailed = 1;
                                });
                                // ignore: use_build_context_synchronously
                                downloadDialog(context, data);
                              }
                            }
                          } else {
                            CustomToast().showToast(message: 'You Need to Subscribe to Avail an Offer.');
                            await context.pushRoute(ContentRoute(title: 'Subscriptions', contentType: 'Subscriptions'));
                          }
                        },
                        bgColor: CustomColors.whiteColor,
                        textColor: CustomColors.black,
                        borderColor: CustomColors.black,
                      ),
                    ),
                SizedBox(height: 2.h),
                if (widget.model?.ownerId != context.watch<UserController>().user?.id)
                  Opacity(
                    opacity: context.watch<UserController>().user?.subId == null ? .5 : 1,
                    child: MyButton(
                      title: 'Share with Friends',
                      onTap: () async {
                        if (context.read<UserController>().user?.subId != null) {
                          await SharePlus.instance.share(
                            ShareParams(
                              text:
                                  "Share App with Friends,\n\n Link:${Platform.isAndroid ? "https://play.google.com/store/apps/details?id=com.app.mybackyardusa1" : "https://apps.apple.com/us/app/mb-my-backyard/id6736581907"}",
                              subject: 'Share with Friends',
                            ),
                          );
                        } else {
                          CustomToast().showToast(message: 'You Need to Subscribe to Share an Offer.');
                          await context.pushRoute(SubscriptionRoute());
                        }
                      },
                    ),
                  ),
                SizedBox(height: 2.h),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Column textDetail({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(title: title, fontWeight: FontWeight.w600, size: Utils.isTablet ? 18 : 14),
        SizedBox(height: 1.h),
        SizedBox(
          width: 95.w,
          child: MyText(title: description, size: Utils.isTablet ? 17 : 13, toverflow: TextOverflow.visible),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  void editOffer(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // backgroundColor: MyColors().whiteColor,
      builder: (bc) {
        return StatefulBuilder(
          builder: (context, s /*You can rename this!*/) {
            return Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: CustomColors.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.BOTTOMSHEETRADIUS)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomSheetIndicator(),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () async {
                      await context.maybePop();
                      return context.pushRoute<void>(CreateOfferRoute(edit: true, model: widget.model));
                    },
                    child: Row(
                      children: [
                        Image.asset(ImagePath.editProfile, scale: 2, color: CustomColors.primaryGreenColor),
                        SizedBox(width: 2.w),
                        MyText(title: 'Edit Offer', size: 17, fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () {
                      context.maybePop();
                      deleteDialog(context, widget.model);
                    },
                    child: Row(
                      children: [
                        Image.asset(ImagePath.delete, scale: 2, color: CustomColors.redColor),
                        SizedBox(width: 2.w),
                        MyText(title: 'Delete Offer', size: 17, fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future deleteDialog(context, Offer? model) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: CustomDialog(
              title: 'Alert',
              image: ImagePath.like,
              description: 'Are you sure you want to delete this offer?',
              b1: 'Yes',
              b2: 'No',
              onYes: (v) async {
                getIt<AppNetwork>().loadingProgressIndicator();
                final val = await BusAPIS.deleteOffer(offerId: widget.model?.id?.toString() ?? '');
                context.maybePop();
                if (val) {
                  context.maybePop();
                }
              },
              button2: (v) {},
            ),
          ),
        );
      },
    );
  }

  Future downloadDialog(context, String data) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: CustomDialog(
              title: 'Successful',
              description: "Offer is Redeemed, It's available in the Saved Section",
              b1: 'Download',
              onYes: (v) async {
                await generatePdfWithQrCode(data);
                CustomToast().showToast(message: 'QR Code downloaded successfully');
              },
              // image: ImagePath.download,
              child: QrImageView(
                data: data,
                gapless: false,
                version: QrVersions.auto,
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                size: 200,
              ),
            ),
          ),
        );
      },
    );
  }

  Future downloadDialog2(context, String data) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: CustomDialog(
              title: 'QR-Code',
              b1: 'Download',
              onYes: (v) async {
                await generatePdfWithQrCode(data);
                CustomToast().showToast(message: 'QR Code downloaded successfully');
              },
              // image: ImagePath.download,
              child: QrImageView(
                data: data,
                gapless: false,
                version: QrVersions.auto,
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
                embeddedImageEmitsError: true,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                size: 200,
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> generatePdfWithQrCode(String data) async {
  final pdf = pw.Document();

  // Define the QR code data and size
  final qrData = data;
  const qrSize = 250.0;

  final image = await QrPainter(
    data: qrData,
    version: QrVersions.auto,
    gapless: false,
    // embeddedImage: Image.asset(ImagePath.appLogo),
    embeddedImageStyle: QrEmbeddedImageStyle(size: Size(PdfPageFormat.a4.width, PdfPageFormat.a4.height)),
  ).toImage(PdfPageFormat.a4.width);
  final qrImageData = await CodePainter(qrImage: image).toImageData(PdfPageFormat.a4.width) ?? ByteData(0);

  // Add a page to the PDF document
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(25.00),
          child: pw.Column(
            children: [
              pw.SizedBox(height: PdfPageFormat.a4.height * .08),
              pw.Image(
                pw.MemoryImage(Uint8List.fromList(qrImageData.buffer.asUint8List())),
                width: qrSize,
                height: qrSize,
              ),
              pw.SizedBox(height: PdfPageFormat.a4.height * .08),
              pw.Text(
                'Scan the above QR-Code from My Backyard, to claim the Offer, Steps are given below:',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 20),
              ),
              pw.SizedBox(height: PdfPageFormat.a4.height * .05),
              pw.Text(
                '1. Get to the Business Branch.\n2. Get your QR-Code Scanned by the business.\n3. Done.',
                textAlign: pw.TextAlign.start,
                style: const pw.TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    ),
  );

  // Save the PDF to file or print it
  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

class CodePainter extends CustomPainter {
  CodePainter({required this.qrImage, this.margin = 10}) {
    _paint =
        Paint()
          ..color = Colors.white
          ..style = ui.PaintingStyle.fill;
  }

  final double margin;
  final ui.Image qrImage;
  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    canvas
      ..drawRect(rect, _paint)
      ..drawImage(qrImage, Offset(margin, margin), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  ui.Picture toPicture(double size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    paint(canvas, Size(size, size));
    return recorder.endRecording();
  }

  Future<ui.Image> toImage(double size, {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    return Future<ui.Image>.value(toPicture(size).toImage(size.toInt(), size.toInt()));
  }

  Future<ByteData?> toImageData(double originalSize, {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    final image = await toImage(originalSize + margin * 2, format: format);
    return image.toByteData(format: format);
  }
}
