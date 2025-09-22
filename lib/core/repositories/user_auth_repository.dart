import 'dart:io';

import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/core/services/user_auth_service.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'user_auth_repository.g.dart';

@singleton
class UserAuthRepository = _UserAuthRepository with _$UserAuthRepository;

abstract class _UserAuthRepository with Store {
  final UserController _userController;
  final LocalStorageRepository _localStorageRepository;
  final UserAuthService _userAuthService;

  _UserAuthRepository(this._userController, this._localStorageRepository, this._userAuthService);

  @computed
  bool get isAuthenticated => _localStorageRepository.userProfile != null;

  @action
  Future<UserProfileModel?> signIn({required String email, required String password}) async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.signIn(email: email, password: password);
      if (userProfile?.isVerified ?? false) {
        await _localStorageRepository.saveUserCredentials(userProfile!);
        _userController.setUser(userProfile);
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'SIGN_IN_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> verifyAccount({required String otpCode, required int id}) async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.verifyAccount(otpCode: otpCode, id: id);
      if (userProfile != null && userProfile.isVerified) {
        await _localStorageRepository.saveUserCredentials(userProfile);
        _userController.setUser(userProfile);
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'VERIFY_ACCOUNT_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> completeProfile({
    String? fullName,
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
      await EasyLoading.show();
      final userProfile = await _userAuthService.completeProfile(
        fullName: fullName,
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

      if (userProfile != null) {
        await _localStorageRepository.saveUserCredentials(userProfile);
        _userController.setUser(userProfile);
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'COMPLETE_PROFILE_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<bool> resendCode(String userId) async {
    try {
      await EasyLoading.show();
      await _userAuthService.resendCode(userId);

      return true;
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'RESEND_CODE_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> forgotPassword({required String email}) async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.forgotPassword(email: email);
      if (userProfile != null) {
        await _localStorageRepository.saveUserCredentials(userProfile);
        _userController.setUser(userProfile);
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'FORGOT_PASSWORD_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> changePassword({required String password}) async {
    try {
      await EasyLoading.show();

      final currentUser = await _localStorageRepository.getUserCredentials();
      final newUserProfile = await _userAuthService.changePassword(id: currentUser!.id!, password: password);
      if (newUserProfile != null) {
        await _localStorageRepository.saveUserCredentials(newUserProfile);
        _userController.setUser(newUserProfile);
      }

      return newUserProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'CHANGE_PASSWORD_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<void> signOut() async {
    try {
      await EasyLoading.show();
      await _userAuthService.signOut();
      await _userController.clear();

      MyBackyardApp.appRouter.popUntilRoot();
      return MyBackyardApp.appRouter.replace<void>(LandingRoute());
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'SIGN_OUT_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> deleteAccount() async {
    try {
      await EasyLoading.show();
      await _userAuthService.deleteAccount();
      await _userController.clear();

      CustomToast().showToast(message: 'Account Deleted Successfully');

      MyBackyardApp.appRouter.popUntilRoot();
      return MyBackyardApp.appRouter.replace<void>(LandingRoute());
    } catch (error, stacktrace) {
      throw AppInternalError(code: 'DELETE_ACCOUNT_ERROR', error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
