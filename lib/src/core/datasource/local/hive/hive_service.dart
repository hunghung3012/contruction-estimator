import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveService {
  static const String logoBoxName = 'logoBox';
  static const String termsBoxName = 'termsBox';

  Future<void> setup() async {
    await Hive.initFlutter();
    await Hive.openBox(logoBoxName);
    await Hive.openBox(termsBoxName);
  }
}
