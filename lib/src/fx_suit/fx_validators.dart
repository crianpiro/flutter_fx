class FxValidators {
  static String? validateEmail(String text) {
    if (text.isNotEmpty) {
      return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(text)
          ? null
          : "Ingrese una direccion de correo valida.";
    } else {
      return "Requerido";
    }
  }

  static String? validateUsernameText(String text) {
    if (text.isNotEmpty) {
      return RegExp(r'^[\s\S]*$').hasMatch(text) && text.length >= 4
          ? null
          : "Invalido, minimo 4 letras";
    } else {
      return "Requerido";
    }
  }

  static String? validateText(String text) {
    if (text.isNotEmpty) {
      return RegExp(r'^[a-zA-Z0-9\-.,#\s/]+$').hasMatch(text)
          ? null
          : "Invalido";
    } else {
      return "Requerido";
    }
  }

  static String? compareText(String text1, String text2) {
    if (text1.isNotEmpty && text2.isNotEmpty) {
      return text1 == text2 ? null : "Las contraseñas no concuerdan";
    } else {
      return "Requerido";
    }
  }

  static String? validatePhoneNumber(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^\d{10}$').hasMatch(number) ? null : "Invalido";
    } else {
      return "Requerido";
    }
  }

  static String? validateDouble(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^\d*\.?\d+$').hasMatch(number) ? null : "Invalido";
    } else {
      return "Requerido";
    }
  }

  static String? validatePositiveDouble(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^(0\.\d*[1-9]\d*|[1-9]\d*(\.\d+)?)$').hasMatch(number) ? null : "Invalido";
    } else {
      return "Requerido";
    }
  }

  static String? validatePositiveInt(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^[1-9]\d*$').hasMatch(number) ? null : "Invalido";
    } else {
      return "Requerido";
    }
  }

  static String? validateNCFSequence(String number) {
    if (number.isNotEmpty) {
      return RegExp(r'^\d{9}$').hasMatch(number) ? null : "Invalido";
    } else {
      return "Requerido";
    }
  }

  static String? validateMinorThan(String minor, String major, String message) {
    if(minor.isEmpty || major.isEmpty){
      return "Requerido";
    }
    if(double.tryParse(minor) == null || double.tryParse(major) == null){
      return "Invalido";
    }
    double minorNum = double.parse(minor);
    double majorNum = double.parse(major);
    return minorNum <= majorNum ? null : message;
  }

  static String? validateGreaterThan(String minor, String major, String message) {
    if(minor.isEmpty || major.isEmpty){
      return "Requerido";
    }
    if(double.tryParse(minor) == null || double.tryParse(major) == null){
      return "Invalido";
    }
    double minorNum = double.parse(minor);
    double majorNum = double.parse(major);
    return majorNum >= minorNum ? null : message;
  }
}
