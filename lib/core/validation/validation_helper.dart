class ValidatorHelper {

  static String? textFieldValidation(String? data,) {
    if (data == null || data.trim().isEmpty) {
      return "Please enter Code to varify";
    } else if (data.startsWith(' ')) {
      return "Code cannot start with a space";
    }
    return null;
  }
}
