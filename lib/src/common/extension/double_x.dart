extension DoubleX on double? {
  String get formattedPrice {
    if (this == null) return '';
    return this!
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}
