import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePermissionUtil {
  static Future<Permission> getGalleryPermission() async {
    if (Platform.isIOS) {
      return Permission.photos;
    }

    // Android
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      return Permission.photos; // Android 13+
    } else {
      return Permission.storage; // Android <13
    }
  }
}
