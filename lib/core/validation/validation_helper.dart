class ValidatorHelper {

  static String? textFieldValidation(String? data,) {
    if (data == null || data.trim().isEmpty) {
      return "Please enter Code to varify";
    } else if (data.startsWith(' ')) {
      return "Code cannot start with a space";
    }
    return null;
  }

    static String? validateField(String fieldName, String? value) {
    final data = value?.trim() ?? "";

    if (data.isEmpty) {
      return "$fieldName cannot be empty";
    }
    if (value!.startsWith(' ')) {
      return "$fieldName cannot start with a space";
    }

    switch (fieldName.toLowerCase()) {
      case "email":
        final emailRegex =
            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
        if (!emailRegex.hasMatch(data)) {
          return "Enter a valid email address";
        }
        break;

      case "url":
        final urlRegex =
            RegExp(r"^(http|https):\/\/[^\s$.?#].[^\s]*$");
        if (!urlRegex.hasMatch(data)) {
          return "Enter a valid URL";
        }
        break;

      case "password":
      case "pin":
        if (data.length < 4) {
          return "$fieldName must be at least 4 characters";
        }
        break;

      case "card number":
        if (data.length < 12 || data.length > 19) {
          return "Card Number must be 12–19 digits";
        }
        if (!RegExp(r"^[0-9]+$").hasMatch(data)) {
          return "Card Number must contain only digits";
        }
        break;

      case "expiry date":
        if (!RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2}|[0-9]{4})$")
            .hasMatch(data)) {
          return "Use MM/YY format";
        }
        break;

      case "postal code":
      case "zip code":
      case "postal code or zip code":
        if (data.length < 4) {
          return "Enter a valid Postal/Zip Code";
        }
        break;

      case "phone":
      case "cell phone":
      case "home phone":
        if (!RegExp(r"^[0-9]{7,15}$").hasMatch(data)) {
          return "Enter a valid phone number";
        }
        break;

      default:
        return null;
    }
    return null;
  }
}
