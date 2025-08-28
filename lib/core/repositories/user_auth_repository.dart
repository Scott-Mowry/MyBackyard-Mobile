import 'dart:developer';
import 'dart:io';

import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/core/services/user_auth_service.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'user_auth_repository.g.dart';

@singleton
class UserAuthRepository = _UserAuthRepository with _$UserAuthRepository;

abstract class _UserAuthRepository with Store {
  final LocalStorageRepository _localStorageRepository;
  final UserAuthService _userAuthService;

  _UserAuthRepository(this._localStorageRepository, this._userAuthService);

  @computed
  bool get isAuthenticated => _localStorageRepository.userCredentials != null;

  @action
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final result = _userAuthService.signIn(email: email, password: password);
      return result;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> forgotPassword({required String email}) async {
    try {
      final result = _userAuthService.forgotPassword(email: email);
      return result;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> changePassword({required int id, required String password}) async {
    try {
      final result = _userAuthService.changePassword(id: id, password: password);
      return result;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> verifyAccount({required String otpCode, required int id}) async {
    try {
      final result = _userAuthService.verifyAccount(otpCode: otpCode, id: id);
      return result;
    } catch (e) {
      return false;
    }
  }

  @action
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
      final result = await _userAuthService.completeProfile(
        firstName: firstName,
        isPushNotify: isPushNotify,
        lastName: lastName,
        zipCode: zipCode,
        address: address,
        email: email,
        phone: phone,
        description: description,
        subId: subId,
        lat: lat,
        long: long,
        role: role,
        categoryId: categoryId,
        days: days,
        image: image,
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> resendCode({String? id}) async {
    try {
      final result = await _userAuthService.resendCode(id: id);
      return result;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<void> signOut() async {
    try {
      await _userAuthService.signOut();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _userAuthService.deleteAccount();
    } catch (e) {
      log(e.toString());
    }
  }
}
