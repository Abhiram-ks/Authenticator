import 'package:encrypt/encrypt.dart' as encrypt;

class SecurityHelper {
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!'); 
  static final _iv = encrypt.IV.fromLength(16);

  static String encryptText(String text) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }
  
  static String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.decrypt64(encryptedText, iv: _iv);
  }
}
