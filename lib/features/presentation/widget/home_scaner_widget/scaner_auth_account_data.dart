class AuthAccount {
  final String id;
  final String issuer;
  final String label;
  final String secret;
  final int digits;
  final int period;

  AuthAccount({
    required this.id,
    required this.issuer,
    required this.label,
    required this.secret,
    this.digits = 6,
    this.period = 30,
  });
}