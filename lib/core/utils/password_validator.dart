/// Password validation utility to match backend requirements
/// 
/// Backend requires:
/// - Minimum 8 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one number
/// - At least one special character (@$!%*?&)
class PasswordValidator {
  /// Validates password strength and returns error message if invalid
  /// Returns null if password is valid
  static String? validate(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!password.contains(RegExp(r'[@$!%*?&]'))) {
      return 'Password must contain at least one special character (@$!%*?&)';
    }

    return null;
  }

  /// Returns a list of password requirements for display
  static List<String> getRequirements() {
    return [
      'At least 8 characters long',
      'At least one uppercase letter (A-Z)',
      'At least one lowercase letter (a-z)',
      'At least one number (0-9)',
      'At least one special character (@$!%*?&)',
    ];
  }
}

