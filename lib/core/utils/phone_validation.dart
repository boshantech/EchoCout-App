/// Phone validation rules and utilities for different countries
/// 
/// Currently supports: India 🇮🇳

/// Phone number validation result
class PhoneValidationResult {
  /// Whether the phone number is valid
  final bool isValid;
  
  /// Error message if invalid
  final String? errorMessage;
  
  /// Number of digits in the input
  final int digitCount;
  
  /// Formatted display (for UI)
  final String displayText;

  const PhoneValidationResult({
    required this.isValid,
    this.errorMessage,
    required this.digitCount,
    required this.displayText,
  });

  /// Factory constructor for invalid state
  factory PhoneValidationResult.invalid({
    required String input,
    required String? errorMessage,
  }) {
    final digitCount = input.replaceAll(RegExp(r'\D'), '').length;
    return PhoneValidationResult(
      isValid: false,
      errorMessage: errorMessage,
      digitCount: digitCount,
      displayText: input,
    );
  }

  /// Factory constructor for valid state
  factory PhoneValidationResult.valid({
    required String input,
  }) {
    return PhoneValidationResult(
      isValid: true,
      errorMessage: null,
      digitCount: input.replaceAll(RegExp(r'\D'), '').length,
      displayText: input,
    );
  }
}

/// Country-specific phone configuration
class CountryPhoneConfig {
  /// Country code (e.g., "+91" for India)
  final String code;
  
  /// Country name
  final String name;
  
  /// Emoji flag
  final String flag;
  
  /// Required phone number length (digits only)
  final int phoneLength;
  
  /// Phone number format hint (e.g., "000 000 0000")
  final String formatHint;

  const CountryPhoneConfig({
    required this.code,
    required this.name,
    required this.flag,
    required this.phoneLength,
    required this.formatHint,
  });
}

/// Phone validation utility
/// 
/// Handles country-specific validation rules for phone numbers
class PhoneValidator {
  /// India phone configuration
  static const CountryPhoneConfig india = CountryPhoneConfig(
    code: '+91',
    name: 'India',
    flag: '🇮🇳',
    phoneLength: 10,
    formatHint: '000 000 0000',
  );

  /// Get country configuration by code
  static CountryPhoneConfig? getCountryByCode(String code) {
    if (code == '+91') return india;
    return null;
  }

  /// Validate phone number for a given country
  /// 
  /// Returns validation result with error message if invalid
  static PhoneValidationResult validatePhone({
    required String phoneInput,
    required String countryCode,
  }) {
    // Get country configuration
    final country = getCountryByCode(countryCode);
    if (country == null) {
      return PhoneValidationResult.invalid(
        input: phoneInput,
        errorMessage: 'Unsupported country',
      );
    }

    // Extract only digits
    final digitsOnly = phoneInput.replaceAll(RegExp(r'\D'), '');

    // Check if valid
    if (digitsOnly.length == country.phoneLength) {
      return PhoneValidationResult.valid(input: phoneInput);
    }

    // Return invalid with appropriate error message
    return PhoneValidationResult.invalid(
      input: phoneInput,
      errorMessage: 'Enter a valid ${country.phoneLength}-digit mobile number',
    );
  }

  /// Format phone number for display
  /// 
  /// For India: "9876543210" → "987 654 3210"
  static String formatPhoneForDisplay({
    required String phoneInput,
    required String countryCode,
  }) {
    final country = getCountryByCode(countryCode);
    if (country == null) return phoneInput;

    final digitsOnly = phoneInput.replaceAll(RegExp(r'\D'), '');

    if (countryCode == '+91') {
      // India format: XXX XXX XXXX
      if (digitsOnly.length == 10) {
        return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
      } else if (digitsOnly.length >= 3) {
        final part1 = digitsOnly.substring(0, 3);
        final remaining = digitsOnly.substring(3);
        if (remaining.length > 3) {
          final part2 = remaining.substring(0, 3);
          final part3 = remaining.substring(3);
          return '$part1 $part2 $part3';
        }
        return '$part1 $remaining';
      }
    }

    return digitsOnly;
  }

  /// Get the maximum phone length for a country
  static int getMaxPhoneLength(String countryCode) {
    return getCountryByCode(countryCode)?.phoneLength ?? 15;
  }

  /// Check if phone number is valid (quick check)
  static bool isPhoneValid({
    required String phoneInput,
    required String countryCode,
  }) {
    final validation = validatePhone(
      phoneInput: phoneInput,
      countryCode: countryCode,
    );
    return validation.isValid;
  }

  /// Extract only digits from phone input
  static String extractDigits(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }
}
