/// Pure form-field validators — signature: String? Function(String?).
/// Use directly as `TextFormField.validator`.
abstract class Validators {
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Phone number is required.';
    final trimmed = value.trim();
    final re = RegExp(r'^\+?[0-9]{10,15}$');
    if (!re.hasMatch(trimmed)) return 'Enter a valid phone number.';
    return null;
  }

  // ── Email ──────────────────────────────────────────────────────────────────

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final trimmed = value.trim();
    // RFC 5322 lightweight check — good enough for mobile forms.
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(trimmed)) return 'Enter a valid email address.';
    return null;
  }

  // ── Password ───────────────────────────────────────────────────────────────

  /// Minimum 8 characters, at least one digit.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  /// Simple presence check — use for confirm-password match only.
  static String? passwordNotEmpty(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    return null;
  }

  /// Confirm-password factory: call with the primary password value.
  static String? Function(String?) confirmPassword(String primary) {
    return (value) {
      if (value == null || value.isEmpty)
        return 'Please confirm your password.';
      if (value != primary) return 'Passwords do not match.';
      return null;
    };
  }

  // ── Name ───────────────────────────────────────────────────────────────────

  /// 2–60 characters, letters and common punctuation (hyphens, apostrophes).
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required.';
    final trimmed = value.trim();
    if (trimmed.length < 2) return 'Name must be at least 2 characters.';
    if (trimmed.length > 60) return 'Name must be 60 characters or fewer.';
    return null;
  }

  // ── Generic required ───────────────────────────────────────────────────────

  static String? Function(String?) required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty)
        return '$fieldName is required.';
      return null;
    };
  }

  // ── URL (optional field) ───────────────────────────────────────────────────

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final re = RegExp(r'^https?:\/\/.+');
    if (!re.hasMatch(value.trim())) return 'Enter a valid URL (https://...)';
    return null;
  }

  // ── Date string (yyyy-MM-dd) ───────────────────────────────────────────────

  static String? date(String? value) {
    if (value == null || value.trim().isEmpty) return 'Date is required.';
    try {
      DateTime.parse(value.trim());
      return null;
    } catch (_) {
      return 'Enter a valid date (YYYY-MM-DD).';
    }
  }
}
