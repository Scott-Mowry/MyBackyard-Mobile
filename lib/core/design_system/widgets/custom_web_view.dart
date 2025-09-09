import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/custom_bottom_sheet.dart';
import 'package:backyard/core/design_system/widgets/custom_loading_widget.dart';
import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> showWebViewBottomSheet({required String url, required BuildContext context}) async {
  try {
    return showCustomBottomSheet(
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
  bool isLoading = true;
  final webViewController = WebViewController();
  final gestureRecognizers = {const Factory(EagerGestureRecognizer.new)};
  final webViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await webViewController.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (error) {
            setState(() => isLoading = false);
          },
        ),
      );

      await webViewController.loadRequest(Uri.parse(widget.url));
    });
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
        if (isLoading) const CustomLoadingWidget(),
      ],
    );
  }
}
