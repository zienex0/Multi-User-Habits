class FormValidator {
  static final String _emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  static String? validateEmail(String email) {
    email = email.trim();
    final RegExp regex = RegExp(_emailRegex);
    if (email.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? validateRequired(String fieldName, String value) {
    value = value.trim();
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePassword(String password) {
    password = password.trim();
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password has to be at least 6 characters long';
    }

    return null;
  }
}
