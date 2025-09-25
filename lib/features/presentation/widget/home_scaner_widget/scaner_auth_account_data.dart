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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'issuer': issuer,
      'label': label,
      'secret': secret,
      'digits': digits,
      'period': period,
    };
  }

  factory AuthAccount.fromMap(Map<String, dynamic> map, {String? fallbackId}) {
    return AuthAccount(
      id: (map['id'] as String?) ?? fallbackId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      issuer: (map['issuer'] as String?) ?? '',
      label: (map['label'] as String?) ?? '',
      secret: (map['secret'] as String?) ?? '',
      digits: (map['digits'] is int) ? map['digits'] as int : int.tryParse('${map['digits']}') ?? 6,
      period: (map['period'] is int) ? map['period'] as int : int.tryParse('${map['period']}') ?? 30,
    );
  }

  AuthAccount copyWith({
    String? id,
    String? issuer,
    String? label,
    String? secret,
    int? digits,
    int? period,
  }) {
    return AuthAccount(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      label: label ?? this.label,
      secret: secret ?? this.secret,
      digits: digits ?? this.digits,
      period: period ?? this.period,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthAccount && other.secret == secret;
  }

  @override
  int get hashCode => secret.hashCode;
}