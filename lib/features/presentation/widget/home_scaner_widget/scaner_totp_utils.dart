import 'dart:typed_data';
import 'package:crypto/crypto.dart';


class TotpUtils {
  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  static Uint8List base32Decode(String input) {
    final cleaned = input.replaceAll('=', '').replaceAll(' ', '').toUpperCase();
    final bits = StringBuffer();

    for (final ch in cleaned.split('')) {
      final val = _alphabet.indexOf(ch);
      if (val < 0) continue;
      bits.write(val.toRadixString(2).padLeft(5, '0'));
    }

    final bitStr = bits.toString();
    final bytes = <int>[];
    for (var i = 0; i + 8 <= bitStr.length; i += 8) {
      final byteStr = bitStr.substring(i, i + 8);
      bytes.add(int.parse(byteStr, radix: 2));
    }
    return Uint8List.fromList(bytes);
  }

  static String generateTOTPCode({
    required String secret,
    int digits = 6,
    int period = 30,
    int? forTimeSeconds,
  }) {
    try {
      final key = base32Decode(secret);
      final unixTime =
          (forTimeSeconds != null)
              ? forTimeSeconds
              : DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final counter = unixTime ~/ period;

      final counterBytes = _int64ToBytes(counter);
      final hmac = Hmac(sha1, key);
      final digest = hmac.convert(counterBytes).bytes;

      final offset = digest[digest.length - 1] & 0x0f;
      final binary =
          ((digest[offset] & 0x7f) << 24) |
          ((digest[offset + 1] & 0xff) << 16) |
          ((digest[offset + 2] & 0xff) << 8) |
          (digest[offset + 3] & 0xff);

      final divisor = _pow10(digits);
      final otp = binary % divisor;
      return otp.toString().padLeft(digits, '0');
    } catch (e) {
      return '------';
    }
  }

  static Uint8List _int64ToBytes(int value) {
    final bytes = Uint8List(8);
    final bd = ByteData.view(bytes.buffer);
    bd.setUint64(0, value, Endian.big);
    return bytes;
  }

  static int _pow10(int d) {
    var res = 1;
    for (var i = 0; i < d; i++) {
      res *= 10;
    }
    return res;
  }
}