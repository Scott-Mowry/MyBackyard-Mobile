import 'dart:convert';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
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
  static const _appFirstUsed = 'appFirstUsed';

  static const String _tokenCredentialsKey = 'token-credentials';

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
  );

  @observable
  bool isFirstAppUse = false;

  Map<String, dynamic>? userCredentials = <String, dynamic>{};

  @action
  Future<void> init() async {
    try {
      // Deletes all values from FlutterSecureStorage if it's the app first use after install
      final sharedPrefs = await SharedPreferences.getInstance();
      if (!sharedPrefs.containsKey(_appFirstUsed)) {
        isFirstAppUse = true;
        await sharedPrefs.setBool(_appFirstUsed, true);
        await _secureStorage.deleteAll();
        return;
      }

      if (await _secureStorage.containsKey(key: _tokenCredentialsKey)) {
        final tokenCreds = await getUserCredentials();
        saveUserCredentialsInMemory(tokenCreds!);
      }
    } catch (error, stack) {
      throw AppInternalError(code: kLocalStorageInitErrorKey, error: error, stack: stack);
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userJsonRaw = await _secureStorage.read(key: 'user');
    if (userJsonRaw == null) return null;
    return json.decode(userJsonRaw);
  }

  @action
  void saveUserCredentialsInMemory(Map<String, dynamic> userData) => this.userCredentials = userData;

  @action
  Future<void> saveUserCredentials(Map<String, dynamic> userData) {
    saveUserCredentialsInMemory(userData);
    return _secureStorage.write(key: 'user', value: json.encode(userData));
  }

  Future<Map<String, dynamic>?> getUserCredentials() async {
    final inDiskCredentials = await _secureStorage.read(key: 'user');
    if (inDiskCredentials != null) return json.decode(inDiskCredentials);

    return userCredentials;
  }

  @action
  Future<void> deleteAll() async {
    userCredentials = null;
    await _secureStorage.deleteAll();
  }
}
