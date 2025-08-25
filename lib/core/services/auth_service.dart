import 'dart:developer';
import 'dart:io';

import 'package:backyard/boot.dart';
import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

abstract class AuthService {
  Future<bool> signIn({required String email, required String password});

  Future<bool> forgotPassword({required String email});

  Future<bool> changePassword({required int id, required String password});

  Future<bool> verifyAccount({required String otpCode, required int id});

  Future<bool> completeProfile({
    String? firstName,
    String? isPushNotify,
    String? lastName,
    String? zipCode,
    String? address,
    String? email,
    String? phone,
    String? description,
    String? subId,
    double? lat,
    double? long,
    String? role,
    int? categoryId,
    List<BussinessScheduling>? days,
    File? image,
  });

  Future<bool> resendCode({String? id});

  Future<void> signOut();

  Future<bool> socialLogin({String? socialToken, String? socialType, String? name, String? email, String? phone});

  Future<void> deleteAccount();
}

@Injectable(as: AuthService)
class AuthServiceImpl implements AuthService {
  final ApiClient _apiClient;
  final AppNetwork _appNetwork;
  final LocalStorageRepository _localStorageRepository;

  const AuthServiceImpl(@Named(kMyBackyardApiClient) this._apiClient, this._appNetwork, this._localStorageRepository);

