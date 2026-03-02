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

  static String? get lang => _get(AppStorageKeys.lang);
  static Future setLang(String? val) => _set(AppStorageKeys.lang, val);
 
  static bool get isFirstTimeOnApp => _get(AppStorageKeys.isFirstTimeOnApp) ?? true;
  static Future setFirstTimeOnApp(bool? val) => _set(AppStorageKeys.isFirstTimeOnApp, val);
  
}
