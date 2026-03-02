enum TextCaseType {
  none,
  capitalizedTitle,
  upper,
  lower,
  capitalized,
}

extension StringX on String {
  String getTextByCasing(TextCaseType type) => switch (type) {
        TextCaseType.capitalizedTitle => toCapitalizedTitle(),
        TextCaseType.upper => toUpperCase(),
        TextCaseType.lower => toLowerCase(),
        TextCaseType.capitalized => toCapitalized(),
        TextCaseType.none => this,
      };

   double toDouble() {
    return double.tryParse(this) ?? 0.0;
  }
}

extension StringCasingExtension on String {
  String toCapitalizedTitle() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toCapitalized() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalizedTitle())
      .join(' ');
}


