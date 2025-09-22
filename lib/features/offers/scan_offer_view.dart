import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Widget/Dialog/offer_availed.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ScanOfferView extends StatefulWidget {
  final bool fromOffer;

  const ScanOfferView({super.key, this.fromOffer = false});

  @override
  State<ScanOfferView> createState() => _ScanOfferViewState();
}

class _ScanOfferViewState extends State<ScanOfferView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  Map<String, dynamic> qrCodeData = {};

  bool isScanning = true;
  bool isPaused = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Scan QR',
      backColor: CustomColors.whiteColor,
      screenTitleColor: CustomColors.whiteColor,
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      bottomSafeArea: false,
      backgroundColor: CustomColors.primaryGreenColor,
      child: CustomPadding(
        horizontalPadding: 0.w,
        topPadding: 0,
        child: Container(
          child: Stack(
            children: <Widget>[
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                onPermissionSet: (p0, p1) => _onPermissionSet(context, p0, p1),
                overlay: QrScannerOverlayShape(
                  borderColor: CustomColors.whiteColor,
                  borderRadius: 10,
                  borderLength: 130,
                  borderWidth: 10,
                  overlayColor: CustomColors.primaryGreenColor,
                ),
              ),
              Center(child: Image.asset(ImagePath.border, scale: 2)),
              Positioned(
                bottom: 8.h,
                left: 5.w,
                right: 5.w,
                child: MyButton(
                  bgColor: Colors.transparent,
                  title: 'Redeem Offer',
                  textColor: isPaused ? CustomColors.whiteColor : CustomColors.whiteColor.withValues(alpha: .5),
                  borderColor: isPaused ? CustomColors.whiteColor : CustomColors.whiteColor.withValues(alpha: .5),
                  onTap:
                      isPaused && qrCodeData.isNotEmpty
                          ? () async {
                            final success = await BusinessAPIS.claimOffer(
                              offerId: qrCodeData['offer'],
                              userId: qrCodeData['user_id'],
                            );
                            if (!success) return;

                            return showOfferClaimedDialog(
                              title: qrCodeData['title'],
                              onTap: () async {
                                await context.maybePop();
                                await controller?.resumeCamera();
                                setState(() => [isPaused = false, qrCodeData = {}]);
                              },
                            );
                          }
                          : () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanResult) async {
      if (scanResult.code == null) return;

      try {
        final data = json.decode(scanResult.code ?? '') as Map<String, dynamic>;
        setState(() => qrCodeData = data);

        await controller.pauseCamera().then((value) => setState(() => isPaused = true));
      } catch (_) {
        showSnackbar(context: context, content: 'Ops. Invalid QR code');
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  Future showOfferClaimedDialog({required void Function() onTap, String? title}) {
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
            content: OfferAvailedDialog(title: title, onConfirm: onTap),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
