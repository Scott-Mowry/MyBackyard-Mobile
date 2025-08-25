import 'dart:convert';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/model/jwt_user_info.dart';
import 'package:backyard/core/model/token_credentials.dart';
import 'package:backyard/flavors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

  static const String _appBuildFlavorKey = 'app-build-flavor';
  static const String _tokenCredentialsKey = 'token-credentials';

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
  );

  @observable
  TokenCredentials? tokenCreds;

  @observable
  JwtUserInfo? jwtUserInfo;

  @observable
  bool isFirstAppUse = false;

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
        final tokenCreds = await getTokenCredentials();
        saveTokenCredentialsInMemory(tokenCreds!);
      }
    } catch (error, stack) {
      throw AppInternalError(code: kLocalStorageInitErrorKey, error: error, stack: stack);
    }
  }

  @action
  void saveTokenCredentialsInMemory(TokenCredentials tokenCreds) {
    final decodedToken = JwtDecoder.decode(tokenCreds.accessToken);
    decodedToken.addAll({
      'expiration_date': JwtDecoder.getExpirationDate(tokenCreds.accessToken).toIso8601String(),
      'token_time': JwtDecoder.getTokenTime(tokenCreds.accessToken).inMicroseconds,
    });

    jwtUserInfo = JwtUserInfo.fromJson(decodedToken);
    this.tokenCreds = tokenCreds;
  }

  @action
  Future<void> saveTokenCredentials(TokenCredentials tokenCreds) {
    saveTokenCredentialsInMemory(tokenCreds);
    return _secureStorage.write(key: _tokenCredentialsKey, value: json.encode(tokenCreds.toJson()));
  }

  Future<bool> hasTokensSavedOnDisk() async {
    final tokenCredsRaw = await _secureStorage.read(key: _tokenCredentialsKey);
    return tokenCredsRaw != null;
  }

  Future<TokenCredentials?> getTokenCredentials() async {
    final inDiskCredentials = await _secureStorage.read(key: _tokenCredentialsKey);
    if (inDiskCredentials != null) return TokenCredentials.fromJson(json.decode(inDiskCredentials));

    return tokenCreds;
  }

  Future<void> saveAppBuildFlavorOnDisk(AppBuildFlavorEnum appBuildFlavor) async {
    try {
      await _secureStorage.write(key: _appBuildFlavorKey, value: appBuildFlavor.name);
    } catch (error, stack) {
      throw AppInternalError(code: kSaveAppFlavorOnDiskErrorKey, error: error, stack: stack);
    }
  }

  Future<AppBuildFlavorEnum> getAppBuildFlavor() async {
    final flavorName = await _secureStorage.read(key: _appBuildFlavorKey);
    return AppBuildFlavorEnum.values.firstWhere((el) => el.name == flavorName);
  }

  @action
  Future<void> deleteAll() async {
    tokenCreds = null;
    jwtUserInfo = null;

    await _secureStorage.delete(key: _tokenCredentialsKey);
  }
}
