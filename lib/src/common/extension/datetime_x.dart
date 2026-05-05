import 'package:intl/intl.dart';

extension DateTimeX on DateTime? {
  String get localized {
    if (this == null) return '';
    return DateFormat.yMMMd().format(this!);
  }
}
