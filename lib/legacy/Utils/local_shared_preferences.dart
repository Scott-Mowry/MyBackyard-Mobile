import 'dart:convert';

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

  Map<String, dynamic>? getUser() {
    final val = _sharedPreferences?.getString('user');
    if (val != null) {
      return json.decode(val);
    } else {
      return null;
    }
  }
}
