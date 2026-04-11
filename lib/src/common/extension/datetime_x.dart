import 'package:intl/intl.dart';

extension DatetimeX on DateTime {
  String get localized {
    return DateFormat.yMMMd().add_jm().format(this);
  }
}