  @override
  Future<bool> signIn({required String email, required String password, String? deviceToken}) async {
    try {
      final payload = {
        'email': email,
        'password': password,
        'devicetoken': deviceToken ?? '',
        'devicetype': Platform.isAndroid ? 'android' : 'ios',
      };

      final res = await _apiClient.post(API.SIGN_IN_ENDPOINT, data: payload);

      final respModel = ResponseModel.fromJson(res.data);
      if (respModel.status != 1) {
        CustomToast().showToast(message: respModel.message ?? '');
        return false;
      }

      navigatorKey.currentContext?.read<UserController>().setUser(User.setUser2(respModel.data?['user']));
      if (respModel.data?['user']['is_profile_completed'] == 1 && respModel.data?['user']['is_verified'] == 1) {
        await _localStorageRepository.deleteAll();
        await _localStorageRepository.setUser(respModel.data?['user']);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      final res = await _apiClient.post(API.FORGOT_PASSWORD_ENDPOINT, data: {'email': email});
      final model = ResponseModel.fromJson(res.data);
      if (model.status != 1) {
        CustomToast().showToast(message: model.message ?? '');
        return false;
      }

      navigatorKey.currentContext?.read<UserController>().setUser(User.setUser(model.data?['user']));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> changePassword({required int id, required String password}) async {
    try {
      final res = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.CHANGE_PASSWORD_ENDPOINT,
        parameters: {'id': id.toString(), 'password': password},
      );

      if (res == null) return false;

      final model = responseModelFromJson(res.body);
      if (res.statusCode != 1) {
        CustomToast().showToast(message: model.message ?? '');
        return false;
      }

      navigatorKey.currentContext?.read<UserController>().setUser(User.setUser(model.data?['user']));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> verifyAccount({required String otpCode, required int id, String? deviceToken}) async {
    try {
      final res = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.VERIFY_ACCOUNT_ENDPOINT,
        parameters: {
          'otp': otpCode,
          'user_id': id.toString(),
          'devicetoken': deviceToken ?? '',
          'devicetype': Platform.isAndroid ? 'android' : 'ios',
        },
      );

      if (res == null) return false;

      final model = responseModelFromJson(res.body);
      if (model.status != 1) {
        CustomToast().showToast(message: model.message ?? '');
        return false;
      }

      navigatorKey.currentContext?.read<UserController>().setUser(User.setUser2(model.data?['user']));
      if (model.data?['user']['is_profile_completed'] == 1) {
        await _localStorageRepository.deleteAll();
        await _localStorageRepository.setUser(model.data?['user']);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> completeProfile({
    String? firstName,
    String? isPushNotify,
    String? lastName,
    String? zipCode,
    String? address,
    String? email,
    String? phone,
    String? description,
    String? subId,
    double? lat,
    double? long,
    String? role,
    int? categoryId,
    List<BussinessScheduling>? days,
    File? image,
  }) async {
    try {
      final parameters = <String, String>{};
      final attachments = <http.MultipartFile>[];
      if (role != null) parameters.addAll({'role': role});
      if (firstName != null) parameters.addAll({'name': firstName});
      if (lastName != null) parameters.addAll({'last_name': lastName});
      if (subId != null) parameters.addAll({'sub_id': subId});
      if (categoryId != null) parameters.addAll({'category_id': categoryId.toString()});

      if (days != null) {
        final formatter = NumberFormat('00');
        for (var i = 0; i < days.length; i++) {
          if (days[i].startTime != null) {
            parameters.addAll({
              'days[$i][day]': days[i].day ?? '',
              'days[$i][start_time]':
                  '${formatter.format(_get24hour(days[i].startTime ?? "").hour)}:${formatter.format(_get24hour(days[i].startTime ?? "").minute)}',
              'days[$i][end_time]':
                  '${formatter.format(_get24hour(days[i].endTime ?? "").hour)}:${formatter.format(_get24hour(days[i].endTime ?? "").minute)}',
            });
          }
        }
      }

      if (email != null) parameters.addAll({'email': email});
      if (phone != null) parameters.addAll({'phone': phone});
      if (isPushNotify != null) parameters.addAll({'is_push_notify': isPushNotify});
      if (zipCode != null) parameters.addAll({'zip_code': zipCode});
      if (address != null) parameters.addAll({'address': address});
      if (description != null) parameters.addAll({'description': description});
      if (lat != null) parameters.addAll({'latitude': lat.toString()});
      if (long != null) parameters.addAll({'longitude': long.toString()});
      if (image != null) attachments.add(await http.MultipartFile.fromPath('profile_image', image.path));

      final res = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.COMPLETE_PROFILE_ENDPOINT,
        parameters: parameters,
        attachments: attachments,
      );

      if (res == null) return false;

      final model = responseModelFromJson(res.body);
      CustomToast().showToast(message: model.message ?? '');
      if (model.status != 1) return false;

      navigatorKey.currentContext?.read<UserController>().setUser(User.setUser(model.data?['user']), isNotToken: true);

      await _localStorageRepository.deleteAll();
      await _localStorageRepository.setUser(model.data?['user']);
      return true;
    } catch (e) {
      return false;
    }
  }

  TimeOfDay _get24hour(String val) {
    var hour = int.parse(val.split(':').first);
    final minute = int.parse(val.split(':').last.split(' ').first);

    if (val.split(':').last.split(' ').last == 'AM') {
      if (hour == 12) hour = 0;
    }

    if (val.split(':').last.split(' ').last == 'PM') {
      if (hour != 12) hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Future<bool> resendCode({String? id}) async {
    try {
      final res = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.RESEND_OTP_ENDPOINT,
        parameters: {'user_id': id ?? ''},
      );

      if (res == null) return false;

      final model = responseModelFromJson(res.body);
      if (model.status != 1) {
        CustomToast().showToast(message: model.message ?? '');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _appNetwork.loadingProgressIndicator();
      final res = await _appNetwork.networkRequest(RequestTypeEnum.POST.name, API.SIGN_OUT_ENDPOINT);
      AppNavigation.navigatorPop();

      if (res == null) return;

      final model = responseModelFromJson(res.body);
      if (model.status != 1) {
        CustomToast().showToast(message: model.message ?? '');
        return;
      }

      await navigatorKey.currentContext?.read<UserController>().clear();
      await AppNavigation.navigateToRemovingAll(AppRouteName.SPLASH_SCREEN_ROUTE);
      CustomToast().showToast(message: 'Logout Successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> socialLogin({
    String? socialToken,
    String? socialType,
    String? name,
    String? email,
    String? phone,
    String? deviceToken,
  }) async {
    try {
      String? firstName;
      String? lastName;
      if (name != null && (name).contains(' ')) {
        firstName = (name).split(' ').first;
        lastName = (name).split(' ').last;
      } else {
        firstName = (name ?? '');
        lastName = (name ?? '');
      }
      final res = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.SOCIAL_LOGIN_ENDPOINT,
        parameters: {
          'first_name': firstName,
          'last_name': lastName,
          'social_token': socialToken ?? '',
          'social_type': socialType ?? '',
          'device_type': Platform.isAndroid ? 'android' : 'ios',
          'device_token': deviceToken ?? '',
          'role': navigatorKey.currentContext?.read<UserController>().user?.role?.name ?? '',
          'phone': phone ?? '',
        },
      );

      if (res == null) return false;

      final model = responseModelFromJson(res.body);
      CustomToast().showToast(message: model.message ?? '');

      if (model.status != 1) return false;

      navigatorKey.currentContext?.read<UserController>().setUser(
        User.setUser2(model.data?['user'], token: model.data?['bearer_token']),
      );
      if (socialType == 'phone') {
        final user = navigatorKey.currentContext?.read<UserController>().user;
        user?.phone = phone;
        navigatorKey.currentContext?.read<UserController>().setUser(user!);
      }
      if (model.data?['user']['is_profile_completed'] == 1) {
        if ((model.data['isDeleted'] ?? 0) == 0) {
          await _localStorageRepository.deleteAll();
          await _localStorageRepository.setUser(model.data?['user']);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      _appNetwork.loadingProgressIndicator();
      final res = await _appNetwork.networkRequest(RequestTypeEnum.POST.name, API.DELETE_ACCOUNT_ENDPOINT);
      AppNavigation.navigatorPop();

      if (res == null) return;

      final model = responseModelFromJson(res.body);
      if (model.status != 1) {
        CustomToast().showToast(message: model.message ?? '');
        return;
      }

      await navigatorKey.currentContext?.read<UserController>().clear();
      await AppNavigation.navigateToRemovingAll(AppRouteName.SPLASH_SCREEN_ROUTE);
      CustomToast().showToast(message: 'Account Deleted Successfully');
    } catch (e) {
      log(e.toString());
    }
  }
}
