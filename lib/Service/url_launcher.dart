import 'dart:io';

import 'package:backyard/Service/general_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContentScreen extends StatefulWidget {
  final String? title, contentType;
  final Function(bool)? isMerchantSetupDone;

  const ContentScreen({super.key, this.title, this.contentType, this.isMerchantSetupDone});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  bool _isLoading = true;
  double? _opacity = 0;
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///ye uncomment karna beta ma
    // getData(context);
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (widget.contentType == 'Subscriptions') {
      url = 'https://mybackyardusa.com/#pricing';
      _opacity = 1.0;
      _isLoading = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.contentType != 'Subscriptions') {
        await getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(),
      body: Stack(
        children: [
          if (!_isLoading)
            Opacity(
              opacity: _opacity ?? 0,
              child: WebView(
                initialUrl: url,
                //AppStrings.WEB_VIEW_URL,
                onPageStarted: (url) {},
                onPageFinished: (url) {
                  setState(() {
                    _opacity = 1.0;
                    _isLoading = false;
                  });
                  // if(widget.getUrl!=null){
                  //   widget.getUrl!(url??"");
                  // }
                  // getUrl(url: url);
                },
                backgroundColor: Colors.white,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          Visibility(visible: _isLoading, child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // void getUrl({String? url}) async {
  //   try {
  //     if (widget.contentType == AppStrings.CREATE_MERCHANT) {
  //       if (url?.contains(AppStrings.PRIVACYPOLICY) == true) {
  //         AppNavigation.navigatorPop();
  //         widget.isMerchantSetupDone != null
  //             ? widget.isMerchantSetupDone!(true)
  //             : null;
  //       }
  //     }
  //   } catch (error) {
  //     Navigator.of(context).pop();
  //   }
  // }

  Future<void> getData() async {
    url = await GeneralAPIS.getContent(widget.contentType ?? '') ?? '';

    setState(() {
      _opacity = 1.0;
      _isLoading = false;
    });
  }

  AppBar? customAppBar() {
    return widget.contentType == AppStrings.CREATE_MERCHANT
        ? null
        : AppBar(
          backgroundColor: MyColors().black,
          leading: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              AppNavigation.navigatorPop();
            },
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: .6.h, horizontal: 1.h),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
              ),
            ),
          ),
          centerTitle: true,
          title: MyText(
            title:
                widget.contentType == AppStrings.TERMS_AND_CONDITION_TYPE
                    ? 'Terms & Conditions'
                    : widget.contentType == AppStrings.PRIVACY_POLICY_TYPE
                    ? 'Privacy Policy'
                    : widget.title ?? '',
            center: true,
            line: 2,
            size: 18,
            toverflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w700,
            clr: MyColors().whiteColor,
          ),
          elevation: 0,
        );
  }
}
