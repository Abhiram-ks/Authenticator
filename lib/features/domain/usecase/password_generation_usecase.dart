import 'dart:math';
import 'package:authenticator/features/domain/entity/password_generation_entity.dart';

class PasswordGenerationUseCase {
  static const String _digits = '0123456789';
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  String generatePassword(PasswordGenerationOptions options) {
    if (!options.hasValidOptions) {
      throw ArgumentError('At least one character type must be selected and length must be greater than 0');
    }

    String availableCharacters = '';
    
    if (options.includeDigits) {
      availableCharacters += _digits;
    }
    if (options.includeLowercase) {
      availableCharacters += _lowercase;
    }
    if (options.includeUppercase) {
      availableCharacters += _uppercase;
    }
    if (options.includeSpecialCharacters) {
      availableCharacters += _specialCharacters;
    }

    if (availableCharacters.isEmpty) {
      throw ArgumentError('No character types selected');
    }

    final random = Random.secure();
    String password = '';

    // Ensure at least one character from each selected type is included
    if (options.includeDigits) {
      password += _digits[random.nextInt(_digits.length)];
    }
    if (options.includeLowercase) {
      password += _lowercase[random.nextInt(_lowercase.length)];
    }
    if (options.includeUppercase) {
      password += _uppercase[random.nextInt(_uppercase.length)];
    }
    if (options.includeSpecialCharacters) {
      password += _specialCharacters[random.nextInt(_specialCharacters.length)];
    }

    // Fill the remaining length with random characters
    for (int i = password.length; i < options.length; i++) {
      password += availableCharacters[random.nextInt(availableCharacters.length)];
    }

    // Shuffle the password to randomize the positions
    List<String> passwordList = password.split('');
    passwordList.shuffle(random);
    
    return passwordList.join('');
  }

  double calculatePasswordStrength(PasswordGenerationOptions options) {
    int entropy = 0;
    
    if (options.includeDigits) entropy += 10; // log2(10)
    if (options.includeLowercase) entropy += 26; // log2(26)
    if (options.includeUppercase) entropy += 26; // log2(26)
    if (options.includeSpecialCharacters) entropy += 32; // log2(32)
    
    // Calculate bits of entropy
    double bitsOfEntropy = options.length * (log(entropy) / ln2);
    
    // Normalize to 0-100 scale
    return (bitsOfEntropy / 100 * 100).clamp(0, 100);
  }

  String getStrengthDescription(double strength) {
    if (strength < 30) return 'Weak';
    if (strength < 60) return 'Medium';
    if (strength < 80) return 'Strong';
    return 'Very Strong';
  }
}
