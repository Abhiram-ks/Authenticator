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

  // Define which fields are REQUIRED
  final requiredFields = [
    "name",
    "username",
    "password",
    "url",
    "email",
    "card number",
    "expiry date",
    "pin",
    "Postal Code or Zip Code",
    "home phone",
  ];

  // Check required fields
  if (requiredFields.contains(fieldName.toLowerCase())) {
    if (data.isEmpty) {
      return "$fieldName cannot be empty";
    }
    if (value!.startsWith(' ')) {
      return "$fieldName cannot start with a space";
    }
  } else {
    // Optional field → allow empty
    if (data.isEmpty) return null;
  }

  switch (fieldName.toLowerCase()) {
    case "email":
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      if (!emailRegex.hasMatch(data)) {
        return "Enter a valid email address";
      }
      break;

    case "url":
      final urlRegex = RegExp(r"^(http|https):\/\/[^\s$.?#].[^\s]*$");
      if (!urlRegex.hasMatch(data)) {
        return "Enter a valid URL (http/https)";
      }
      break;

    case "pin":
      if (data.length < 4) {
        return "Pin must be at least 4 digits";
      }
      if (!RegExp(r"^[0-9]+$").hasMatch(data)) {
        return "Pin must contain only digits";
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
      if (!RegExp(r"^(0[1-9]|1[0-2])\/([0-9]{2})$").hasMatch(data)) {
        return "Use MM/YY format";
      }
      break;

    case "postal code or zip code":
      if (data.length < 4) {
        return "Enter a valid Postal/Zip Code";
      }
      break;

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