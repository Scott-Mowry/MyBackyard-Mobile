import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/custom_bottom_sheet.dart';
import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/core/repositories/connectivity_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<T?> showWebViewBottomSheet<T>({required String url, required BuildContext context}) async {
  try {
    final connectivityRepository = getIt<ConnectivityRepository>();
    if (!connectivityRepository.hasInternetAccess) {
      showSnackbar(context: context, content: 'Ops... No internet connection');
      return null;
    }

    return showCustomBottomSheet<T>(
      context: context,
      child: CustomWebView(url: url, showCloseButton: true),
      height: MediaQuery.sizeOf(context).height * 0.93,
      routeName: 'WebViewRoute',
    );
  } catch (e, stackTrace) {
    throw AppInternalError(code: kShowBottomSheetWebViewErrorKey, error: e, stack: stackTrace);
  }
}

class CustomWebView extends StatefulWidget {
  final String url;
  final bool showCloseButton;

  const CustomWebView({super.key, required this.url, this.showCloseButton = false});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final webViewController = WebViewController();
  final gestureRecognizers = {const Factory(EagerGestureRecognizer.new)};
  final webViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    unawaited(EasyLoading.showProgress(0.0, status: 'Loading...'));
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(kWebviewUserAgent)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            EasyLoading.showProgress(progress / 100, status: '\nLoading...\n$progress%');
          },
          onPageFinished: (url) {
            Future.delayed(Duration(milliseconds: 500), EasyLoading.dismiss);
          },
          onWebResourceError: onWebResourceError,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        WebViewWidget(key: webViewKey, controller: webViewController, gestureRecognizers: gestureRecognizers),
        if (widget.showCloseButton)
          Positioned(
            top: CustomSpacer.top.sm.top,
            right: CustomSpacer.right.sm.right,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: CustomSpacer.all.xxs,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: CustomColors.black, size: 24),
              ),
            ),
          ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(height: 20, width: screenWidth, color: Colors.transparent),
        ),
      ],
    );
  }

  Future<void> onWebResourceError(WebResourceError error) async {
    await EasyLoading.dismiss();
    await context.maybePop<bool>(true);

    log('WebView error: ${error.description} (code: ${error.errorCode})');
    await launchUrlString(widget.url);
  }
}
