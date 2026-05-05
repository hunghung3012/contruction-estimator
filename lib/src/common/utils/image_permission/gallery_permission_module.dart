import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

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

class GalleryPermissionModule {
  static Future<void> requestGalleryPermission(
    BuildContext context,
    VoidCallback? onPermissionGranted,
  ) async {
    final permission = await ImagePermissionUtil.getGalleryPermission();
    var status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      return showCupertinoDialog<void>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Request Permission'),
            content: Text('Photo access needed'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          );
        },
      );
    }
    return onPermissionGranted?.call();
  }
}
