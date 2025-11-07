import 'dart:io';

import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/exception/app_exception_codes.dart';
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

  @observable
  UserProfileModel? currentUser;

  @computed
  bool get isAuthenticated => _localStorageRepository.userProfile != null;

  @action
  Future<UserProfileModel?> getUser() async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.getUser();
      if (userProfile?.isVerified ?? false) {
        await _localStorageRepository.saveUserCredentials(userProfile!);
        _userController.setUser(userProfile);
        currentUser = userProfile;
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kGetUserErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> signIn({required String email, required String password}) async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.postSignIn(email: email, password: password);
      if (userProfile?.isVerified ?? false) {
        await _localStorageRepository.saveUserCredentials(userProfile!);
        _userController.setUser(userProfile);
        currentUser = userProfile;
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kSignInErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> verifyAccount({required String otpCode, required int id}) async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.postVerifyAccount(otpCode: otpCode, id: id);
      if (userProfile != null && userProfile.isVerified) {
        await _localStorageRepository.saveUserCredentials(userProfile);
        _userController.setUser(userProfile);
        currentUser = userProfile;
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kVerifyAccountErrorKey, error: error, stack: stacktrace);
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
      final userProfile = await _userAuthService.postCompleteProfile(
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
        currentUser = userProfile;
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kCompleteProfileErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<bool> resendCode(String userId) async {
    try {
      await EasyLoading.show();
      await _userAuthService.postResendCode(userId);

      return true;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kResendCodeErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> forgotPassword({required String email}) async {
    try {
      await EasyLoading.show();
      final userProfile = await _userAuthService.postForgotPassword(email: email);
      if (userProfile != null) {
        await _localStorageRepository.saveUserCredentials(userProfile);
        _userController.setUser(userProfile);
        currentUser = userProfile;
      }

      return userProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kForgotPasswordErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<UserProfileModel?> changePassword({required String password}) async {
    try {
      await EasyLoading.show();

      final savedUser = await _localStorageRepository.getUserCredentials();
      final newUserProfile = await _userAuthService.postChangePassword(id: savedUser!.id!, password: password);
      if (newUserProfile != null) {
        await _localStorageRepository.saveUserCredentials(newUserProfile);
        _userController.setUser(newUserProfile);
        currentUser = newUserProfile;
      }

      return newUserProfile;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kChangePasswordErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<void> signOut() async {
    try {
      await EasyLoading.show();
      await _userAuthService.postSignOut();
      await _postSignOutCleanup();
    } catch (error, stacktrace) {
      await _postSignOutCleanup();
      throw AppInternalError(code: kSignOutErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _postSignOutCleanup() async {
    try {
      await _userController.clear();
      MyBackyardApp.appRouter.popUntilRoot();
      await MyBackyardApp.appRouter.replace<void>(LandingRoute());
    } catch (_) {}
  }

  Future<void> deleteAccount() async {
    try {
      await EasyLoading.show();
      await _userAuthService.postDeleteAccount();
      await _userController.clear();

      CustomToast().showToast(message: 'Account Deleted Successfully');

      MyBackyardApp.appRouter.popUntilRoot();
      return MyBackyardApp.appRouter.replace<void>(LandingRoute());
    } catch (error, stacktrace) {
      throw AppInternalError(code: kDeleteAccountErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
