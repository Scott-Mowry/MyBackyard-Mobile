import 'dart:developer';
import 'dart:io';

import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

abstract class UserAuthService {
  Future<bool> signIn({required String email, required String password});

  Future<bool> forgotPassword({required String email});

  Future<bool> changePassword({required int id, required String password});

  Future<bool> verifyAccount({required String otpCode, required int id});

  Future<bool> completeProfile({
    String? fullName,
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
    List<BusinessSchedulingModel>? days,
    File? image,
  });

  Future<bool> resendCode({String? id});

  Future<void> signOut();

  Future<void> deleteAccount();
}

@Injectable(as: UserAuthService)
class UserAuthServiceImpl implements UserAuthService {
  final ApiClient _apiClient;
  final AppNetwork _appNetwork;
  final LocalStorageRepository _localStorageRepository;

  const UserAuthServiceImpl(
    @Named(kMyBackyardApiClient) this._apiClient,
    this._appNetwork,
    this._localStorageRepository,
  );

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
      if (!respModel.status) {
        CustomToast().showToast(message: respModel.message ?? '');
        return false;
      }

      final user = UserProfileModel.fromJson(respModel.data?['user']);
      getIt<UserController>().setUser(user);
      if (user.isVerified) {
        await _localStorageRepository.deleteAll();
        await _localStorageRepository.saveUserCredentials(user);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      final resp = await _apiClient.post(API.FORGOT_PASSWORD_ENDPOINT, data: {'email': email});
      final respModel = ResponseModel.fromJson(resp.data);
      if (!respModel.status) {
        CustomToast().showToast(message: respModel.message ?? '');
        return false;
      }

      final user = UserProfileModel.fromJson(respModel.data?['user']);
      getIt<UserController>().setUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> changePassword({required int id, required String password}) async {
    try {
      final resp = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.CHANGE_PASSWORD_ENDPOINT,
        parameters: {'id': id.toString(), 'password': password},
      );

      if (resp == null) return false;

      final respModel = responseModelFromJson(resp.body);
      if (resp.statusCode != 1) {
        CustomToast().showToast(message: respModel.message ?? '');
        return false;
      }

      final user = UserProfileModel.fromJson(respModel.data?['user']);
      getIt<UserController>().setUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> verifyAccount({required String otpCode, required int id, String? deviceToken}) async {
    try {
      final resp = await _appNetwork.networkRequest(
        RequestTypeEnum.POST.name,
        API.VERIFY_ACCOUNT_ENDPOINT,
        parameters: {
          'otp': otpCode,
          'user_id': id.toString(),
          'devicetoken': deviceToken ?? '',
          'devicetype': Platform.isAndroid ? 'android' : 'ios',
        },
      );

      if (resp == null) return false;

      final respModel = responseModelFromJson(resp.body);
      if (!respModel.status) {
        CustomToast().showToast(message: respModel.message ?? '');
        return false;
      }

      final user = UserProfileModel.fromJson(respModel.data?['user']);
      getIt<UserController>().setUser(user);
      if (user.isProfileCompleted) {
        await _localStorageRepository.deleteAll();
        await _localStorageRepository.saveUserCredentials(user);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> completeProfile({
    String? fullName,
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
    List<BusinessSchedulingModel>? days,
    File? image,
  }) async {
    try {
      final bodyPayload = <String, dynamic>{};
      if (role != null) bodyPayload['role'] = role;
      if (fullName != null) bodyPayload['name'] = fullName;
      if (lastName != null) bodyPayload['last_name'] = lastName;
      if (subId != null) bodyPayload['sub_id'] = subId;
      if (categoryId != null) bodyPayload['category_id'] = categoryId.toString();

      if (days != null) {
        final formatter = NumberFormat('00');
        for (var i = 0; i < days.length; i++) {
          if (days[i].startTime != null) {
            bodyPayload.addAll({
              'days[$i][day]': days[i].day ?? '',
              'days[$i][start_time]':
                  '${formatter.format(_get24hour(days[i].startTime ?? "").hour)}:${formatter.format(_get24hour(days[i].startTime ?? "").minute)}',
              'days[$i][end_time]':
                  '${formatter.format(_get24hour(days[i].endTime ?? "").hour)}:${formatter.format(_get24hour(days[i].endTime ?? "").minute)}',
            });
          }
        }
      }

      if (email != null) bodyPayload['email'] = email;
      if (phone != null) bodyPayload['phone'] = phone;
      if (isPushNotify != null) bodyPayload['is_push_notify'] = isPushNotify;
      if (zipCode != null) bodyPayload['zip_code'] = zipCode;
      if (address != null) bodyPayload['address'] = address;
      if (description != null) bodyPayload['description'] = description;
      if (lat != null) bodyPayload['latitude'] = lat.toString();
      if (long != null) bodyPayload['longitude'] = long.toString();
      if (image != null) {
        final imgPath = image.path;
        bodyPayload['profile_image'] = await MultipartFile.fromFile(imgPath, filename: imgPath.split('/').last);
      }

      final formData = FormData.fromMap(bodyPayload);
      final options = Options(headers: {HttpHeaders.contentTypeHeader: 'multipart/form-data'});

      final resp = await _apiClient.post(API.COMPLETE_PROFILE_ENDPOINT, data: formData, options: options);
      if (resp.data == null) return false;

      final respModel = ResponseModel.fromJson(resp.data!);
      CustomToast().showToast(message: respModel.message ?? '');
      if (!respModel.status) return false;

      final user = UserProfileModel.fromJson(respModel.data?['user']);
      getIt<UserController>().setUser(user);

      await _localStorageRepository.deleteAll();
      await _localStorageRepository.saveUserCredentials(user);
      return true;
    } catch (e) {
      return false;
    }
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
      if (!model.status) {
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
      await MyBackyardApp.appRouter.maybePop();

      if (res == null) return;

      final model = responseModelFromJson(res.body);
      if (!model.status) {
        CustomToast().showToast(message: model.message ?? '');
        return;
      }

      await getIt<UserController>().clear();
      await MyBackyardApp.appRouter.push(LandingRoute());

      CustomToast().showToast(message: 'Logout Successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      _appNetwork.loadingProgressIndicator();
      final res = await _appNetwork.networkRequest(RequestTypeEnum.POST.name, API.DELETE_ACCOUNT_ENDPOINT);
      await MyBackyardApp.appRouter.maybePop();

      if (res == null) return;

      final model = responseModelFromJson(res.body);
      if (!model.status) {
        CustomToast().showToast(message: model.message ?? '');
        return;
      }

      await getIt<UserController>().clear();
      await MyBackyardApp.appRouter.push(LandingRoute());

      CustomToast().showToast(message: 'Account Deleted Successfully');
    } catch (e) {
      log(e.toString());
    }
  }

  TimeOfDay _get24hour(String val) {
    var hour = int.parse(val.split(':').first);
    final minute = int.parse(val.split(':').last.split(' ').first);

    if (val.split(':').last.split(' ').last == 'AM' && hour == 12) hour = 0;
    if (val.split(':').last.split(' ').last == 'PM' && hour != 12) hour += 12;

    return TimeOfDay(hour: hour, minute: minute);
  }
}
