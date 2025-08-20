import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreference? _sharedPreferenceHelper;
  static SharedPreferences? _sharedPreferences;
  SharedPreference._createInstance();
  factory SharedPreference() {
    // factory with constructor, return some value
    _sharedPreferenceHelper ??= SharedPreference._createInstance();
    return _sharedPreferenceHelper!;
  }
  Future<SharedPreferences> get sharedPreference async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  ////////////////////// Clear Preference ///////////////////////////
  void clear() {
    _sharedPreferences?.clear();
  }

  ////////////////////// User ///////////////////////////
  Future<void> setUser({Map<String, dynamic>? user, String? token}) async {
    if (token != null) {
      user?.addAll({"bearer_token": token});
    }
    await _sharedPreferences?.setString("user", json.encode(user));
  }

  Future<void> saveUser({Map<String, dynamic>? user}) async {
    await _sharedPreferences?.setString("saved_user", json.encode(user));
  }

  Map<String, dynamic>? getSavedUser() {
    String? val = _sharedPreferences?.getString("saved_user");
    if (val != null) {
      return json.decode(val);
    } else {
      return null;
    }
  }

  Map<String, dynamic>? getUser() {
    String? val = _sharedPreferences?.getString("user");
    if (val != null) {
      return json.decode(val);
    } else {
      return null;
    }
  }
}
