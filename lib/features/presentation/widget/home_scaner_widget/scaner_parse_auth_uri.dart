
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';

AuthAccount? parseOtpAuthUri(String uriStr) {
  try {
    final uri = Uri.parse(uriStr);
    if (uri.scheme != 'otpauth') return null;
    if (uri.host.toLowerCase() != 'totp') return null;

    String path = uri.path;
    if (path.startsWith('/')) path = path.substring(1);
    String issuerFromPath = '';
    String label = path;
    if (path.contains(':')) {
      final parts = path.split(':');
      issuerFromPath = parts.first;
      label = parts.sublist(1).join(':');
    }

    final params = uri.queryParameters;
    final secret = params['secret'];
    if (secret == null || secret.trim().isEmpty) return null;

    String issuer = params['issuer'] ?? issuerFromPath;
    final digits = int.tryParse(params['digits'] ?? '') ?? 6;
    final period = int.tryParse(params['period'] ?? '') ?? 30;

    return AuthAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      issuer: issuer,
      label: label,
      secret: secret,
      digits: digits,
      period: period,
    );
  } catch (e) {
    return null;
  }
}