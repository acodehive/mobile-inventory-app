class Validators {
  Validators._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    final parsed = num.tryParse(value);
    if (parsed == null) return '$field must be a valid number';
    if (parsed < 0) return '$field cannot be negative';
    return null;
  }

  static String? nonNegativeInt(String? value, {String field = 'Quantity'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    final parsed = int.tryParse(value);
    if (parsed == null) return '$field must be a whole number';
    if (parsed < 0) return '$field cannot be negative';
    return null;
  }

  static String? imei(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final digitsOnly = value.replaceAll(RegExp(r'\s'), '');
    if (digitsOnly.length != 15 || int.tryParse(digitsOnly) == null) {
      return 'IMEI must be exactly 15 digits';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digitsOnly = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}
