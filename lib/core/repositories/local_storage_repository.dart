import 'dart:convert';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_repository.g.dart';

@singleton
class LocalStorageRepository extends _LocalStorageRepository with _$LocalStorageRepository {
  // Explicitly defining a singleton pattern since this is used
  // when running background tasks and we need only one instance of that class
  static final LocalStorageRepository _instance = LocalStorageRepository._internal();

  factory LocalStorageRepository() => _instance;

  LocalStorageRepository._internal();
}

abstract class _LocalStorageRepository with Store {
  static const _appFirstUsedKey = 'appFirstUsed';
  static const _userCredentialsKey = 'user-credentials';

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
  );

  @observable
  bool isFirstAppUse = false;

  UserProfileModel? userProfile = null;

  @action
  Future<void> init() async {
    try {
      // Deletes all values from FlutterSecureStorage if it's the app first use after install
      final sharedPrefs = await SharedPreferences.getInstance();
      if (!sharedPrefs.containsKey(_appFirstUsedKey)) {
        isFirstAppUse = true;
        await sharedPrefs.setBool(_appFirstUsedKey, true);
        await _secureStorage.deleteAll();
        return;
      }

      if (await _secureStorage.containsKey(key: _userCredentialsKey)) {
        final userCredentials = await getUserCredentials();
        saveUserCredentialsInMemory(userCredentials!);
      }
    } catch (error, stack) {
      throw AppInternalError(code: kLocalStorageInitErrorKey, error: error, stack: stack);
    }
  }

  Future<UserProfileModel?> getUser() async {
    final userJsonRaw = await _secureStorage.read(key: _userCredentialsKey);
    if (userJsonRaw == null) return null;

    final userJson = json.decode(userJsonRaw);
    return UserProfileModel.fromJson(userJson);
  }

  @action
  void saveUserCredentialsInMemory(UserProfileModel userProfile) => this.userProfile = userProfile;

  @action
  Future<void> saveUserCredentials(UserProfileModel userProfile) {
    final bearerToken =
        userProfile.bearerToken != null && userProfile.bearerToken!.isNotEmpty
            ? userProfile.bearerToken
            : this.userProfile?.bearerToken;

    final userToSave = userProfile.copyWith(bearerToken: bearerToken);

    saveUserCredentialsInMemory(userToSave);
    return _secureStorage.write(key: _userCredentialsKey, value: json.encode(userToSave.toJson()));
  }

  Future<UserProfileModel?> getUserCredentials() async {
    final inDiskCredentials = await _secureStorage.read(key: _userCredentialsKey);
    if (inDiskCredentials != null) return UserProfileModel.fromJson(json.decode(inDiskCredentials));

    return userProfile;
  }

  @action
  Future<void> deleteAll() async {
    userProfile = null;
    await _secureStorage.deleteAll();
  }
}
