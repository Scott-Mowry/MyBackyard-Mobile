import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/address_info_widget.dart';
import 'package:backyard/core/design_system/widgets/category_name_widget.dart';
import 'package:backyard/core/design_system/widgets/price_discount_widget.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/legacy/Component/custom_bottomsheet_indicator.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
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
import 'package:sizer/sizer.dart';

@RoutePage()
class OfferItemView extends StatefulWidget {
  final Offer? offer;

  const OfferItemView({super.key, this.offer});

  @override
  State<OfferItemView> createState() => _OfferItemViewState();
}

class _OfferItemViewState extends State<OfferItemView> {
  late var offer = widget.offer;

  late final user = context.read<UserController>().user;

  bool get isOfferOwnedByCurrentBusinessUser {
    final userController = context.read<UserController>();
    if (userController.isSwitch) return false;

    final user = userController.user;
    return offer != null && user != null && user.role == UserRoleEnum.Business && offer?.ownerId == user.id;
  }

  String get data => json.encode({
    'title': offer?.title ?? '',
    'offer': offer?.id?.toString() ?? offer?.offerId?.toString(),
    'user_id': user?.id?.toString(),
  });

  @override
  Widget build(BuildContext context) {
    final imgWidth = 92.w;
    final imgHeight = 22.h;
    return BaseView(
      screenTitle: 'Discount Offers',
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      trailingAppBar:
          isOfferOwnedByCurrentBusinessUser
              ? IconButton(
                onPressed: () => editOffer(context),
                icon: const Icon(Icons.more_horiz_rounded, size: 35, color: Colors.black),
              )
              : null,
      child: CustomPadding(
        horizontalPadding: 4.w,
        topPadding: 0,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustomImage(
                          width: imgWidth,
                          height: imgHeight,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(10),
                          url: offer?.image,
                        ),
                        Container(
                          width: imgWidth,
                          height: imgHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.primaryGreenColor.withValues(alpha: 0),
                                CustomColors.primaryGreenColor.withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        if (offer != null && offer!.actualPrice != null && offer!.discountPrice != null)
                          Positioned(
                            bottom: CustomSpacer.bottom.lg.bottom,
                            child: PriceDiscountWidget(
                              actualPrice: offer!.actualPrice!,
                              discountPrice: offer!.discountPrice!,
                            ),
                          ),
                        if (offer?.category?.categoryName != null && offer!.category!.categoryName!.isNotEmpty)
                          Positioned(
                            top: CustomSpacer.top.xs.top,
                            child: Padding(
                              padding: CustomSpacer.left.xs,
                              child: CategoryNameWidget(name: offer!.category!.categoryName!.split(' ').first),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            offer?.title ?? '',
                            maxLines: 1,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    if (offer?.address != null && offer!.address!.isNotEmpty)
                      Padding(
                        padding: CustomSpacer.top.xs,
                        child: AddressInfoWidget(address: offer!.address ?? '', maxLines: 2),
                      ),
                    SizedBox(height: 2.h),
                    textDetail(
                      title: 'Offers Details:',
                      description: offer?.description ?? '',
                      // 'Classic checkerboard slip ons with office white under tone and reinforced waffle cup soles is a tone and reinforced waffle cup soles.CIassic ka checkerboard slip ons with office white hnan dunder tone and reinforced.'
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
            if (offer?.isClaimed ?? false)
              Text(
                'This offer was already claimed',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
              )
            else if (!isOfferOwnedByCurrentBusinessUser &&
                offer != null &&
                offer!.ownerId != context.watch<UserController>().user?.id &&
                !offer!.isClaimed)
              MyButton(
                title: offer!.isAvailed ? 'QR Code' : 'Redeem',
                onTap: () async {
                  if (offer!.isAvailed) {
                    return downloadDialog2(context, data);
                  } else {
                    final success = await BusinessAPIS.availOffer(offerId: offer?.id?.toString());
                    if (success) {
                      setState(() => offer = offer?.copyWith(isAvailed: true));
                      await downloadDialog(context, data);
                    }
                  }
                },
                bgColor: CustomColors.whiteColor,
                textColor: CustomColors.black,
                borderColor: CustomColors.black,
              ),
          ],
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
                      return context.pushRoute<void>(CreateOfferRoute(edit: true, model: offer));
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
                    onTap: () async {
                      await context.maybePop();
                      await deleteDialog(offer);
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

  Future<void> deleteDialog(Offer? model) {
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
              onConfirm: (v) async {
                final success = await BusinessAPIS.deleteOffer(offerId: offer?.id?.toString() ?? '');
                if (success) {
                  await this.context.maybePop(true);
                  await this.context.maybePop(true);
                }
              },
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
              onConfirm: (v) async {
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
              onConfirm: (v) async {
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
