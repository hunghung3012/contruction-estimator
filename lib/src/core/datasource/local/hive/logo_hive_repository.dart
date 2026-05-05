import 'dart:io';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'hive_service.dart';

@lazySingleton
class LogoHiveRepository {
  static const String _logoKey = 'company_logo';

  final Box _box;

  LogoHiveRepository() : _box = Hive.box(HiveService.logoBoxName);

  Future<void> save(File imageFile) async {
    final Uint8List bytes = await imageFile.readAsBytes();
    await _box.put(_logoKey, bytes);
  }

  Uint8List? get() {
    return _box.get(_logoKey) as Uint8List?;
  }

  Future<void> delete() async {
    await _box.delete(_logoKey);
  }
}
