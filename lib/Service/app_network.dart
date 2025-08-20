import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Service/api.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AppNetwork {
  static Future<bool> checkInternet() async {
    late bool internet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
      }
    } on SocketException catch (_) {
      internet = false;
    }
    return internet;
  }

  static FutureOr<Response?> networkRequest(String type, String path,
      {Map<String, String>? parameters,
      List<MultipartFile>? attachments,
      bool header = false}) async {
    try {
      if (await checkInternet()) {
        dynamic request = type == requestTypes.POST.name
            ? MultipartRequest(type, Uri.parse('${API.url}$path'))
            : Request(type, Uri.parse('${API.url}$path'));
        request.headers.addAll({'Content-Type': 'application/json'});
        if (parameters != null) {
          // if ((type == requestTypes.POST.name ||
          //         type == requestTypes.PUT.name) &&
          //     attachments != null) {
          request.fields.addAll(parameters);
          // } else {
          //   request.body = json.encode(parameters);
          // }
        }
        if (attachments != null) {
          if (attachments.isNotEmpty) {
            request.files.addAll(attachments);
          }
        }
        if (header) {
          request.headers.addAll({
            'Authorization':
                'Bearer ${navigatorKey.currentContext?.read<UserController>().user?.token ?? ""}',
            'Accept': 'application/json'
          });
          log('HEADER: ${request.headers.toString()}');
        }
        log('API URL:${API.url}$path');
        if (parameters != null) {
          log('PARAMETERS: $parameters');
        }
        StreamedResponse response =
            await request.send().timeout(API.timeout, onTimeout: () {
          CustomToast().showToast(message: "Network Error");
          throw TimeoutException;
        });
        log("STATUS CODE: ${response.statusCode}");
        if (response.statusCode == 401) {
          if (header) {
            on401Error();
          }
        } else {
          final res = await Response.fromStream(response);
          log("RESPONSE: ${res.body}");
          return res;
        }
      } else {
        CustomToast().showToast(message: "No Internet Connection");
      }
    } catch (e) {
      CustomToast().showToast(message: e.toString());
    }
    return null;
  }

  static on401Error() {
    Timer(const Duration(seconds: 1), () {
      navigatorKey.currentContext?.read<UserController>().clear();
      Navigator.of(navigatorKey.currentContext!)
          .popUntil((route) => route.isFirst);
      Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
          AppRouteName.SPLASH_SCREEN_ROUTE
          );
    });
  }

  static void loadingProgressIndicator({double? value}) {
    showDialog(
      barrierDismissible: false,
      barrierColor: const Color(0XFF22093C).withOpacity(.5),
      builder: (ctx) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            backgroundColor: MyColors().primaryColor,
            value: value,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
      context: navigatorKey.currentContext!,
    );
  }
}
