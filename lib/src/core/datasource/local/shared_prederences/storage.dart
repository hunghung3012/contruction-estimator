import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../../../common/extension/optional_x.dart';
import 'storage_keys.dart';

class AppStorage {
  static late final SharedPreferences _prefs;
  static late final RxSharedPreferences _rxPrefs;
  static RxSharedPreferences get rxPrefs => _rxPrefs;

  static Future<void> setup() async {
    _prefs = await SharedPreferences.getInstance();

    /// A shared preference wrapper providing [Stream] for listening updates from shared preference by key
    _rxPrefs = RxSharedPreferences(
      _prefs,
      kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
    );
  }

  static T? _get<T>(String key) => _prefs.get(key).asOrNull<T>();

  /// set [notify] as 'true' if you want the updated value to be notified for stream subscriptions
  static Future<void> _set<T>(String key, T? val, {bool notify = false}) {
    if (val is bool) {
      return notify ? _rxPrefs.setBool(key, val) : _prefs.setBool(key, val);
    }
    if (val is double) {
      return notify ? _rxPrefs.setDouble(key, val) : _prefs.setDouble(key, val);
    }
    if (val is int) {
      return notify ? _rxPrefs.setInt(key, val) : _prefs.setInt(key, val);
    }
    if (val is String) {
      return notify ? _rxPrefs.setString(key, val) : _prefs.setString(key, val);
    }
    if (val is List<String>) {
      return notify
          ? _rxPrefs.setStringList(key, val)
          : _prefs.setStringList(key, val);
    }
    throw Exception('Type not supported!');
  }

  static String? get language => _get(AppStorageKeys.language);
  static Future setLanguage(String? val) => _set(AppStorageKeys.language, val);

  static bool get isFirstTimeOnApp =>
      _get(AppStorageKeys.isFirstTimeOnApp) ?? true;
  static Future setFirstTimeOnApp(bool? val) =>
      _set(AppStorageKeys.isFirstTimeOnApp, val);

  static String? get userId => _get(AppStorageKeys.userId);
  static Future setUserId(String? val) => _set(AppStorageKeys.userId, val);

  static Map<String, int> get statusColors {
    final jsonStr = _get<String>(AppStorageKeys.statusColors);
    if (jsonStr == null) return {};
    try {
      return Map<String, int>.from(json.decode(jsonStr));
    } catch (_) {
      return {};
    }
  }

  static Future setStatusColor(String id, int colorValue) {
    final map = statusColors;
    map[id] = colorValue;
    return _set(AppStorageKeys.statusColors, json.encode(map));
  }

  static Future<void> removeStatusColor(String id) async {
    final map = statusColors;
    map.remove(id);
    return _set(AppStorageKeys.statusColors, json.encode(map));
  }

  static String? get companyName => _get(AppStorageKeys.companyName);
  static Future setCompanyName(String? val) =>
      _set(AppStorageKeys.companyName, val);

  static String? get email => _get(AppStorageKeys.email);
  static Future setEmail(String? val) => _set(AppStorageKeys.email, val);

  static String? get phone => _get(AppStorageKeys.phone);
  static Future setPhone(String? val) => _set(AppStorageKeys.phone, val);

  static String? get address => _get(AppStorageKeys.address);
  static Future setAddress(String? val) => _set(AppStorageKeys.address, val);
}
