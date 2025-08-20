import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/Widget/Dialog/offer_availed.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:sizer/sizer.dart';

class ScanQR extends StatefulWidget {
  bool fromOffer = false;
  ScanQR({this.fromOffer = false});
  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool scan = true;
  bool pause = false;

  Map<String, dynamic> get data =>
      json.decode(result?.code ?? "") as Map<String, dynamic>;
  // decryption(result?.code ?? "")

  // String decryption(String val) {
  //   return Encrypter(AES(Utils.key, padding: null))
  //       .decrypt64(val, iv: Utils.iv);
  // }

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
        backColor: MyColors().whiteColor,
        screenTitleColor: MyColors().whiteColor,
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        bottomSafeArea: false,
        backgroundColor: MyColors().primaryColor,
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
                  onPermissionSet: (p0, p1) =>
                      _onPermissionSet(context, p0, p1),
                  overlay: QrScannerOverlayShape(
                    borderColor: MyColors().whiteColor,
                    borderRadius: 10,
                    borderLength: 130,
                    borderWidth: 10,
                    overlayColor: MyColors().primaryColor,

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
                      textColor: pause
                          ? MyColors().whiteColor
                          : MyColors().whiteColor.withOpacity(.5),
                      borderColor: pause
                          ? MyColors().whiteColor
                          : MyColors().whiteColor.withOpacity(.5),
                      onTap: pause
                          ? () async {
                              AppNetwork.loadingProgressIndicator();
                              final val = await BusAPIS.claimOffer(
                                  offerId: data["offer"],
                                  userId: data["user_id"]);
                              AppNavigation.navigatorPop();
                              if (val) {
                                scannedDialog(
                                    title: data["title"],
                                    onTap: () async {
                                      AppNavigation.navigatorPop();
                                      await controller?.resumeCamera();
                                      setState(
                                          () => [pause = false, result = null]);
                                    });
                              }
                            }
                          : () {}),
                ),
              ],
            ),
          ),
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        setState(() => result = scanData);
        print("DATA: ${data["title"]},${data["offer"]},${data["user_id"]}");
        await controller
            .pauseCamera()
            .then((value) => setState(() => pause = true));
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  scannedDialog({required Function onTap, String? title}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
        });
  }
}
