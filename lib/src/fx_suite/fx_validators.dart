class FxValidators {
  /// Validates an email address.
  ///
  /// Returns `null` if the text is a valid email address format,
  /// otherwise returns "Type a valid email".
  /// If the text is empty, it returns "Required".
  static String? validateEmail(String text) {
    if (text.isNotEmpty) {
      return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(text)
          ? null
          : "Type a valid email";
    } else {
      return "Required";
    }
  }

  /// Validates a username text.
  ///
  /// Returns `null` if the text matches the pattern `^[\s\S]*$` and has a minimum length of 4 characters,
  /// otherwise returns "Invalid, 4 letters min".
  /// If the text is empty, it returns "Required".
  static String? validateUsernameText(String text) {
    if (text.isNotEmpty) {
      return RegExp(r'^[\s\S]*$').hasMatch(text) && text.length >= 4
          ? null
          : "Invalid, 4 letters min";
    } else {
      return "Required";
    }
  }

  /// Validate a text.
  ///
  /// If the value is invalid, it will return "Invalid".
  /// If the value is empty, it will return "Required".
  static String? validateText(String text) {
    if (text.isNotEmpty) {
      return RegExp(r'^[a-zA-Z0-9\-.,#\s/]+$').hasMatch(text)
          ? null
          : "Invalid";
    } else {
      return "Required";
    }
  }

  /// Compares two text fields. If the two texts are not equal, it will
  /// return "Passwords don't match".
  ///
  /// If the values are empty, it will return "Required".
  static String? compareText(String text1, String text2) {
    if (text1.isNotEmpty && text2.isNotEmpty) {
      return text1 == text2 ? null : "Passwords don't match";
    } else {
      return "Required";
    }
  }

  /// Validate a 10 digits phone number.
  /// If the value is invalid, it will return "Invalid".
  /// If the value is empty, it will return "Required".
  static String? validatePhoneNumber(String number, {int length = 10}) {
    if (number.isNotEmpty) {
      return RegExp('^\\d{$length}\$').hasMatch(number) ? null : "Invalid";
    } else {
      return "Required";
    }
  }

  /// Validate a double.
  /// If the value is invalid, it will return "Invalid".
  /// If the value is empty, it will return "Required".
  static String? validateDouble(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^\d*\.?\d+$').hasMatch(number) ? null : "Invalid";
    } else {
      return "Required";
    }
  }

  /// Validate a positive double.
  /// If the value is invalid, it will return "Invalid".
  /// If the value is empty, it will return "Required".
  static String? validatePositiveDouble(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^(0\.\d*[1-9]\d*|[1-9]\d*(\.\d+)?)$').hasMatch(number)
          ? null
          : "Invalid";
    } else {
      return "Required";
    }
  }

  /// Validate a positive integer.
  /// If the value is invalid, it will return "Invalid".
  /// If the value is empty, it will return "Required".
  static String? validatePositiveInt(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^[1-9]\d*$').hasMatch(number) ? null : "Invalid";
    } else {
      return "Required";
    }
  }

  /// Validate a 9 digits sequence (NCF sequence).
  /// If the value is invalid, it will return "Invalid".
  /// If the value is empty, it will return "Required".
  static String? validateNCFSequence(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^\d{9}$').hasMatch(number) ? null : "Invalid";
    } else {
      return "Required";
    }
  }

  /// Validate if the value in [minor] is minor than the value in [major].
  /// If the values are invalid, it will return "Invalid".
  /// If the values are empty, it will return "Required".
  /// If the condition is not met, it will return the [message].
  static String? validateMinorThan(String minor, String major, String message) {
    if (minor.isEmpty || major.isEmpty) {
      return "Required";
    }
    if (double.tryParse(minor) == null || double.tryParse(major) == null) {
      return "Invalid";
    }
    double minorNum = double.parse(minor);
    double majorNum = double.parse(major);
    return minorNum <= majorNum ? null : message;
  }

  /// Validate if the value in [minor] is greater than the value in [major].
  /// If the values are invalid, it will return "Invalid".
  /// If the values are empty, it will return "Required".
  /// If the condition is not met, it will return the [message].
  ///
  static String? validateGreaterThan(
      String minor, String major, String message) {
    if (minor.isEmpty || major.isEmpty) {
      return "Required";
    }
    if (double.tryParse(minor) == null || double.tryParse(major) == null) {
      return "Invalid";
    }
    double minorNum = double.parse(minor);
    double majorNum = double.parse(major);
    return majorNum >= minorNum ? null : message;
  }
}
