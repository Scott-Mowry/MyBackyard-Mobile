import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/annotations.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Widget/Dialog/offer_availed.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ScanQRView extends StatefulWidget {
  final bool fromOffer;

  const ScanQRView({super.key, this.fromOffer = false});

  @override
  State<ScanQRView> createState() => _ScanQRViewState();
}

class _ScanQRViewState extends State<ScanQRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool scan = true;
  bool pause = false;

  Map<String, dynamic> get data => json.decode(result?.code ?? '') as Map<String, dynamic>;

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
    // TODO: implement initState
    super.initState();
    Permission.camera.request();
    if (widget.fromOffer) {
      // Timer(const Duration(seconds: 3), () {
      //   scannedDialog(onTap: () {
      //     AppNavigation.navigatorPop();
      //     AppNavigation.navigatorPop();
      //   });
      // });
    }
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
          // color:  MyColors().primaryColor,
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

                  // cutOutBottomOffset:100
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
                  textColor: pause ? CustomColors.whiteColor : CustomColors.whiteColor.withValues(alpha: .5),
                  borderColor: pause ? CustomColors.whiteColor : CustomColors.whiteColor.withValues(alpha: .5),
                  onTap:
                      pause
                          ? () async {
                            getIt<AppNetwork>().loadingProgressIndicator();
                            final val = await BusAPIS.claimOffer(offerId: data['offer'], userId: data['user_id']);
                            AppNavigation.navigatorPop();
                            if (val) {
                              scannedDialog(
                                title: data['title'],
                                onTap: () async {
                                  AppNavigation.navigatorPop();
                                  await controller?.resumeCamera();
                                  setState(() => [pause = false, result = null]);
                                },
                              );
                            }
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
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        setState(() => result = scanData);
        await controller.pauseCamera().then((value) => setState(() => pause = true));
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future scannedDialog({required Function onTap, String? title}) {
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
            content: OfferAvailedDialog(
              title: title,
              onYes: (v) {
                onTap();
              },
            ),
          ),
        );
      },
    );
  }
}
