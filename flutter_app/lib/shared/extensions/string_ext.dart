extension StringX on String {
  /// Capitalize first letter, lowercase rest.
  String get capitalized =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();

  /// Capitalize each word.
  String get titleCased => split(' ').map((w) => w.capitalized).join(' ');

  /// Trim and return null if empty.
  String? get nullIfEmpty => trim().isEmpty ? null : trim();

  /// True if string looks like a valid email.
  bool get isValidEmail =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+ $').hasMatch(trim()) ||
      RegExp(r"^[\w.+-]+@[\w-]+\.[\w.]+$").hasMatch(trim());

  /// True if string looks like a valid URL (http/https).
  bool get isValidUrl => RegExp(
        r'^https?://[^\s/$.?#].[^\s]*$',
        caseSensitive: false,
      ).hasMatch(trim());

  /// Truncate to [maxLength] chars and append '…' if longer.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}…';
}
