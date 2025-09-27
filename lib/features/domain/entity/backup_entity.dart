class BackupEntity {
  final bool backup;
  final String userId;
  final DateTime? updatedAt;

  const BackupEntity({
    required this.backup,
    required this.userId,
    this.updatedAt,
  });
}
