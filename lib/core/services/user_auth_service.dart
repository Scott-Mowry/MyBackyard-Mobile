import 'dart:io';

import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

abstract class UserAuthService {
  Future<UserProfileModel?> getUser();

  Future<UserProfileModel?> postSignIn({required String email, required String password});

  Future<UserProfileModel?> postForgotPassword({required String email});

  Future<UserProfileModel?> postChangePassword({required int id, required String password});

  Future<UserProfileModel?> postVerifyAccount({required String otpCode, required int id});

  Future<UserProfileModel?> postCompleteProfile({
    String? fullName,
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

  Future<void> postResendCode(String userId);

  Future<void> postSignOut();

  Future<void> postDeleteAccount();
}

@Injectable(as: UserAuthService)
class UserAuthServiceImpl implements UserAuthService {
  final ApiClient _apiClient;

  const UserAuthServiceImpl(@Named(kMyBackyardApiClient) this._apiClient);

  @override
  Future<UserProfileModel?> getUser() async {
    final res = await _apiClient.get(API.USER);
    final respModel = ResponseModel.fromJson(res.data);
    final user = UserProfileModel.fromJson(respModel.data?['user']);
    return user;
  }

  @override
  Future<UserProfileModel?> postSignIn({required String email, required String password, String? deviceToken}) async {
    final payload = {
      'email': email,
      'password': password,
      'devicetoken': deviceToken ?? '',
      'devicetype': Platform.isAndroid ? 'android' : 'ios',
    };

    final res = await _apiClient.post(API.SIGN_IN_ENDPOINT, data: payload);
    final respModel = ResponseModel.fromJson(res.data);
    final user = UserProfileModel.fromJson(respModel.data?['user']);
    return user;
  }

  @override
  Future<UserProfileModel?> postVerifyAccount({required String otpCode, required int id, String? deviceToken}) async {
    final bodyPayload = {
      'otp': otpCode,
      'user_id': id.toString(),
      'devicetoken': deviceToken ?? '',
      'devicetype': Platform.isAndroid ? 'android' : 'ios',
    };

    final resp = await _apiClient.post(API.VERIFY_ACCOUNT_ENDPOINT, data: bodyPayload);
    final respModel = ResponseModel.fromJson(resp.data);
    final user = UserProfileModel.fromJson(respModel.data?['user']);
    return user;
  }

  @override
  Future<UserProfileModel?> postCompleteProfile({
    String? fullName,
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

    final respModel = ResponseModel.fromJson(resp.data!);
    final user = UserProfileModel.fromJson(respModel.data?['user']);
    return user;
  }

  @override
  Future<UserProfileModel?> postForgotPassword({required String email}) async {
    final resp = await _apiClient.post(API.FORGOT_PASSWORD_ENDPOINT, data: {'email': email});
    final respModel = ResponseModel.fromJson(resp.data);
    final user = UserProfileModel.fromJson(respModel.data?['user']);
    return user;
  }

  @override
  Future<UserProfileModel?> postChangePassword({required int id, required String password}) async {
    final resp = await _apiClient.post(API.CHANGE_PASSWORD_ENDPOINT, data: {'id': id.toString(), 'password': password});

    final respModel = ResponseModel.fromJson(resp.data);
    final user = UserProfileModel.fromJson(respModel.data?['user']);
    return user;
  }

  @override
  Future<void> postResendCode(String userId) {
    return _apiClient.post(API.RESEND_OTP_ENDPOINT, data: {'user_id': userId});
  }

  @override
  Future<void> postSignOut() => _apiClient.post(API.SIGN_OUT_ENDPOINT);

  @override
  Future<void> postDeleteAccount() => _apiClient.post(API.DELETE_ACCOUNT_ENDPOINT);

  TimeOfDay _get24hour(String val) {
    var hour = int.parse(val.split(':').first);
    final minute = int.parse(val.split(':').last.split(' ').first);

    if (val.split(':').last.split(' ').last == 'AM' && hour == 12) hour = 0;
    if (val.split(':').last.split(' ').last == 'PM' && hour != 12) hour += 12;

    return TimeOfDay(hour: hour, minute: minute);
  }
}
